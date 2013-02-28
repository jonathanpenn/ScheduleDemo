#import "CMSScheduleTableViewCell.h"

@implementation CMSScheduleTableViewCell

- (NSString *)accessibilityIdentifier
{
    NSString *favFlag = nil;
    if (self.starView.hidden) favFlag = @"";
    else favFlag = @"* ";

    return [NSString stringWithFormat:@"%@%@, %@",
            favFlag,
            self.topicControl.text,
            self.speakerControl.text];
}

@end
