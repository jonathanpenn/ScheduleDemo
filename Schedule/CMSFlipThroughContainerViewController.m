#import "CMSFlipThroughContainerViewController.h"

@interface CMSFlipThroughContainerViewController ()

@property (nonatomic, weak) UIViewController *currentViewController;

@end

@implementation CMSFlipThroughContainerViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Public Actions

- (void)setViewController:(UIViewController *)controller
{
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController = controller;
    [self addChildViewController:self.currentViewController];
    [self.view addSubview: self.currentViewController.view];
    [self setUpViewControllerView:controller];
}

- (void)flipUpWithViewController:(UIViewController *)controller animated:(BOOL)animated
{
    [self swapViewControllers:controller direction:1 animated:animated];
}

- (void)flipDownWithViewController:(UIViewController *)controller animated:(BOOL)animated
{
    [self swapViewControllers:controller direction:-1 animated:animated];
}


#pragma Private Utilities

- (void)swapViewControllers:(UIViewController *)controller direction:(NSInteger)direction animated:(BOOL)animated
{
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    [self setUpViewControllerView:controller];

    CGPoint newControllerCenter = controller.view.center;
    newControllerCenter.y += direction * controller.view.bounds.size.height;
    controller.view.center = newControllerCenter;

    [UIView animateWithDuration:0.2 animations:^{
        CGPoint oldControllerCenter = self.currentViewController.view.center;
        controller.view.center = CGPointMake(oldControllerCenter.x, oldControllerCenter.y + (10 * (0-direction)));
        oldControllerCenter.y += self.currentViewController.view.bounds.size.height * (0-direction);
        self.currentViewController.view.center = oldControllerCenter;
    } completion:^(BOOL finished) {
        CGPoint afterBounceCenter = controller.view.center;
        afterBounceCenter.y += 10 * direction;
        [UIView animateWithDuration:0.1 animations:^{
            controller.view.center = afterBounceCenter;
        }];
        [self.currentViewController.view removeFromSuperview];
        // [self.currentViewController removeFromParentViewController];
        self.currentViewController = controller;
    }];
}

- (void)setUpViewControllerView:(UIViewController *)controller
{
    controller.view.frame = self.view.bounds;
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
}

@end
