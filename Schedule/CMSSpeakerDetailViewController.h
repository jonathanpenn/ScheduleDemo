#import <UIKit/UIKit.h>
#import "CMSCommonViewController.h"

@class CMSSpeaker;

@interface CMSSpeakerDetailViewController : CMSCommonViewController

@property (weak, nonatomic) IBOutlet UILabel *nameControl;
@property (weak, nonatomic) IBOutlet UITextView *bioControl;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@property (nonatomic, strong) CMSSpeaker *speaker;

@end
