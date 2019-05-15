//
//  MAYCustomMetricsInterceptor.m
//  MeituanMovie
//
//  Created by LiuMiao on 2018/3/23.
//  Copyright © 2018年 sankuai. All rights reserved.
//

#import "MAYCustomMainThreadWatcher.h"

#define LMMainThreadWatcher_Watch_Interval 1.0f
#define LMMainThreadWatcher_Watching_Level (16.0f/1000.0f)

#define Notification_LMMainThreadWatcher_Worker_Ping @"LMMainThreadWatcher_Worker_ping"
#define Notification_LMMainThreadWatcher_Main_Pong @"LMMainThreadWatcher_Main_Pong"

#include <signal.h>
#include <pthread.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>

#define CALLSTACK_SIG SIGUSR1
static pthread_t mainThreadID;

static void thread_signal_handler(int sig) {
    NSLog(@"main thread catch signal: %d", sig);
    if (sig != CALLSTACK_SIG) {
        return;
    }
    NSArray *callStack = [NSThread callStackSymbols];
    id<LMMainThreadWatcherDelegate> delegate = [LMMainThreadWatcher shareInstance].watchDelegate;
    if (delegate != nil && [delegate respondsToSelector:@selector(onMainThreadSlowStackDetected:)]) {
        [delegate onMainThreadSlowStackDetected:callStack];
    } else {
        NSLog(@"detect slow call stack on main thread!\n");
        for (NSString *call in callStack) {
            NSLog(@"%@\n", call);
        }
    }
    return;
}

static void install_signal_handle()
{
    signal(CALLSTACK_SIG, thread_signal_handler);
}

static void prinMainThreadCallStack()
{
    NSLog(@"sending signal: %d to main thread", CALLSTACK_SIG);
    pthread_kill(mainThreadID, CALLSTACK_SIG);
}

dispatch_source_t creatGCDTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, interval), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}
@interface LMMainThreadWatcher()
@property (nonatomic, strong) dispatch_source_t pingTimer;
@property (nonatomic, strong) dispatch_source_t pongTimer;
@end

@implementation LMMainThreadWatcher

+ (instancetype)shareInstance
{
    static LMMainThreadWatcher *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [LMMainThreadWatcher new];
    });
    return instance;
}
- (void)startWatch
{
    if ([NSThread isMainThread] == false) {
        NSLog(@"Error: startwatch must be called from main thread!");
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectPingFromWorkerThread) name:Notification_LMMainThreadWatcher_Worker_Ping object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectPongFromMainThread) name:Notification_LMMainThreadWatcher_Main_Pong object:nil];
    install_signal_handle();
    mainThreadID = pthread_self();
    uint64_t interval = LMMainThreadWatcher_Watch_Interval * NSEC_PER_SEC;
    self.pingTimer = creatGCDTimer(interval, interval/10000, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self pingMainThread];
    });
}
- (void)pingMainThread
{
    uint64_t interval = LMMainThreadWatcher_Watch_Interval * NSEC_PER_SEC;
    self.pongTimer = creatGCDTimer(interval, interval / 10000, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self onPongTimeout];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LMMainThreadWatcher_Worker_Ping object:nil];
    });
}

- (void)detectPingFromWorkerThread
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LMMainThreadWatcher_Main_Pong object:nil];
}

- (void)onPongTimeout
{
    [self canclePongTimer];
    prinMainThreadCallStack();
    
}

- (void)detectPongFromMainThread
{
    [self canclePongTimer];
}

- (void)canclePongTimer
{
    if (self.pongTimer) {
        dispatch_source_cancel(_pongTimer);
        _pongTimer = nil;
    }
}

@end


//  ----------- 基于Runloop ---------

//- (void)setupRunloopObserver
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        CFRunLoopRef runloop = CFRunLoopGetCurrent();
//
//        CFRunLoopObserverRef enterObserver;
//        enterObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
//                                                kCFRunLoopEntry | kCFRunLoopExit,
//                                                true,
//                                                -0x7FFFFFFF,
//                                                BBRunloopObserverCallBack, NULL);
//        CFRunLoopAddObserver(runloop, enterObserver, kCFRunLoopCommonModes);
//        CFRelease(enterObserver);
//    });
//}
//
//static void BBRunloopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
//    switch (activity) {
//        case kCFRunLoopEntry: {
//            NSLog(@"enter runloop...");
//        }
//            break;
//        case kCFRunLoopExit: {
//            NSLog(@"leave runloop...");
//        }
//            break;
//        default: break;
//    }
//}












