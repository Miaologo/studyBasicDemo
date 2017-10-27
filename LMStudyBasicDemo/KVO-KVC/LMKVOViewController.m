//
//  LMKVOViewController.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/7/31.
//  Copyright © 2017年 LM. All rights reserved.
//
#import "LMKVOViewController.h"

const NSString *constString1 = @"I am const NSString *string";
NSString const *constString2 = @"I am NSString const *string";
NSString * const stringConst = @"I am NSString * const string";
static const NSString *temp = @"I am an new const NSString *string";

@interface LMKVOViewController ()

@property (nonatomic, strong) NSArray *arrayOfStrong;
@property (nonatomic, copy) NSArray *arrayOfCopy;
@property (nonatomic, strong) NSMutableArray *mutableArrayOfStrong;
@property (nonatomic, copy) NSMutableArray *mutableArrayOfCopy;

@end

@implementation LMKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    constString1 = &temp;
    constString1 = @"";
//    stringConst = @"";
    NSString *(^tempBlock)() = ^ {
        NSString *tempStr = nil;
        return tempStr;
    };
    NSURL *temp = [NSURL URLWithString:tempBlock()];
    NSLog(@"%@",temp);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
