#import "CMSDataLoader.h"

// These helper methods make it easier for the data loader to queue up blocks
// on the appropriate queues. They just wrap the GCD calls to make it cleaner.

@interface CMSDataLoader (GCDHelpers)

- (void)sync_main:(void(^)())block;
- (void)private_queue:(void(^)())block;

@end
