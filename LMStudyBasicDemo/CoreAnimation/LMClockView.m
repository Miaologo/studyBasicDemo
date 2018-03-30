//
//  LMClockView.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2018/3/5.
//  Copyright © 2018年 LM. All rights reserved.
//

#import "LMClockView.h"

@implementation LMClockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClockFace"]];
    self.backImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:self.backImageView];
    self.hourHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HourHand"]];
    self.hourHand.center = self.backImageView.center;
    [self addSubview:self.hourHand];
    self.minuteHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MinuteHand"]];
    self.minuteHand.center = self.backImageView.center;
    [self addSubview:self.minuteHand];
    self.secondHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SecondHand"]];
    self.secondHand.center = self.backImageView.center;
    [self addSubview:self.secondHand];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return YES;
}

@end
