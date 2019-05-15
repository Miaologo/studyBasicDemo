//
//  main.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/2/20.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#include <pthread/introspection.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>

pthread_introspection_hook_t g_oldpthread_introspection_hook = NULL;

void mypthread_introspection_hook(unsigned int event, pthread_t thread, void *addr, size_t size) {
    uint64_t threadId;
    pthread_threadid_np(thread, &threadId);
    printf("thread_id = %llu, addr = %p, size = %zu\n", threadId, addr, size);
    switch (event) {
        case PTHREAD_INTROSPECTION_THREAD_CREATE:
            
            break;
        case PTHREAD_INTROSPECTION_THREAD_START:
            
            break;
            
        case PTHREAD_INTROSPECTION_THREAD_TERMINATE:
            
            break;
        case PTHREAD_INTROSPECTION_THREAD_DESTROY:
            
            break;
        default:
            break;
    }
    //记得在最后或者开头调用老的hook函数

    if (g_oldpthread_introspection_hook != NULL) {
        g_oldpthread_introspection_hook(event, thread, addr, size);
    }
}

int main(int argc, char * argv[]) {
    //注册线程监控的回调函数为mypthread_introspection_hook
//    g_oldpthread_introspection_hook = pthread_introspection_hook_install(mypthread_introspection_hook);
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
