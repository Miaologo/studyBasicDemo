//
//  LMRefreshBaseView.h
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/9/26.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LMRefreshStats) {
    LMRefreshStatePulling = 0,
    LMRefreshStateNormal,
    LMRefreshStateLoading,
};

@interface LMRefreshBaseView : UIView
@property (nonatomic, readonly) UIScrollView *scrollView;

- (void)scrollViewDidScoll:(UIScrollView *)scrollView;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView;

@end

@interface LMRefreshHeaderView : LMRefreshBaseView

@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, copy) void (^action)();
@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) LMRefreshStats refreshState;

- (void)updateRefreshState:(BOOL)isRefreshing;
- (void)updateProgress:(CGFloat)progress;
- (void)beginRefreshing;
- (void)endRefreshing;

@end
