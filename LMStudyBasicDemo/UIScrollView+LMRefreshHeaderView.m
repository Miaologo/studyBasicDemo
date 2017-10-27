//
//  UIScrollView+LMRefreshHeaderView.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/9/26.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "UIScrollView+LMRefreshHeaderView.h"
#import <objc/runtime.h>

static char LMRefreshHeaderViewKey = '\0';

@implementation UIScrollView (LMRefreshHeaderView)

- (MAYRefreshHeaderView *)refreshHeaderView
{
    return objc_getAssociatedObject(self, &LMRefreshHeaderViewKey);
    
}

- (void)setRefreshHeaderView:(MAYRefreshHeaderView *)refreshHeaderView
{
    objc_setAssociatedObject(self, &LMRefreshHeaderViewKey, refreshHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self insertSubview:refreshHeaderView atIndex:0];
}

@end
