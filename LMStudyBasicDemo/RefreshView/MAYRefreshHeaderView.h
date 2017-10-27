//
//  MAYRefreshHeaderView.h
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/9/26.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "LMRefreshBaseView.h"

@interface MAYPullStateCircleView : UIView

@property (assign, nonatomic) float degreeAcross;  //[0,360]范围内
@property (strong, nonatomic) UIColor *circleStrokeColor;

@end

@interface MTActivityIndicatorView : UIView

@property (assign, nonatomic) NSTimeInterval animationDuration;    //Defaults to 1.0

- (void)setImage:(UIImage *)image;
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
@end

@interface MAYRefreshHeaderView : LMRefreshHeaderView

@property (nonatomic, retain, readonly) MAYPullStateCircleView *pullCircleView;
@property (nonatomic, retain, readonly) MTActivityIndicatorView *activityIndicatorView;

@end
