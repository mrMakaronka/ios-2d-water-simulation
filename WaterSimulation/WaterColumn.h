@interface WaterColumn : NSObject {
@private
    CGFloat _targetHeight;
}

@property(assign, nonatomic) CGFloat Height;
@property(assign, nonatomic) CGFloat Speed;

- (id)initWithTargetHeight:(CGFloat)targetHeight :(CGFloat)height :(CGFloat)speed;

- (void)update:(CGFloat)dampening :(CGFloat)tension;

@end
