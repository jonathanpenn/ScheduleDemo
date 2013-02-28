#import "CMSSpeakerAvatar.h"

@implementation CMSSpeakerAvatar

@dynamic imageData;

+ (NSString *)entityName { return @"SpeakerAvatar"; }

+ (instancetype)insertInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:context];
}

- (UIImage *)image
{
    return [UIImage imageWithData:self.imageData];
}

- (void)setImage:(UIImage *)image
{
    self.imageData = UIImagePNGRepresentation(image);
}

@end
