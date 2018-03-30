//
//  LMClockView.h
//  LMStudyBasicDemo
//
//  Created by Tim on 2018/3/5.
//  Copyright © 2018年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMClockView : UIView

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *hourHand;
@property (nonatomic, strong) UIImageView *minuteHand;
@property (nonatomic, strong) UIImageView *secondHand;

@property (nonatomic, weak) NSTimer *timer;

@end
