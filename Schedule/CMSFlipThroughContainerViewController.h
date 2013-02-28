#import <UIKit/UIKit.h>

@interface CMSFlipThroughContainerViewController : UIViewController

- (void)setViewController:(UIViewController *)controller;
- (void)flipUpWithViewController:(UIViewController *)controller animated:(BOOL)animated;
- (void)flipDownWithViewController:(UIViewController *)controller animated:(BOOL)animated;

@end
