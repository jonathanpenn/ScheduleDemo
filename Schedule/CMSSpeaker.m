#import "CMSSpeaker.h"
#import "CMSSession.h"

@interface CMSSpeaker ()

@property (nonatomic, strong) NSString *avatarURLString;

@end

@implementation CMSSpeaker

@dynamic name;
@dynamic id;
@dynamic bio;
@dynamic avatarURLString;
@dynamic sessions;
@dynamic avatar;

+ (NSString *)entityName { return @"Speaker"; }

+ (instancetype)findById:(NSString *)id inContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", id];
    [request setPredicate:pred];

    NSArray *results = [context executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Unable to execute request: %@", error);
        return nil;
    }

    if ([results count] == 0) return nil;
    else return results[0];
}

+ (instancetype)insertInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:context];
}

- (void)populateFromDictionary:(NSDictionary *)dict
{
    self.id = dict[@"id"];
    self.name = dict[@"name"];
    self.bio = dict[@"bio"];
    self.avatarURL = [NSURL URLWithString:dict[@"avatar"]];
}

- (NSURL *)avatarURL
{
    return [NSURL URLWithString:self.avatarURLString];
}

- (void)setAvatarURL:(NSURL *)avatarURL
{
    [self setAvatarURLString:avatarURL.absoluteString];
}

@end
