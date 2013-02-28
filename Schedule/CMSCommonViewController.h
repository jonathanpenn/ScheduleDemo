#import <UIKit/UIKit.h>

// A view controller you can subclass to quickly add "swipe to go back" and
// "double swipe to pop to root". Just call the setup method in viewDidLoad.

@interface CMSCommonViewController : UIViewController

- (void)setupSwipeToGoBack;

@end
