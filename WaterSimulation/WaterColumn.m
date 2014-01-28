#import "WaterColumn.h"

@implementation WaterColumn

@synthesize Height = _height;
@synthesize Speed = _speed;

- (id)initWithTargetHeight:(CGFloat)targetHeight :(CGFloat)height :(CGFloat)speed {
    if (self = [super init]) {
        _targetHeight = targetHeight;
        self.Height = height;
        self.Speed = speed;
    }
    return self;
}

- (void)update:(CGFloat)dampening :(CGFloat)tension {
    CGFloat deltaHeight = _targetHeight - _height;
    _speed += tension * deltaHeight - _speed * dampening;
    _height += _speed;
}

@end
