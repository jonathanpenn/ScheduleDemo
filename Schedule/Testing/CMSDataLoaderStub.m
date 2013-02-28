#import "CMSDataLoaderStub.h"
#import "CMSDocument.h"
#import "CMSSpeaker.h"
#import "CMSSpeakerAvatar.h"
#import "CMSDataLoader+GCDHelpers.h"

@interface  CMSDataLoaderStub  ()
@property (nonatomic, strong) NSData *fakeAvatarImageData;
@end

@implementation CMSDataLoaderStub

// Overridden to log message before delegating to superclass
- (void)fetchAndRefreshData:(void (^)(NSError *))completion
{
    NSLog(@"Stubbed loading of JSON data");
    [super fetchAndRefreshData:completion];
}

// Overridden to log message before delegating to superclass
- (void)fetchAndRefreshAvatarForSpeaker:(CMSSpeaker *)speaker completion:(void (^)(NSError *))completion
{
    NSLog(@"Stubbed loading of avatar for %@", speaker.name);
    [super fetchAndRefreshAvatarForSpeaker:speaker completion:completion];
}

// Called by superclass to do the actual fetching of the JSON data.
// Overridden to load from bundle instead.
- (NSArray *)fetchJSONDataFromURL:(NSURL *)ignoredURL error:(NSError **)error
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"data" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:error];
    if (!data) return nil;
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

// Called by superclass to do the actual fetching of image data at a URL.
// Overridden to load return stubbed image data.
- (NSData *)fetchImageDataAtURL:(NSURL *)url error:(NSError **)error
{
    return self.fakeAvatarImageData;
}


#pragma mark - Helper method to generate image data

- (NSData *)fakeAvatarImageData
{
    if (!_fakeAvatarImageData) {
        NSError *error = nil;
        NSURL *fakeURL = [[NSBundle mainBundle] URLForResource:@"fakeavatar" withExtension:@"png"];
        _fakeAvatarImageData = [NSData dataWithContentsOfURL:fakeURL options:0 error:&error];

        if (!_fakeAvatarImageData) {
            NSLog(@"Unable to load fake avatar image data: %@", error);
            abort();
        }
    }
    return _fakeAvatarImageData;
}

@end
