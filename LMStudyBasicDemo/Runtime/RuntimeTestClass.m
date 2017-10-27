//
//  RuntimeTestClass.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/3/3.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "RuntimeTestClass.h"
#import "RuntimeKit.h"

#import <objc/message.h>

// http://www.cocoachina.com/ios/20170301/18804.html

@interface SecondClass : NSObject
- (void)noThisMethod:(NSString *)value;
@end

@implementation SecondClass
- (void)noThisMethod:(NSString *)value {
    NSLog(@"SecondClass中的方法实现%@", value);
}
@end

@interface RuntimeTestClass () {
    NSInteger _var1;
    int _var2;
    BOOL _var3;
    double _var4;
    float _var5;
}

@property (nonatomic, strong) NSMutableArray *privateProperty1;
@property (nonatomic, strong) NSNumber *privateProperty2;
@property (nonatomic, strong) NSDictionary *privateProperty3;

@end

@implementation RuntimeTestClass

+ (void)classMethod:(NSString *)value
{
    NSLog(@"Class Method");
}

- (void)publicTestMethod:(NSString *)value1 second:(NSString *)value2
{
    NSLog(@"publicTestMethod1");
}

- (void)publicTestMethod2
{
    NSLog(@"publicTestMethod2");
}

- (void)priateTestMethod
{
    NSLog(@"publicTestMethod");
}

#pragma mark - method exchange

- (void)method1
{
    NSLog(@"我是Method1的实现");
}


//运行时方法拦截
- (void)dynamicAddMethod: (NSString *) value
{
    NSLog(@"OC替换的方法：%@", value);
}

/**
 没有找到SEL的IML实现时会执行下方的方法
 @param sel 当前对象调用并且找不到IML的SEL
 @return 找到其他的执行方法，并返回yes
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    [RuntimeKit addMethod:[self class] method:sel method:@selector(dynamicAddMethod)];
    return  YES;
}

/**
 将当前对象不存在的SEL传给其他存在该SEL的对象
 @param aSelector 当前类中不存在的SEL
 @return 存在该SEL的对象
 */

- (id)forwardingTargetForSelector:(SEL)aSelector
{
//    return self;
    return [SecondClass class];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    //查找父类的方法签名
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (signature) {
//        NSString *sel = NSStringFromSelector(selector);
        signature = [NSMethodSignature signatureWithObjCTypes:"@@:"];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    //拿到函数名
    NSString *key = NSStringFromSelector([anInvocation selector]);
    NSLog(@"%@", key);
}


//    //判断类中是否包含某个方法的实现
//    BOOL class_respondsToSelector(Class cls, SEL sel)
//    //获取类中的方法列表
//    Method *class_copyMethodList(Class cls, unsigned int *outCount)
//    //为类添加新的方法,如果方法该方法已存在则返回NO
//    BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types)
//    //替换类中已有方法的实现,如果该方法不存在添加该方法
//    IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types)
//    //获取类中的某个实例方法(减号方法)
//    Method class_getInstanceMethod(Class cls, SEL name)
//    //获取类中的某个类方法(加号方法)
//    Method class_getClassMethod(Class cls, SEL name)
//    //获取类中的方法实现
//    IMP class_getMethodImplementation(Class cls, SEL name)
//    //获取类中的方法的实现,该方法的返回值类型为struct
//    IMP class_getMethodImplementation_stret(Class cls, SEL name)
//
//    //获取Method中的SEL
//    SEL method_getName(Method m)
//    //获取Method中的IMP
//    IMP method_getImplementation(Method m)
//    //获取方法的Type字符串(包含参数类型和返回值类型)
//    const char *method_getTypeEncoding(Method m)
//    //获取参数个数
//    unsigned int method_getNumberOfArguments(Method m)
//    //获取返回值类型字符串
//    char *method_copyReturnType(Method m)
//    //获取方法中第n个参数的Type
//    char *method_copyArgumentType(Method m, unsigned int index)
//    //获取Method的描述
//    struct objc_method_description *method_getDescription(Method m)
//    //设置Method的IMP
//    IMP method_setImplementation(Method m, IMP imp)
//    //替换Method
//    void method_exchangeImplementations(Method m1, Method m2)
//
//    //获取SEL的名称
//    const char *sel_getName(SEL sel)
//    //注册一个SEL
//    SEL sel_registerName(const char *str)
//    //判断两个SEL对象是否相同
//    BOOL sel_isEqual(SEL lhs, SEL rhs)
//
//    //通过块创建函数指针,block的形式为^ReturnType(id self,参数,...)
//    IMP imp_implementationWithBlock(id block)
//    //获取IMP中的block
//    id imp_getBlock(IMP anImp)
//    //移出IMP中的block
//    BOOL imp_removeBlock(IMP anImp)
//
//    //调用target对象的sel方法
//    id objc_msgSend(id target, SEL sel, 参数列表...)

- (void)testRuntimeMethod
{
    //创建继承自NSObject类的People类
    Class People = objc_allocateClassPair([NSObject class], "People", 0);
    //将People类注册到runtime中
    objc_registerClassPair(People);
    //注册test: 方法选择器
    SEL sel = sel_registerName("test:");
    //函数实现
    IMP imp = imp_implementationWithBlock(^(id this,id args,...){
        NSLog(@"方法的调用者为 %@",this);
        NSLog(@"参数为 %@",args);
        return @"返回值测试";
    });
    
    //向People类中添加 test:方法;函数签名为@@:@,
    //    第一个@表示返回值类型为id,
    //    第二个@表示的是函数的调用者类型,
    //    第三个:表示 SEL
    //    第四个@表示需要一个id类型的参数
    class_addMethod(People, sel, imp, "@@:@");
    //替换People从NSObject类中继承而来的description方法
    class_replaceMethod(People,@selector(description), imp_implementationWithBlock(^NSString*(id this,...){
        return @"我是Person类的对象";}),
                        "@@:");
    
    //完成 [[People alloc]init];
//    id p1 = objc_msgSend(objc_msgSend(People, @selector(alloc)),@selector(init));
    //调用p1的sel选择器的方法,并传递@"???"作为参数
//    id result = objc_msgSend(p1, sel, @"???");
    //输出sel方法的返回值
//    NSLog(@"sel 方法的返回值为 ： %@", result);
    
    //获取People类中实现的方法列表
    NSLog(@"输出People类中实现的方法列表");
    unsigned int methodCount;
    Method * methods = class_copyMethodList(People, &methodCount);
    for (int i = 0; i<methodCount; i++) {
        NSLog(@"方法名称:%s",sel_getName(method_getName(methods[i])));
        NSLog(@"方法Types:%s",method_getDescription(methods[i])->types);
    }
    free(methods);
}

@end

















