#define COLUMN_COUNT 80
#define WATER_HEIGHT 200

#define TENSION 0.025f
#define DAMPENING 0.025f
#define SPREAD 0.25f

typedef struct Vertex {
    GLushort x;
    GLushort y;
} Vertex;

typedef struct Color {
    ccColor4B color;
} Color;

@interface WaterNode : CCNode {
@private
    NSMutableArray *_columns;
    CGFloat _scale;
    Vertex _vertexArray[COLUMN_COUNT * 2];
    Color _colorArray[COLUMN_COUNT * 2];
}

- (void)splash:(CGFloat)index :(CGFloat)speed;

@end
