#import <Foundation/Foundation.h>

@interface WaterColumn : NSObject {
    @public
    CGFloat TargetHeight;
    CGFloat Height;
    CGFloat Speed;
}

@property(assign)CGFloat TargetHeight;
@property(assign)CGFloat Height;
@property(assign)CGFloat Speed;

-(void) update:(CGFloat)dampening :(CGFloat) tension;

@end
