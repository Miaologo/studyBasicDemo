//
//  LMCoreAnimationMainViewController.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2018/3/2.
//  Copyright © 2018年 LM. All rights reserved.
//

#import "LMCoreAnimationMainViewController.h"
#import "LMClockView.h"
#import <GLKit/GLKMatrix4.h>

#define LIGHT_DIRECTION 0, 1, -0.5
#define AMBIENT_LIGHT 0.5

@interface LMCoreAnimationMainViewController ()

@property (nonatomic, strong) LMClockView *clockView;

@property (nonatomic, strong) NSArray<UIView *> *face;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) CALayer *colorLayer;

@end

@implementation LMCoreAnimationMainViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(100, 150, 200, 250)];
    whiteView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:whiteView];
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
//    [whiteView.layer addSublayer:blueLayer];
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
//    [blueLayer display];
//    blueLayer.zPosition = 1.0f;
    
    CALayer *redLayer = [CALayer layer];
    redLayer.frame = CGRectMake(50, 100, 50, 100);
    redLayer.backgroundColor = [UIColor redColor].CGColor;
//    [whiteView.layer addSublayer:redLayer];
    
    UIImage *image = [UIImage imageNamed:@"sidebar_pic"];
    whiteView.layer.contents = (__bridge id)image.CGImage;
//    whiteView.layer.contentsGravity = kCAGravityResizeAspect;
    whiteView.layer.contentsGravity = kCAGravityCenter;
    whiteView.layer.contentsScale = image.scale;
//    whiteView.layer.affineTransform = CGAffineTransformMakeRotation(M_PI_4);
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    transform = CGAffineTransformScale(transform, 0.5, 0.5);
//    transform = CGAffineTransformRotate(transform, M_PI / 180 * 3);
//    transform = CGAffineTransformTranslate(transform, 200, 0);
//    whiteView.layer.affineTransform = transform;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0 / 500;
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    whiteView.layer.transform = transform;
    
    NSLog(@"-----%f", image.scale);
    
    [self setupClockView];
    
    [self setupFace];
//    [self configureCube];
//    [self configTwoCube];
//    [self configCAEmitterLayer];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"dkdafafadfasf" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"dkdafafadfasf" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dkdafafadfasf" object:nil];
    
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50, 100, 100, 100);
    self.colorLayer.position = CGPointMake(self.containerView.frame.size.width/2.0, self.containerView.frame.size.height/2.0);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.colorLayer.actions = @{@"backgroundColor": transition};
    [self.containerView.layer addSublayer:self.colorLayer];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
//    [self.containerView addGestureRecognizer:tap];
}


- (void)handleTap
{
    CGFloat red = (rand() / (double)INT_MAX);
    CGFloat green = (rand() / (double)INT_MAX);
    CGFloat blue = (rand() / (double)INT_MAX);
    
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
}


- (void)handleNotification:(NSNotification *)notification
{
    NSLog(@"---- notification = %@", notification.name);
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 10.f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

- (void)setupClockView {
    self.clockView = [[LMClockView alloc] initWithFrame:CGRectMake(50, 450, 300, 300)];
    self.clockView.backgroundColor = [UIColor whiteColor];
    self.clockView.hourHand.layer.anchorPoint = CGPointMake(0.5, 0.9);
    self.clockView.secondHand.layer.anchorPoint = CGPointMake(0.5, 0.9);
    self.clockView.minuteHand.layer.anchorPoint = CGPointMake(0.5, 0.9);
    [self.view addSubview:self.clockView];
    self.clockView.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)tick
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    
    self.clockView.hourHand.transform = CGAffineTransformMakeRotation(hoursAngle);
    self.clockView.minuteHand.transform = CGAffineTransformMakeRotation(minsAngle);
    self.clockView.secondHand.transform = CGAffineTransformMakeRotation(secsAngle);
    
}

#pragma mark -- make CUBE

- (void)setupFace
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:6];
    for (int i = 0; i < 6; i+=1) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        v.backgroundColor = [UIColor whiteColor];
        v.layer.borderWidth = 0.5;
        v.layer.borderColor = [UIColor redColor].CGColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [@(i+1) stringValue];
        label.center = CGPointMake(50, 50);
        [v addSubview:label];
        [array addObject:v];
    }
    self.face = [array copy];
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    
    [self.view addSubview:self.containerView];
}

- (void)configureCube
{
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/500.0;
    
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    self.containerView.layer.sublayerTransform = perspective;
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 50);
    [self addFace:0 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(50, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, -50, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, 50, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(-50, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, 0, -50);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform
{
    UIView *face = self.face[index];
    [self.containerView addSubview:face];

    CGSize containerSize = self.containerView.bounds.size;
    face.center = CGPointMake(containerSize.width/2.0, containerSize.height/2.0);
    face.layer.transform = transform;
    
}



- (void)applyLightingToFace:(CALayer *)face
{
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    
    
}


#pragma mark -- user event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//    point = [self.clockView.layer convertPoint:point fromLayer:self.view.layer];
//    if ([self.clockView.layer containsPoint:point]) {
//        CALayer *layer = [self.clockView.layer hitTest:point];
//    }
    CGPoint point = [[touches anyObject] locationInView:self.containerView];
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        CGFloat red = (rand() / (double)INT_MAX);
        CGFloat green = (rand() / (double)INT_MAX);
        CGFloat blue = (rand() / (double)INT_MAX);
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    } else {
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
    
}

#pragma mark -- CATransformLayer

- (CALayer *)faceWithTransform:(CATransform3D)transform
{
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    
    CGFloat red = (rand() / (double)INT_MAX);
    CGFloat green = (rand() / (double)INT_MAX);
    CGFloat blue = (rand() / (double)INT_MAX);
    
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    face.transform = transform;
    return face;
}

- (CALayer *)cubeWithTransform:(CATransform3D)transform
{
    CATransformLayer *cube = [CATransformLayer layer];
    
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    CGSize containerSize = self.containerView.bounds.size;
    cube.position = CGPointMake(containerSize.width/2.0, containerSize.height/2.0);
    
    cube.transform = transform;
    return cube;
}

- (void)configTwoCube
{
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0/500.0;
    self.containerView.layer.sublayerTransform = pt;
    
    CATransform3D clt = CATransform3DIdentity;
    clt = CATransform3DTranslate(clt, -100, 0, 0);
    [self.containerView.layer addSublayer:[self cubeWithTransform:clt]];
    
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    [self.containerView.layer addSublayer:[self cubeWithTransform:c2t]];
}

#pragma mark -- CAEmitterLayer

- (void)configCAEmitterLayer
{
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:emitter];
    
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width/2, emitter.frame.size.height/2.0);
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"sidebar_pic"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI *2.0;
    emitter.emitterCells = @[cell];
}

@end
