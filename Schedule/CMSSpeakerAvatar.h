#import <CoreData/CoreData.h>

@interface CMSSpeakerAvatar : NSManagedObject

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) UIImage *image;

+ (NSString *)entityName;
+ (instancetype)insertInContext:(NSManagedObjectContext *)context;

@end
