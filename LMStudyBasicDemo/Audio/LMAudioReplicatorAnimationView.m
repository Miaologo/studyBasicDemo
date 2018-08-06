//
//  LMAudioReplicatorAnimationView.m
//  LMStudyBasicDemo
//
//  Created by tim on 2018/7/23.
//  Copyright © 2018年 LM. All rights reserved.
//

#import "LMAudioReplicatorAnimationView.h"

@interface LMAudioReplicatorAnimationView()

@property (nonatomic, strong) CAReplicatorLayer *relicatorLayer;

@end

@implementation LMAudioReplicatorAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
    }
    return self;
}

- (void)startRelicatorAnimation
{
    NSInteger instanceCount = 20;
    
    CALayer *barLayer = [[CALayer alloc] init];
    barLayer.bounds = CGRectMake(0, 0, 2, 10);
    barLayer.anchorPoint = CGPointZero;
    barLayer.position = CGPointMake(0, 10);
    barLayer.cornerRadius = 1;
    barLayer.backgroundColor = [UIColor whiteColor].CGColor;
    CAReplicatorLayer *subReplicatorLayer = [[CAReplicatorLayer alloc] init];
    subReplicatorLayer.anchorPoint = CGPointZero;
    subReplicatorLayer.bounds = CGRectMake(0, 0, 15, 10);
    subReplicatorLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    subReplicatorLayer.instanceCount = 4;
    subReplicatorLayer.instanceDelay = 0.2;
    subReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(3, 0, 0);
    [subReplicatorLayer addSublayer:barLayer];
    
    CAReplicatorLayer *rootReplicatorLayer = [[CAReplicatorLayer alloc] init];
    rootReplicatorLayer.anchorPoint = CGPointZero;
    rootReplicatorLayer.bounds = CGRectMake(0, 0, 50, 10);
    rootReplicatorLayer.backgroundColor = [UIColor redColor].CGColor;
    rootReplicatorLayer.instanceCount = 3;
    rootReplicatorLayer.instanceDelay = 0.4;
    rootReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(10, 0, 0);
    [rootReplicatorLayer addSublayer:subReplicatorLayer];
    [self.layer addSublayer:rootReplicatorLayer];
    
}


- (void)circleRotationAnimation
{
    CAReplicatorLayer *relipcator = [[CAReplicatorLayer alloc] init];
    relipcator.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    relipcator.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    relipcator.instanceCount = 15;
    CGFloat angle = (2 * M_PI) / 15.0;
    relipcator.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);

    relipcator.instanceDelay = 1 / 15.0;
    
    [self.layer addSublayer:relipcator];
    CALayer *circle = [[CALayer alloc] init];
    circle.bounds = CGRectMake(0, 0, 14, 14);
    circle.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height/2 - 55);
    circle.cornerRadius = 7;
    circle.backgroundColor = [UIColor whiteColor].CGColor;
    circle.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    [relipcator addSublayer:circle];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @(1);
    scale.toValue = @(0.1);
    scale.duration = 1;
    scale.repeatCount = HUGE;
    [circle addAnimation:scale forKey:nil];
}

@end

@interface KSLiveAudioRecordCountDownView()
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *sendDescripteLabel;
@end

@implementation KSLiveAudioRecordCountDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
        CAShapeLayer *mask = [CAShapeLayer new];
        mask.frame = self.bounds;
        mask.path = path.CGPath;
        self.layer.mask = mask;
        _secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, frame.size.width - 20, 35)];
        _secondLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _secondLabel.textColor = [UIColor whiteColor];
        [self addSubview:_secondLabel];
        _sendDescripteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 44, frame.size.width - 10, 19)];
        _sendDescripteLabel.font = [UIFont systemFontOfSize:15];
        _sendDescripteLabel.textColor = [UIColor whiteColor];
        _sendDescripteLabel.text = @"上滑取消发送";
        [self addSubview:_sendDescripteLabel];
    }
    return self;
}


- (void)setCountDownSecond:(NSUInteger)sec
{
    _secondLabel.text = [@(sec) stringValue];
}

@end

@implementation KSLiveVoiceInputButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"\n --- began --  %f  ----\n", CACurrentMediaTime());
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"\n --- moved --  %f  ----\n", CACurrentMediaTime());

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"\n --- ended --  %f  ----\n", CACurrentMediaTime());

}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"\n --- cancelled --  %f  ----\n", CACurrentMediaTime());

}
@end
