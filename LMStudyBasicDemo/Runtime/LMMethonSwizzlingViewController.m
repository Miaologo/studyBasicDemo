//
//  LMMethonSwizzlingViewController.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2018/1/23.
//  Copyright © 2018年 LM. All rights reserved.
//

#import "LMMethonSwizzlingViewController.h"
#import <objc/runtime.h>

@interface LMMethonSwizzlingViewController ()

@end

@implementation LMMethonSwizzlingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


@implementation LMMethonSwizzlingViewController(Tracking)

//+ (void)load
//{
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
//}
//
//- (void)xxx_viewWillAppear:(BOOL)animated {
//    
//    [self xxx_viewWillAppear:animated];
//    NSLog(@"----- xxx viewwillappear  ----- \n");
//}

@end
