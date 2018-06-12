//
//  LMRunloopViewController.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/7/31.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "LMRunloopViewController.h"

@interface TestDealloc : NSObject

@end

@interface LMRunloopViewController ()

@property (nonatomic, strong) TestDealloc *testProperty;

@end

@implementation LMRunloopViewController

- (void)dealloc
{
    NSLog(@" --- VC  dealloc ----");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.testProperty = [[TestDealloc alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

@implementation TestDealloc

- (void)dealloc
{
    NSLog(@" ---- dealloc ");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end


