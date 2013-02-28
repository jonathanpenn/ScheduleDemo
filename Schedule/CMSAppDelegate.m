#import "CMSAppDelegate.h"
#import "CMSDocument.h"
#import "CMSDataLoader.h"
#import "CMSTestSetup.h"

@implementation CMSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[[CMSTestSetup alloc] init] setUpIfInTestEnvironment];

    NSError *error = nil;
    if (![[CMSDocument sharedDocument] initializeDocument:&error]) {
        NSLog(@"Unable to initialize Core Data document: %@", error);
        abort();
    }

    [[CMSDataLoader sharedLoader] fetchAndRefreshData:^(NSError *error) {
        if (error) NSLog(@"Unable to fetch data for schedule: %@", error);
    }];

    return YES;
}


@end
