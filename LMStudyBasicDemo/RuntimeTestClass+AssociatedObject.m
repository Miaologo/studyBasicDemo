//
//  RuntimeTestClass+AssociatedObject.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/3/3.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "RuntimeTestClass+AssociatedObject.h"
#import "RuntimeKit.h"

@interface RuntimeTestClass (AssociatedObject)

@property (nonatomic, strong) NSString *dynamicAddProperty;

@end

@implementation RuntimeTestClass (AssociatedObject)

static char kDynamicAddProperty;

/**
 getter方法
 
 @return 返回关联属性的值
 */

- (NSString *)dynamicAddProperty
{
    return objc_getAssociatedObject(self, &kDynamicAddProperty);
}

/**
 setter方法
 
 @param dynamicAddProperty 设置关联属性的值
 */

- (void)setDynamicAddProperty:(NSString *)dynamicAddProperty
{
    objc_setAssociatedObject(self, &kDynamicAddProperty, dynamicAddProperty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
