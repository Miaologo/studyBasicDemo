//
//  LMScrollLayerView.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2018/3/12.
//  Copyright © 2018年 LM. All rights reserved.
//

#import "LMScrollLayerView.h"

@implementation LMScrollLayerView


+ (Class)layerClass
{
    return [CAScrollLayer layer];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)setUp
{
    self.layer.masksToBounds = YES;
    
    UIPanGestureRecognizer *recognizer = nil;
    recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRecognizer:)];
    [self addGestureRecognizer:recognizer];
}

- (void)handleRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint offset = self.bounds.origin;
    offset.x -= [recognizer translationInView:self].x;
    offset.y -= [recognizer translationInView:self].y;
    [(CAScrollLayer *)self.layer scrollToPoint:offset];
    
    [recognizer setTranslation:CGPointZero inView:self];
}

@end
