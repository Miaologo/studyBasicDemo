//
//  AspectProxy.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2018/2/7.
//  Copyright © 2018年 LM. All rights reserved.
//

#import "AspectProxy.h"
#import <objc/runtime.h>

@implementation AspectProxy

- (id)initWithObject:(id)object andInvoker:(id<Invoker>)invoker
{
    return [self initWithObject:object selectors:nil andInover:invoker];
}

- (id)initWithObject:(id)object selectors:(NSArray *)selectors andInover:(id<Invoker>)invoker
{
    _proxyTarget = object;
    _invoker = invoker;
    _selectors = [selectors mutableCopy];
    return self;
}

- (void)registerSelector:(SEL)selector
{
    NSValue *selValue = [NSValue valueWithPointer:selector];
    [self.selectors addObject:selValue];
}
// 为目标对象中被调用的方法返回一个NSMethodSignature实例
// 运行时系统要求在执行标准转发时实现这个方法
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.proxyTarget methodSignatureForSelector:sel];
}
/**
 *  当调用目标方法的选择器与在AspectProxy对象中注册的选择器匹配时，forwardInvocation:会
 *  调用目标对象中的方法，并根据条件语句的判断结果调用AOP（面向切面编程）功能
 */
- (void)forwardInvocation:(NSInvocation *)invocation
{
    // 在调用目标方法前执行横切功能
    if ([self.invoker respondsToSelector:@selector(preInvoke:withTarget:)]) {
        if (self.selectors != nil) {
            SEL methodSEL = [invocation selector];
            for (NSValue *selValue in self.selectors) {
                if (methodSEL == [selValue pointerValue]) {
                    [[self invoker] preInvoke:invocation withTarget:self.proxyTarget];
                }
            }
        } else {
            [[self invoker] preInvoke:invocation withTarget:self.proxyTarget];
        }
    }
    // 调用目标方法
    [invocation invokeWithTarget:self.proxyTarget];
    // 在调用目标方法后执行横切功能
    if ([self.invoker respondsToSelector:@selector(postInvoke:withTarget:)]) {
        if (self.selectors != nil) {
            SEL methodSEL = [invocation selector];
            for (NSValue *selValue in self.selectors) {
                if (methodSEL == [selValue pointerValue]) {
                    [[self invoker] postInvoke:invocation withTarget:self.proxyTarget];
                }
            }
        } else {
            [[self invoker] postInvoke:invocation withTarget:self.proxyTarget];
        }
    }
}

@end


@implementation AuditingInvoker

- (void)preInvoke:(NSInvocation *)inv withTarget:(id)target
{
    NSLog(@"before sending message with selector %@ to %@ object", NSStringFromSelector([inv selector]),[target class]);
}

- (void)postInvoke:(NSInvocation *)inv withTarget:(id)target
{
    NSLog(@"after sending message with selector %@ to %@ object", NSStringFromSelector([inv selector]),[target class]);
}

@end

@implementation TestStudent

- (void)study:(NSString *)subject andRead:(NSString *)bookName
{
    NSLog(@"Invorking method on %@ object with selector %@",[self class], NSStringFromSelector(_cmd));
}

- (void)study:(NSString *)subject name:(NSString *)bookName
{
    NSLog(@"Invorking method on %@ object with selector %@",[self class], NSStringFromSelector(_cmd));
}
@end

