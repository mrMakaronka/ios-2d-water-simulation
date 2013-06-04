#import "cocos2d.h"
#import "WaterColumn.h"

#define COLUMN_COUNT 90
#define WATER_HEIGHT 200

#define TENSION 0.025f
#define DAMPENING 0.025f
#define SPREAD 0.25f

typedef struct Trapezoid {
    CGPoint upperLeft;
    CGPoint upperRight;
    CGPoint bottomLeft;
    CGPoint bottomRight;
} Trapezoid;

typedef struct TrapezoidColor {
    ccColor4B upperLeft;
    ccColor4B upperRight;
    ccColor4B bottomLeft;
    ccColor4B bottomRight;
} TrapezoidColor;

@interface WaterNode : CCNode {
    Trapezoid _trapezoidArray[COLUMN_COUNT];
    TrapezoidColor _trapezoidColorsArray[COLUMN_COUNT];
    NSMutableArray *_columns;
    CGFloat _scale;
}

-(id)init;
-(void)Splash:(CGFloat)index :(CGFloat) speed;

@end
