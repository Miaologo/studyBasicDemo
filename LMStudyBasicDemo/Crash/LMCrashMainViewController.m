//
//  LMCrashMainViewController.m
//  LMStudyBasicDemo
//
//  Created by Miao Liu on 2019/7/9.
//  Copyright © 2019 LM. All rights reserved.
//

#import "LMCrashMainViewController.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/signal.h>

#import <mach/task.h>
#import <mach/mach_init.h>
#import <mach/mach_port.h>

//int ret = task_set_exception_ports(mach_task_self(), EXC_MASK_BAD_ACCESS, MACH_PORT_NULL, EXCEPTION_DEFAULT, 0);

void sig_handle(int sig, siginfo_t *info, ucontext_t *ucontext) {
    NSLog(@"signal caught 0: %d, pc 0x%llx\n", sig, ucontext->uc_mcontext->__ss.__pc);
    ucontext->uc_mcontext->__ss.__pc = ucontext->uc_mcontext->__ss.__lr;
    
}

@interface LMCrashMainViewController ()

@end

@implementation LMCrashMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    struct sigaction sa;
    memset(&sa, 0, sizeof(struct sigaction));
    sa.sa_flags = SA_SIGINFO;
    sa.sa_sigaction = sig_handle;
    
    sigaction(SIGSEGV, &sa, NULL);
    sigaction(SIGINT, &sa, NULL);
    sigaction(SIGABRT, &sa, NULL);
    sigaction(SIGKILL, &sa, NULL);
    sigaction(SIGBUS, &sa, NULL);
    
    [NSThread detachNewThreadSelector:@selector(entry) toTarget:self withObject:nil];
}

- (void)entry {
    void *a = calloc(1, sizeof(void *));
    ((void(*)())a)();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"hehe" message:@"revice!" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
