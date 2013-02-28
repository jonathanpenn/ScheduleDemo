#import "CMSCommonViewController.h"

@implementation CMSCommonViewController

- (void)setupSwipeToGoBack
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(common_swiped)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];

    UISwipeGestureRecognizer *doubleSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(common_doubleSwiped)];
    doubleSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    doubleSwipe.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleSwipe];
}

- (void)common_swiped
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)common_doubleSwiped
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
