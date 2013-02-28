#import <QuartzCore/QuartzCore.h>
#import "CMSSessionDetailViewController.h"
#import "CMSFlipThroughContainerViewController.h"
#import "CMSSpeakerDetailViewController.h"
#import "CMSSpeaker.h"
#import "CMSSession.h"
#import "CMSStarView.h"
#import "CMSSpeakerAvatar.h"
#import "CMSDataLoader.h"

@implementation CMSSessionDetailViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureView) name:NSManagedObjectContextObjectsDidChangeNotification object:self.session.managedObjectContext];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.clickableSpeakerView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    CGRect newFrame = self.abstractControl.bounds;
    newFrame.origin = self.showSpeakerButton.frame.origin;
    newFrame.origin.x += 13;
    newFrame.origin.y += self.showSpeakerButton.bounds.size.height + 20;
    newFrame.size = self.abstractControl.contentSize;
    self.abstractControl.frame = newFrame;

    UIScrollView *scrollView = (UIScrollView *)self.view;
    CGSize newContentSize = scrollView.contentSize;
    newContentSize.height = newFrame.origin.y + newFrame.size.height + 20;
    scrollView.contentSize = newContentSize;
}


#pragma mark - IBActions

- (IBAction)starButtonTapped:(id)sender
{
    [self.session toggleFavorite];
    [self.session.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        if (![self.session.managedObjectContext save:&error]) {
            NSLog(@"unable to toggle favorite: %@", error);
        }
    }];

    [UIView animateWithDuration:0.05 animations:^{
        self.starView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.starView.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (IBAction)showSpeakerTapped:(id)sender
{
    // Restored in view did disappear
    self.clickableSpeakerView.backgroundColor = [UIColor colorWithWhite:0.795 alpha:1.000];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushSpeakerDetail"]) {
        CMSSpeakerDetailViewController *controller = segue.destinationViewController;
        controller.speaker = self.session.speaker;
    }
}


#pragma mark - Scroll View

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    static CGFloat const pullRange = 50;
    static CGFloat const maxVelocity = 0.09;
    CGFloat y = scrollView.contentOffset.y;

    // Only trigger when not "whipping" fast
    if (abs(velocity.y) > maxVelocity) return;
    // Only trigger if pulled far enough
    if (y > 0-pullRange && y < (scrollView.contentSize.height - scrollView.bounds.size.height) + pullRange) return;

    CMSFlipThroughContainerViewController *flipThroughController = (CMSFlipThroughContainerViewController *)self.parentViewController;
    CMSSessionDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CMSSessionDetailViewController class])];
    controller.scheduleDataSource = self.scheduleDataSource;

    CMSSession *newSession = nil;
    if (y < 0) {
        newSession = [self.scheduleDataSource prevSessionInListBefore:self.session];
        if (!newSession) return;
        controller.session = newSession;
        [flipThroughController flipDownWithViewController:controller animated:YES];
    } else {
        newSession = [self.scheduleDataSource nextSessionInListAfter:self.session];
        if (!newSession) return;
        controller.session = newSession;
        [flipThroughController flipUpWithViewController:controller animated:YES];
    }
}


#pragma mark - Setup Methods

- (void)configureView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, h:mm a"];

    self.topicControl.text = self.session.topic;
    self.speakerControl.text = self.session.speaker.name;
    self.abstractControl.text = self.session.abstract;
    self.whenControl.text = [formatter stringFromDate:self.session.start];

    if (self.session.speaker.avatar) {
        self.avatarView.image = self.session.speaker.avatar.image;
    } else {
        [[CMSDataLoader sharedLoader] fetchAndRefreshAvatarForSpeaker:self.session.speaker completion:^(NSError *error) {
            if (error) NSLog(@"Unable to load avatar for speaker: %@", error);
        }];
    }

    if ([self.session.isFavorite boolValue]) {
        self.starView.isFilled = YES;
    } else {
        self.starView.isFilled = NO;
    }
}


@end
