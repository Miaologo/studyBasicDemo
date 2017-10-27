//
//  LMKVCViewController.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/7/31.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "LMKVCViewController.h"
#import "LMTestKVCObject.h"

@interface LMKVCViewController ()

@end

@implementation LMKVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    LMTestKVCObject *testObject = [LMTestKVCObject new];
    [testObject setValue:@"newName" forKey:@"name"];
    NSString* name = [testObject valueForKey:@"name"];
    NSLog(@"%@",name);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
