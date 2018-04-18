//
//  LMThreadViewController.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2018/3/30.
//  Copyright © 2018年 LM. All rights reserved.
//

#import "LMThreadViewController.h"
#import "pthread.h"

@interface LMThreadViewController ()
@property (nonatomic, strong) NSString *target;

@end

@implementation LMThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply(100000, queue, ^(size_t i) {
//        self.target = [NSString stringWithFormat:@"abcdefghijk%zu",i];
        self.target = @"abcdefghijk%zu";
    });
    
    pthread_t thread = NULL;
    pthread_create(&thread, NULL, lmThreadOperate, "my_param");
}

void *lmThreadOperate(void *param){
    pthread_setname_np("my_thread");
    char thread_name[10];
    pthread_getname_np(pthread_self(), thread_name, 10);
    printf("an operation running in %s with param \"%s\"", thread_name, param);
    pthread_exit((void *)0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
