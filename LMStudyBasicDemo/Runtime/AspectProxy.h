//
//  AspectProxy.h
//  LMStudyBasicDemo
//
//  Created by Tim on 2018/2/7.
//  Copyright © 2018年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Invoker<NSObject>
// 在调用对象中的方法前执行对功能的横切
- (void)preInvoke:(NSInvocation *)inv withTarget:(id)target;
@optional
// 在调用对象中的方法后执行对功能的横切
- (void)postInvoke:(NSInvocation *)inv withTarget:(id)target;
@end

@interface AspectProxy : NSProxy
/** 通过NSProxy实例转发消息的真正对象 */
@property (nonatomic, strong) id proxyTarget;
/** 能够实现横切功能的类（遵守Invoker协议）的实例 */
@property (nonatomic, strong) id<Invoker> invoker;
/** 定义了哪些消息会调用横切功能 */
@property (nonatomic, readonly) NSMutableArray *selectors;
// AspectProxy类实例的初始化方法
- (id)initWithObject:(id)object andInvoker:(id<Invoker>)invoker;
- (id)initWithObject:(id)object selectors:(NSArray *)selectors andInover:(id<Invoker>)invoker;
// 向当前的选择器列表中添加选择器
- (void)registerSelector:(SEL)selector;

@end

@interface AuditingInvoker: NSObject<Invoker>
@end

@interface TestStudent: NSObject
- (void)study:(NSString *)subject andRead:(NSString *)bookName;
- (void)study:(NSString *)subject name:(NSString *)bookName;
@end
