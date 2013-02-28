#import <UIKit/UIKit.h>
#import "CMSStarView.h"

@interface CMSScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topicControl;
@property (weak, nonatomic) IBOutlet UILabel *speakerControl;
@property (weak, nonatomic) IBOutlet CMSStarView *starView;

@end
