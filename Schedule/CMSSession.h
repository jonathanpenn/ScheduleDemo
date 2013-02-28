#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CMSSpeaker;

@interface CMSSession : NSManagedObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *topic;
@property (nonatomic, strong) NSString *abstract;
@property (nonatomic, strong) NSNumber *isFavorite;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSNumber *length;
@property (nonatomic, strong) CMSSpeaker *speaker;

+ (NSString *)entityName;
+ (instancetype)findById:(NSString *)id inContext:(NSManagedObjectContext *)context;
+ (instancetype)insertInContext:(NSManagedObjectContext *)context;
- (void)populateFromDictionary:(NSDictionary *)dict;

- (void)toggleFavorite;

@end
