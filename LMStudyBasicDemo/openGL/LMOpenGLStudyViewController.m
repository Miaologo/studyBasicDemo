//
//  LMOpenGLStudyViewController.m
//  LMStudyBasicDemo
//
//  Created by tim on 2019/3/12.
//  Copyright © 2019 LM. All rights reserved.
//

#import "LMOpenGLStudyViewController.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

typedef struct {
    GLKVector3 positionCoord;
    GLKVector2 textureCoord;
} SenceVertex;

@interface LMOpenGLStudyViewController ()<GLKViewDelegate>

@property (nonatomic, strong) EAGLContext *eaglContext;
@property (nonatomic, strong) CAEAGLLayer *eaglLayer;
@property (nonatomic, assign) GLuint colorBufferRender;
@property (nonatomic, assign) GLuint frameBuffer;
@property (nonatomic, assign) GLuint glProgram;
@property (nonatomic, assign) GLuint positionSlot;
@property (nonatomic, assign) GLuint textureSlot;
@property (nonatomic, assign) GLuint textureCoordsSlot;
@property (nonatomic, assign) GLuint textureID;
@property (nonatomic, assign) GLuint frameCAEAGLLayer;

@property (nonatomic, assign) SenceVertex *vertices;
@property (nonatomic, strong) GLKView *glkView;
@property (nonatomic, strong) GLKBaseEffect *baseEffect;


@end

@implementation LMOpenGLStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self commonInit];
    
    [self.glkView display];

    
//    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    [EAGLContext setCurrentContext:_eaglContext];
//
//    _eaglLayer = (CAEAGLLayer *)self.view.layer;
//    _eaglLayer.frame = self.view.frame;
//    _eaglLayer.opaque = YES;
//    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
//
//    glGenRenderbuffers(1, &_colorBufferRender);
//    glBindRenderbuffer(GL_RENDERBUFFER, _colorBufferRender);
//    [_eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
//    glGenFramebuffers(1, &_frameBuffer);
//    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorBufferRender);
    
}

- (void)dealloc {
    if (_vertices) {
        free(_vertices);
        _vertices = nil;
    }
}

- (void)commonInit {
    self.vertices = malloc(sizeof(SenceVertex) * 4);
    
    self.vertices[0] = (SenceVertex){{-1, 1, 0}, {0, 1}};
    self.vertices[1] = (SenceVertex){{-1, -1, 0}, {0, 0}};
    self.vertices[2] = (SenceVertex){{1, 1, 0}, {1, 1}};
    self.vertices[3] = (SenceVertex){{1, -1, 0}, {1, 0}};
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    CGRect frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height);
    self.glkView = [[GLKView alloc] initWithFrame:frame context:context];
    self.glkView.backgroundColor = [UIColor clearColor];
    self.glkView.delegate = self;
    
    [self.view addSubview:self.glkView];
    
    [EAGLContext setCurrentContext:self.glkView.context];
    
    
    NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sample.jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    NSDictionary *option = @{GLKTextureLoaderOriginBottomLeft : @(YES)};
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:[image CGImage] options:option error:NULL];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    GLsizeiptr bufferSizeBytes = sizeof(SenceVertex) * 4;
    glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, self.vertices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SenceVertex), NULL + offsetof(SenceVertex, positionCoord));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SenceVertex), NULL + offsetof(SenceVertex, textureCoord));
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDeleteBuffers(1, &vertexBuffer);
    vertexBuffer = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
//    glClear(GL_COLOR_BUFFER_BIT);
//    [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];
    
}
@end
