//
//  LMRefreshBaseView.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/9/26.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "LMRefreshBaseView.h"
static void *LMRefreshControlContext = &LMRefreshControlContext;

@interface LMRefreshBaseView()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation LMRefreshBaseView

- (UIScrollView *)scrollView
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)self.superview;
    } else {
        return nil;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.panGestureRecognizer removeObserver:self forKeyPath:@"status"];
}

- (void)didMoveToSuperview
{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:LMRefreshControlContext];
    self.panGestureRecognizer = self.scrollView.panGestureRecognizer;
    [self.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (self.scrollView == nil) {
        return;
    }
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScoll:self.scrollView];
    }
    if ([keyPath isEqualToString:@"state"]) {
        if ([self.scrollView.panGestureRecognizer state] == UIGestureRecognizerStateEnded) {
            [self scrollViewWillEndDragging:self.scrollView];
        }
    }
}

- (void)scrollViewDidScoll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
{
    
}

@end

@interface LMRefreshHeaderView()

@end

@implementation LMRefreshHeaderView

- (instancetype)initWithHeight:(CGFloat)height Action:(void(^)())action
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.viewHeight = height;
        self.action = action;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewHeight = 60;
    }
    return self;
}

- (void)setIsRefreshing:(BOOL)isRefreshing
{
    _isRefreshing = isRefreshing;
    [self updateRefreshState:isRefreshing];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self updateProgress:progress];
}

- (void)updateRefreshState:(BOOL)isRefreshing
{
    
}

- (void)updateProgress:(CGFloat)progress
{
    
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.frame = CGRectMake(0, -self.viewHeight, [UIScreen mainScreen].bounds.size.width, self.viewHeight);
}

- (void)scrollViewDidScoll:(UIScrollView *)scrollView
{
    if (self.isRefreshing) {
        return;
    }
    self.progress = MIN(1, MAX(0, -(scrollView.contentOffset.y + scrollView.contentInset.top)/self.viewHeight));
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
{
    if (self.isRefreshing || self.progress < 1) {
        return;
    }
    [self beginRefreshing];
}

- (void)beginRefreshing
{
    if (self.isRefreshing) {
        return;
    }
    self.progress = 1;
    self.isRefreshing = YES;
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.top += self.viewHeight;
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.y = -self.viewHeight - self.scrollView.contentInset.top;
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentOffset = contentOffset;
        self.scrollView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        if (self.action) {
            self.action();
        }
    }];
}

- (void)endRefreshing
{
    if (!self.isRefreshing) {
        return;
    }
    [UIView animateWithDuration:0.4 animations:^{
        if (self.scrollView != nil) {
            UIEdgeInsets contentInset = self.scrollView.contentInset;
            contentInset.top -= self.viewHeight;
            self.scrollView.contentInset = contentInset;
        }
    } completion:^(BOOL finished) {
        self.isRefreshing = NO;
        self.progress = 0;
    }];
}

@end


