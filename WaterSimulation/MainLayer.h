#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "AppDelegate.h"
#import "WaterNode.h"

@interface MainLayer : CCLayerColor
{
    WaterNode *_waterNode;
}

+(CCScene *) scene;

@end