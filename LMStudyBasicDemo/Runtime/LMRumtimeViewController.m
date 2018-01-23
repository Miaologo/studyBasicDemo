//
//  LMRumtimeViewController.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/7/31.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "LMRumtimeViewController.h"
#import "LMMethonSwizzlingViewController.h"
#import <objc/runtime.h>


@interface LMRumtimeViewController ()

@property (nonatomic, strong) LMMethonSwizzlingViewController *swizzleVC;

@end

@implementation LMRumtimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _swizzleVC = [[LMMethonSwizzlingViewController alloc] init];
    [self.view addSubview:_swizzleVC.view];
    _swizzleVC.view.frame = CGRectMake(50, 100, 100, 100);
    _swizzleVC.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:_swizzleVC];
    [_swizzleVC didMoveToParentViewController:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"------ viewwillappear ---- \n");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation LMRumtimeViewController(Tracking)

+ (void)load
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        SEL originalSel = @selector(viewWillAppear:);
//        SEL swizzleSel = @selector(xxx_viewWillAppear:);
//
//        Method originalMethod = class_getInstanceMethod(class, originalSel);
//        Method swizzleMethod = class_getInstanceMethod(class, swizzleSel);
//
//        BOOL didAddMethod = class_addMethod(class, originalSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
//        if (didAddMethod) {
//            class_replaceMethod(class, swizzleSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzleMethod);
//        }
//    });
/// -------------------  下面的功能和上面想同   -----------------
//    Class class = [self class];
//    SEL originalSel = @selector(viewWillAppear:);
//    SEL swizzleSel = @selector(xxx_viewWillAppear:);
//    Method originalMethod = class_getInstanceMethod(class, originalSel);
//    Method swizzleMethod = class_getInstanceMethod(class, swizzleSel);
//
//    if (!originalMethod || !swizzleMethod) {
//        return;
//    }
//    IMP originalIMP = method_getImplementation(originalMethod);
//    IMP swizzleIMP = method_getImplementation(swizzleMethod);
//    const char *originalType = method_getTypeEncoding(originalMethod);
//    const char *swizzleType = method_getTypeEncoding(swizzleMethod);
//
//    // 这儿的先后顺序是有讲究的,如果先执行后一句,那么在执行完瞬间方法被调用容易引发死循环
//    class_replaceMethod(class, swizzleSel, originalIMP, originalType);
//    class_replaceMethod(class, originalSel, swizzleIMP, swizzleType);
//    //这是因为class_replaceMethod方法其实能够覆盖到class_addMethod和method_setImplementation两种场景, 对于第一个class_replaceMethod来说, 如果viewWillAppear:实现在父类, 则执行class_addMethod, 否则就执行method_setImplementation将原方法的IMP指定新的代码块; 而第二个class_replaceMethod完成的工作便只是将新方法的IMP指向原来的代码.
//    //
//    //但此处需要特别注意交换的顺序,应该优化把新的方法指定原IMP,再修改原有的方法的IMP.
    [LMRumtimeViewController addAnotherClassMethod];
}

+ (void)addAnotherClassMethod
{
    Class originalClass = NSClassFromString(@"LMMethonSwizzlingViewController");
    Class swizzleClass = [self class];
    SEL originalSel = NSSelectorFromString(@"viewWillAppear:");
    SEL swizzleSel = @selector(xxx_viewWillAppear:);
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    Method swizzleMethod = class_getInstanceMethod(swizzleClass, swizzleSel);
    
    // 向orignialclass新添加一个 xxx_viewWillAppear 方法
    BOOL registerMethod = class_addMethod(originalClass, swizzleSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (!registerMethod) {
        return;
    }
    
    // 需要更新swizzlemethod变量，获取当前originalclass的method指针
    swizzleMethod = class_getInstanceMethod(originalClass, swizzleSel);
    if (!swizzleMethod) {
        return;
    }
    
    BOOL didAddMethod = class_addMethod(originalClass, originalSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(originalClass, swizzleSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }

}


- (void)xxx_viewWillAppear:(BOOL)animated {
    
    [self xxx_viewWillAppear:animated];
    NSLog(@"----- xxx viewwillappear  ----- \n");
}

@end
