//
//  LMRuntimeBasicTestViewController.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2018/1/23.
//  Copyright © 2018年 LM. All rights reserved.
//

#import "LMRuntimeBasicTestViewController.h"
#import <objc/runtime.h>

@interface Sark: NSObject
@property (nonatomic, strong) NSString *name;
- (void)speak;
@end

@implementation Sark
- (void)speak
{
    NSLog(@"my name is %@", self.name);
}
@end

void ReportFunction(id self, SEL _cmd) {
    NSLog(@"This object is %p.", self);
    NSLog(@"Class is %@, and super is %@.",[self class], [self superclass]);
    Class currentClass = [self class];
    for (int i = 1; i < 5; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = object_getClass(currentClass);
    }
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
}

@interface LMRuntimeBasicTestViewController ()

@end

@implementation LMRuntimeBasicTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // ------------- Test 2  -------------
//    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
//    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
//    BOOL res3 = [(id)[Sark class] isKindOfClass:[Sark class]];
//    BOOL res4 = [(id)[Sark class] isMemberOfClass:[Sark class]];
//    NSLog(@" ---- %d %d %d %d --- \n", res1, res2, res3, res4);
//
//    // ------------- Test 3   -------------
//
//    NSLog(@"ViewController = %@ , 地址 = %p", self, &self);
//
//    id cls = [Sark class];
//    NSLog(@"Sark class = %@ 地址 = %p", cls, &cls);
//
//    void *obj = &cls;
//    NSLog(@"Void *obj = %@ 地址 = %p", obj,&obj);
//
//    [(__bridge id)obj speak];
//
//    Sark *sark = [[Sark alloc]init];
//    NSLog(@"Sark instance = %@ 地址 = %p",sark,&sark);
//
//    [sark speak];
    Class newClass = objc_allocateClassPair([NSError class], "RuntimeErrorSubClass", 0);
    class_addMethod(newClass, @selector(report), (IMP)ReportFunction, "v@:");
    objc_registerClassPair(newClass);
    [newClass performSelector:@selector(report)];
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
