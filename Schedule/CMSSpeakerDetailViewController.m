#import <QuartzCore/QuartzCore.h>
#import "CMSSpeakerDetailViewController.h"
#import "CMSSpeaker.h"
#import "CMSSpeakerAvatar.h"

@implementation CMSSpeakerDetailViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSwipeToGoBack];
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = 5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    CGRect newFrame = self.bioControl.bounds;
    newFrame.origin = self.avatarView.frame.origin;
    newFrame.origin.x -= 8;
    newFrame.origin.y += self.avatarView.bounds.size.height + 20;
    newFrame.size = self.bioControl.contentSize;
    self.bioControl.frame = newFrame;

    UIScrollView *scrollView = (UIScrollView *)self.view;
    CGSize newContentSize = scrollView.contentSize;
    newContentSize.height = newFrame.origin.y + newFrame.size.height + 20;
    scrollView.contentSize = newContentSize;
}


#pragma mark - Configuration

- (void)configureView
{
    self.nameControl.text = self.speaker.name;
    self.bioControl.text = self.speaker.bio;
    if (self.speaker.avatar) {
        self.avatarView.image = self.speaker.avatar.image;
    }
}


@end
