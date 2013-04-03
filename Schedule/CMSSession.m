#import "CMSSession.h"
#import "CMSSpeaker.h"

@implementation CMSSession

@dynamic id;
@dynamic topic;
@dynamic abstract;
@dynamic isFavorite;
@dynamic start;
@dynamic length;
@dynamic speaker;

+ (NSString *)entityName { return @"Session"; }

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
    static NSDateFormatter *dateParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateParser = [[NSDateFormatter alloc] init];
        [dateParser setDateFormat:@"yyyy-MM-dd H:m"];
    });

    self.id = dict[@"id"];
    self.topic = dict[@"topic"];
    self.start = [dateParser dateFromString:dict[@"start"]];
    self.abstract = dict[@"abstract"];
    self.length = @([dict[@"length"] floatValue]);
}

- (void)toggleFavorite
{
    if ([self.isFavorite boolValue]) self.isFavorite = @NO;
    else self.isFavorite = @YES;
}

@end
