#import "WaterNode.h"

@implementation WaterNode

-(id)init {
    if (self = [super init]) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _scale = winSize.width / (COLUMN_COUNT - 1);
        
        ccColor4B lightBlue = ccc4(0, 50, 200, 255);
        ccColor4B darkBlue = ccc4(0, 50, 100, 255);
        
        for (int i = 0; i < COLUMN_COUNT; i++) {
            _trapezoidColorsArray[i].upperLeft = lightBlue;
            _trapezoidColorsArray[i].upperRight = lightBlue;
            _trapezoidColorsArray[i].bottomLeft = darkBlue;
            _trapezoidColorsArray[i].bottomRight = darkBlue;
        }
        
        _columns = [[NSMutableArray alloc] init];
        for (int i = 0; i < COLUMN_COUNT; i++) {
            WaterColumn *column = [WaterColumn alloc];
            column.TargetHeight = WATER_HEIGHT;
            column.Height = WATER_HEIGHT;
            column.Speed = 0;
            [_columns addObject:column];
        }
        
        self.shaderProgram = [[CCShaderCache sharedShaderCache] 
                              programForKey:kCCShader_PositionColor];
    }
    return self;
}

-(void)dealloc {
    [_columns release];
    [super dealloc];
}

-(void)update {
    
    for (int i = 0; i < COLUMN_COUNT; i++) {
        WaterColumn *waterColumn = [_columns objectAtIndex:i];
        [waterColumn update:DAMPENING :TENSION];
    }
    
    CGFloat leftDeltas[COLUMN_COUNT];
    CGFloat rightDeltas[COLUMN_COUNT];
    
    for (int j = 0; j < 8; j++) {
        for (int i = 0; i < COLUMN_COUNT; i++) {
            
            if (i > 0) {
                leftDeltas[i] = SPREAD * ([[_columns objectAtIndex:i] Height] - [[_columns objectAtIndex:i-1] Height]);
                ((WaterColumn*)[_columns objectAtIndex:i-1]).Speed += leftDeltas[i];
            }
            if (i < COLUMN_COUNT - 1) {
                rightDeltas[i] = SPREAD * ([[_columns objectAtIndex:i] Height] - [[_columns objectAtIndex:i+1] Height]);
                ((WaterColumn*)[_columns objectAtIndex:i+1]).Speed += rightDeltas[i];
            }
        }
        
        for (int i = 0; i < COLUMN_COUNT; i++) {
            if (i > 0)
                ((WaterColumn*)[_columns objectAtIndex:i-1]).Height += leftDeltas[i];
            if (i < COLUMN_COUNT - 1)
                ((WaterColumn*)[_columns objectAtIndex:i+1]).Height += rightDeltas[i];
        }
    }
}

-(void)draw {
    [self update];
    
    for (int i = 1; i < COLUMN_COUNT; i++) {
        _trapezoidArray[i-1].upperLeft.x = (i - 1) * _scale;
        _trapezoidArray[i-1].upperLeft.y = ((WaterColumn*)[_columns objectAtIndex:i-1]).Height;
        
        _trapezoidArray[i-1].upperRight.x = i * _scale;
        _trapezoidArray[i-1].upperRight.y = ((WaterColumn*)[_columns objectAtIndex:i]).Height;
        
        _trapezoidArray[i-1].bottomLeft.x = _trapezoidArray[i-1].upperLeft.x;
        _trapezoidArray[i-1].bottomLeft.y = 0;
        
        _trapezoidArray[i-1].bottomRight.x = _trapezoidArray[i-1].upperRight.x;
        _trapezoidArray[i-1].bottomRight.y = 0;
    }
    
    ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position | kCCVertexAttribFlag_Color );
    [self.shaderProgram use];
    [self.shaderProgram setUniformForModelViewProjectionMatrix];

    glEnableVertexAttribArray(kCCVertexAttribFlag_Position);
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, _trapezoidArray);
    
    glEnableVertexAttribArray(kCCVertexAttribFlag_Color);
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, _trapezoidColorsArray);	

    glDrawArrays(GL_TRIANGLE_STRIP, 0, COLUMN_COUNT * 4);
}

-(void)Splash:(CGFloat)x :(CGFloat) speed {
    int index = x / _scale;
    if (index > 0 && index < COLUMN_COUNT) {
        WaterColumn *waterColumn = [_columns objectAtIndex:index];
        waterColumn.Speed = speed;
    }
}

@end
