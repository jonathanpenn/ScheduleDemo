#import "CMSDataLoader.h"
#import "CMSSpeaker.h"
#import "CMSSession.h"
#import "CMSSpeakerAvatar.h"
#import "CMSDocument.h"
#import "CMSDataLoader+GCDHelpers.h"

@interface CMSDataLoader ()

@property (nonatomic, readonly) NSURL *dataURL;

@end

static CMSDataLoader *sharedLoader = nil;

@implementation CMSDataLoader

#pragma mark - Initialization

+ (instancetype)sharedLoader
{
    @synchronized(self) {
        if (!sharedLoader) {
            sharedLoader = [[CMSDataLoader alloc] initWithDocument:[CMSDocument sharedDocument]];
        }
    }
    return sharedLoader;
}

+ (void)setSharedLoader:(CMSDataLoader *)loader
{
    @synchronized(self) {
        sharedLoader = loader;
    }
}

- (id)initWithDocument:(CMSDocument *)document
{
    self = [super init];
    if (self) { _document = document; }
    return self;
}


#pragma mark - Exposed public methods

- (void)fetchAndRefreshData:(void (^)(NSError *))completion
{
    // If caller didn't pass a completion handler, build one as a noop
    if (!completion) completion = ^(NSError *error){};

    [self private_queue:^{
        NSManagedObjectContext *localContext = [self.document newChildContextWithConcurrencyType:NSPrivateQueueConcurrencyType];

        __block NSError *error = nil;
        // Yeah, yeah, we're pulling the JSON feed from a static resource stored
        // on S3. Work with me here. Pretend this is live. :)
        NSURL *dataURL = [NSURL URLWithString:@"http://nl1551.s3.amazonaws.com/cocoamanifest.net/2013/cocoaconf-chicago-json/sessions.json"];
        NSArray *array = [self fetchJSONDataFromURL:dataURL error:&error];

        if (!array) {
            [self sync_main:^{ completion(error); }];
            return;
        }

        for (NSDictionary *dict in array) {
            NSString *id = dict[@"id"];
            CMSSession *session = [CMSSession findById:id inContext:localContext];
            if (!session) session = [CMSSession insertInContext:localContext];
            [session populateFromDictionary:dict];

            NSDictionary *speakerDict = dict[@"speaker"];
            NSString *speakerId = speakerDict[@"id"];
            CMSSpeaker *speaker = [CMSSpeaker findById:speakerId inContext:localContext];
            if (!speaker) speaker = [CMSSpeaker insertInContext:localContext];
            [speaker populateFromDictionary:speakerDict];

            if (![session.speaker isEqual:speaker]) {
                [speaker addSessionsObject:session];
            }

            if (speaker.avatar) {
                [localContext deleteObject:speaker.avatar];
            }
        }
        
        if (![localContext save:&error]) {
            [self sync_main:^{ completion(error); }];
        } else if (![self.document save:&error]) {
            [self sync_main:^{ completion(error); }];
        } else {
            [self sync_main:^{ completion(nil); }];
        }
    }];
}

- (void)fetchAndRefreshAvatarForSpeaker:(CMSSpeaker *)externalSpeaker completion:(void (^)(NSError *))completion
{
    [self private_queue:^{
        __block NSError *error = nil;
        NSManagedObjectContext *localContext = [self.document newChildContextWithConcurrencyType:NSPrivateQueueConcurrencyType];

        CMSSpeaker *speaker = (CMSSpeaker *)[localContext objectWithID:externalSpeaker.objectID];
        if (!speaker.avatarURL || speaker.avatar) {
            if (completion) [self sync_main:^{ completion(nil); }];
        }

        NSData *imageData = [self fetchImageDataAtURL:speaker.avatarURL error:&error];
        if (!imageData) return;

        CMSSpeakerAvatar *avatar = [CMSSpeakerAvatar insertInContext:localContext];
        avatar.imageData = imageData;
        speaker.avatar = avatar;

        if ([localContext save:&error]) {
            if ([self.document save:&error]) error = nil;
        }

        if (completion) [self sync_main:^{ completion(error); }];
    }];
}


#pragma mark - Network Fetching Methods

- (NSArray *)fetchJSONDataFromURL:(NSURL *)url error:(NSError **)error
{
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:error];
    if (!data) return nil;

    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

- (NSData *)fetchImageDataAtURL:(NSURL *)url error:(NSError **)error
{
    return [NSData dataWithContentsOfURL:url options:0 error:error];
}


@end
