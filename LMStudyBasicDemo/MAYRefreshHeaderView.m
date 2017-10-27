//
//  MAYRefreshHeaderView.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/9/26.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "MAYRefreshHeaderView.h"
#import <QuartzCore/QuartzCore.h>

#define HEXCOLOR(hexValue)              [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : 1.0]
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


static const float originY_circle = 13;
static const float originY_fixed = 16;

@interface MAYRefreshHeaderView()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation MAYRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *maoyanImageV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 34) / 2, originY_circle, 34, 34)];
        maoyanImageV.image = [UIImage imageNamed:@"bg_refreshHeader_maoyan"];
        [self addSubview:maoyanImageV];
        
        _activityIndicatorView = [[MTActivityIndicatorView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 34) / 2, originY_circle, 34, 34)];
        [_activityIndicatorView setImage:[UIImage imageNamed:@"img_refreshHeader_redcircle"]];
        [self addSubview:_activityIndicatorView];
        
        _pullCircleView = [[MAYPullStateCircleView alloc] initWithFrame:maoyanImageV.frame];
        [self addSubview:_pullCircleView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    MAYPullStateCircleView *pullCircleView = [[MAYPullStateCircleView alloc] initWithFrame:self.pullCircleView.frame];
    pullCircleView.circleStrokeColor = self.pullCircleView.circleStrokeColor;
    pullCircleView.degreeAcross = 360;
    CGSize pageSize = pullCircleView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(pageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, pullCircleView.bounds);
    [pullCircleView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.activityIndicatorView setImage:image];
    
    [super layoutSubviews];
}

- (void)updateRefreshState:(BOOL)isRefreshing
{
    self.pullCircleView.hidden = isRefreshing;
    if (self.isRefreshing) {
        [self.activityIndicatorView startAnimating];
    } else {
        [self.activityIndicatorView stopAnimating];
    }
}

@end


static inline float radians(double degrees) { return degrees * M_PI / 180; }

@interface MAYPullStateCircleView ()

@property (assign, nonatomic) int segmentNum;
@property (assign, nonatomic) float gap;

@end

@implementation MAYPullStateCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _gap = 8;     //圆弧之间的间隔angle为8度
        _circleStrokeColor = HEXCOLOR(0xd12f2b);
    }
    return self;
}

- (void)setDegreeAcross:(float)degreeAcross {
    if (degreeAcross != _degreeAcross) {
        _degreeAcross = degreeAcross;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [_circleStrokeColor setStroke];
    [[UIColor redColor] setFill];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextBeginPath(context);
    
    double radius = (self.frame.size.width - 2.0) / 2;
    float centerX = self.frame.size.width  / 2;
    float centerY = self.frame.size.width / 2;
    
    float perimeter = M_PI * radius * 2;
    float space = perimeter * _gap / 360;
    float segment = (perimeter / 4 - space) / 2;
    CGFloat dash[] = {segment, space, segment, 0};
    CGContextSetLineDash(context, 0, dash, 4);
    
    float degreeX = _degreeAcross;
    float x = degreeX / 2;
    
    
    CGContextAddArc(context, centerX, centerY, radius, radians(270), radians(270 - x), 1);
    CGContextStrokePath(context);
    CGContextAddArc(context, centerX, centerY, radius, radians(270), radians(270 + x), 0);
    CGContextStrokePath(context);
    
    return;
}

@end

@implementation MTActivityIndicatorView {
    UIImageView *_imageView;
    CAKeyframeAnimation *_rotateAnimation;
    BOOL _bAnimating;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bAnimating = NO;
        self.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:imageView];
        _imageView = imageView;
        
        _rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:(-M_PI * 2)], [NSNumber numberWithFloat:0.0f], nil];
        _animationDuration = 1.0f;
        _rotateAnimation.duration = _animationDuration;
        _rotateAnimation.repeatCount = HUGE_VALF;
        _rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:.0],
                                     [NSNumber numberWithFloat:1],
                                     nil];
        _rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _rotateAnimation.removedOnCompletion = NO;
        _rotateAnimation.fillMode = kCAFillModeForwards;
    }
    return self;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    _animationDuration = animationDuration;
    _rotateAnimation.duration = animationDuration;
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
}

- (void)startAnimating
{
    _bAnimating = TRUE;
    self.hidden = NO;
    
    if (_imageView) {
        [_imageView.layer addAnimation:_rotateAnimation forKey:@"rotateAnimation"];
    }
}

- (void)stopAnimating
{
    _bAnimating = NO;
    self.hidden = YES;
    
    if (_imageView) {
        [_imageView.layer removeAnimationForKey:@"rotateAnimation"];
    }
}

- (BOOL)isAnimating
{
    return _bAnimating;
}

- (void)dealloc
{
    if (_imageView && _imageView.layer) {
        [_imageView.layer removeAnimationForKey:@"rotateAnimation"];
    }
    
    _imageView = nil;
}

@end
