#import "CMSTestSetup.h"
#import "CMSDocument.h"
#import "CMSDataLoader.h"
#import "CMSDataLoaderStub.h"

static NSString * ENV(NSString *name)
{
    return [[NSProcessInfo processInfo] environment][name];
}

@implementation CMSTestSetup

- (void)setUpIfInTestEnvironment
{
    // Bail out if we're not in the UI Tests (set in scheme)
    if (!ENV(@"UI_TESTS")) return;

    NSError *error = nil;
    CMSDocument *document = [CMSDocument sharedDocument];
    if (![document deleteAndReset:&error]) {
        NSLog(@"Unable to delete and reset the document: %@", error);
    }

    CMSDataLoaderStub *stubbedDataLoader = [[CMSDataLoaderStub alloc] initWithDocument:document];
    [CMSDataLoader setSharedLoader:stubbedDataLoader];
}

@end
