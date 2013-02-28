#import "CMSDataLoader+GCDHelpers.h"

@implementation CMSDataLoader (GCDHelpers)

- (void)sync_main:(void(^)())block
{
    dispatch_sync(dispatch_get_main_queue(), block);
}

- (void)private_queue:(void(^)())block
{
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("net.cocoamanifest.background", 0);
    });
    dispatch_async(queue, block);
}

@end
