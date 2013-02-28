#import "CMSStarView.h"

@implementation CMSStarView

- (void)setIsFilled:(BOOL)isFilled
{
    _isFilled = isFilled;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* starStroke = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* starFill = nil;
    if (self.isFilled) {
        starFill = [UIColor colorWithRed:0.905 green:0.520 blue:0.000 alpha:1.000];
    } else {
        starFill = [UIColor clearColor];
    }

    //// Star Drawing
    UIBezierPath* starPath = [UIBezierPath bezierPath];
    [starPath moveToPoint: CGPointMake(13, -0.5)];
    [starPath addLineToPoint: CGPointMake(16.81, 6.76)];
    [starPath addLineToPoint: CGPointMake(24.89, 8.14)];
    [starPath addLineToPoint: CGPointMake(19.16, 14)];
    [starPath addLineToPoint: CGPointMake(20.35, 22.11)];
    [starPath addLineToPoint: CGPointMake(13, 18.48)];
    [starPath addLineToPoint: CGPointMake(5.65, 22.11)];
    [starPath addLineToPoint: CGPointMake(6.84, 14)];
    [starPath addLineToPoint: CGPointMake(1.11, 8.14)];
    [starPath addLineToPoint: CGPointMake(9.19, 6.76)];
    [starPath closePath];
    [starFill setFill];
    [starPath fill];
    [starStroke setStroke];
    starPath.lineWidth = 1;
    [starPath stroke];
}

@end
