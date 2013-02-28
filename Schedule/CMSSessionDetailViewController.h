#import <UIKit/UIKit.h>
#import "CMSCommonViewController.h"
#import "CMSScheduleDataSource.h"

@class CMSSession, CMSStarView;

@interface CMSSessionDetailViewController : CMSCommonViewController
<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *topicControl;
@property (weak, nonatomic) IBOutlet UILabel *speakerControl;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UITextView *abstractControl;
@property (weak, nonatomic) IBOutlet UIView *clickableSpeakerView;
@property (weak, nonatomic) IBOutlet UILabel *whenControl;
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet CMSStarView *starView;
@property (weak, nonatomic) IBOutlet UIView *speakerRowView;
@property (weak, nonatomic) IBOutlet UIButton *showSpeakerButton;

@property (weak, nonatomic) id<CMSScheduleDataSource> scheduleDataSource;

@property (nonatomic, strong) CMSSession *session;

@end
