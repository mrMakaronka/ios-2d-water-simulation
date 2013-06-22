#import "WaterNode.h"

@implementation WaterNode

-(id)init {
    if (self = [super init]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _scale = winSize.width / (COLUMN_COUNT - 1);
        
        [self initColors];
        [self initColumns];
        
        self.shaderProgram = [[CCShaderCache sharedShaderCache] 
                              programForKey:kCCShader_PositionColor];
    }
    return self;
}

-(void) initColors {
    ccColor4B lightBlue = ccc4(0, 50, 200, 255);
    ccColor4B darkBlue = ccc4(0, 50, 100, 255);
    
    for (int i = 1; i < COLUMN_COUNT * 2; i += 2) {
        _colorArray[i - 1].color = lightBlue;
        _colorArray[i].color = darkBlue;
    }
}

-(void) initColumns {
    _columns = [[NSMutableArray alloc] init];
    for (int i = 0; i < COLUMN_COUNT; i++) {
        WaterColumn *column = [WaterColumn alloc];
        column.TargetHeight = WATER_HEIGHT;
        column.Height = WATER_HEIGHT;
        column.Speed = 0;
        [_columns addObject:column];
    }
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
    
    for (int i = 0; i < COLUMN_COUNT; i++) {
        GLushort x = i * _scale;
        GLushort y = ((WaterColumn*)[_columns objectAtIndex:i]).Height;
        
        _vertexArray[2 * i] = (struct Vertex) {x, y};
        _vertexArray[2 * i + 1] = (struct Vertex) {x, 0};
    }
    
    ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position | kCCVertexAttribFlag_Color );
    [self.shaderProgram use];
    [self.shaderProgram setUniformForModelViewProjectionMatrix];

    glEnableVertexAttribArray(kCCVertexAttribFlag_Position);
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_UNSIGNED_SHORT, GL_FALSE, 0, _vertexArray);
    
    glEnableVertexAttribArray(kCCVertexAttribFlag_Color);
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, _colorArray);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, COLUMN_COUNT * 2);
}

-(void)Splash:(CGFloat)x :(CGFloat) speed {
    int index = x / _scale;
    if (index > 0 && index < COLUMN_COUNT) {
        WaterColumn *waterColumn = [_columns objectAtIndex:index];
        waterColumn.Speed = speed;
    }
}

@end
