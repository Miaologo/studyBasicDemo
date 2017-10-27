//
//  RuntimeKit.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/3/3.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "RuntimeKit.h"

@implementation RuntimeKit

/**
 获取类名
 @param class 相应类
 @return NSString：类名
 */

+ (NSString *)fetchClasName:(Class)class
{
    const char *className = class_getName(class);
    return [NSString stringWithUTF8String:className];
}

/**
 获取成员变量
 
 @param class Class
 @return NSArray
 */
+ (NSArray *)fetchIvarList:(Class)class
{
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(class, &count);
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i += 1) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        const char *ivarName = ivar_getName(ivarList[i]);
        const char *ivarType = ivar_getTypeEncoding(ivarList[i]);
        dic[@"ivarName"] = [NSString stringWithUTF8String:ivarName];
        dic[@"ivarType"] = [NSString stringWithUTF8String:ivarType];
        [mutableList addObject:dic];
    }
    free(ivarList);
    return [mutableList copy];
}

/**
 获取类的属性列表, 包括私有和公有属性，以及定义在延展中的属性
 
 @param class Class
 @return 属性列表数组
 */

+ (NSArray *)fetchPropertyList:(Class)class
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(class, &count);
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i += 1) {
        const char *propertyName = property_getName(propertyList[i]);
        [mutableList addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertyList);
    return [mutableList copy];
}

/**
 获取类的实例方法列表：getter, setter, 对象方法等。但不能获取类方法
 @param class class description
 @return return value description
 */

+ (NSArray *)fetchMethodList:(Class)class
{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(class, &count);
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i += 1) {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        [mutableList addObject:NSStringFromSelector(methodName)];
    }
    free(methodList);
    return [mutableList copy];
}

/**
 获取协议列表
 
 @param class class description
 @return return value description
 */

+ (NSArray *)fetchProtocolList:(Class)class
{
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(class, &count);
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i += 1) {
        Protocol *protocol = protocolList[i];
        const char *protocolName = protocol_getName(protocol);
        [mutableList addObject:[NSString stringWithUTF8String:protocolName]];
    }
    return [mutableList copy];
}

/**
 往类上添加新的方法与其实现
 @param class 相应的类
 @param methodSel 方法的名
 @param methodSelImpl 对应方法实现的方法名
 */

+ (void)addMethod:(Class)class method:(SEL)methodSel method:(SEL)methodSelImpl
{
    Method method = class_getInstanceMethod(class, methodSelImpl);
    IMP methodIMP = method_getImplementation(method);
    const char *types = method_getTypeEncoding(method);
    class_addMethod(class, methodSel, methodIMP, types);
}


/**
 方法交换
 
 // @param class 交换方法所在的类
 // @param method1 方法1
 // @param method2 方法2
 */

+ (void)methodSwap:(Class)class firstMethod:(SEL)originalSel secondMethod:(SEL)swizzledSel
{
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSel);
    BOOL didAddMethod = class_addMethod(class, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}





@end
