#import "WaterColumn.h"

@implementation WaterColumn 

@synthesize TargetHeight;
@synthesize Speed;
@synthesize Height;

-(void)update:(CGFloat)dampening :(CGFloat) tension {
    float x = TargetHeight - Height;
    Speed += tension * x - Speed * dampening;
    Height += Speed;
}

@end
