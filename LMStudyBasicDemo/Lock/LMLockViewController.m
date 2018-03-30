//
//  LMLockViewController.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2018/2/9.
//  Copyright © 2018年 LM. All rights reserved.
//

#import "LMLockViewController.h"
#import <pthread.h>

@interface LMLockViewController ()

@property (atomic, strong) NSString *target;

@end

@implementation LMLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self testNSLock];
//    [self testConditionLock];
//    [self testRecursiveLock];
//    [self testCondition];
//    [self testDispatchSemaphore];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_queue_t queue = dispatch_queue_create("parallel", DISPATCH_QUEUE_CONCURRENT);
//    for (int i =0; i < 10000; i+=1) {
//        dispatch_async(queue, ^{
//            @synchronized(self){
//                self.target = [NSString stringWithFormat:@"------ %@ ----\n", [@(i) stringValue]];
//            }
////            self.target = [NSString stringWithFormat:@"------ %@ ----\n", [@(i) stringValue]];
////            self.target = @"1";
//            NSLog(@"---%@----\n", self.target);
//        });
//    }
    dispatch_async(queue, ^{
        for (int i = 0; i < 100000; i ++) {
            if (i % 2 == 0) {
                self.target = @"a very long string";
            }
            else {
                self.target = @"string";
            }
            NSLog(@"Thread A: %@\n", self.target);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 100000; i ++) {
            if (self.target.length >= 10) {
                NSString* subStr = [self.target substringWithRange:NSMakeRange(0, 10)];
            }
            NSLog(@"Thread B: %@\n", self.target);
        }
    });
}

// https://www.jianshu.com/p/ddbe44064ca4
- (void)testNSLock
{
    NSLock *lock = [[NSLock alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lock];
        NSLog(@"---  线程1 加锁 ----\n");
        sleep(10);
        [lock unlock];
        NSLog(@"---- 线程1 解锁 ---- \n");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1); //以保证让线程2的代码后执行
        [lock lock];
        NSLog(@"-----  线程2 ------\n");
        [lock unlock];
    });
}

- (void)testConditionLock
{
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:0];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lockWhenCondition:1];
        NSLog(@"---  线程1 加锁 ----\n");
        sleep(2);
        [lock unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);//以保证让线程2的代码后执行
        if ([lock tryLockWhenCondition:0]) {
            NSLog(@"---  线程2 加锁 ----\n");
            [lock unlockWithCondition:2];
            NSLog(@"---  线程2 解锁 ----\n");
        } else {
            NSLog(@"---  线程2 加锁失败----\n");
        }
    });
    
    //线程3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);//以保证让线程2的代码后执行
        if ([lock tryLockWhenCondition:2]) {
            NSLog(@"---- 线程3  ------ \n");
            [lock unlock];
            NSLog(@"----- 线程3 解锁成功 -------- \n");
        } else {
            NSLog(@"------ 线程3 尝试加锁失败 -----\n");
        }
    });
    
    //线程4
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(3);//以保证让线程2的代码后执行
        if ([lock tryLockWhenCondition:2]) {
            NSLog(@"----- 线程4  -----\n");
            [lock unlockWithCondition:1];
            NSLog(@"------ 线程4 解锁成功  -----\n");
        } else {
            NSLog(@"------ 线程4 尝试加锁失败 ------\n");
        }
    });
}

- (void)testRecursiveLock
{
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            [lock lock];
            if (value > 0) {
                NSLog(@"value:%d", value);
                RecursiveBlock(value - 1);
            }
            [lock unlock];
        };
        RecursiveBlock(2);
    });
}

- (void)testCondition
{
    //
    NSCondition *lock = [[NSCondition alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lock];
        while (!array.count) {
            NSLog(@" ----- 1 ---- \n");
            [lock wait]; //
        }
        [array removeAllObjects];
        NSLog(@"----- 1 array removeAllObjects  ----\n");
        [lock unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lock];
        while (!array.count) {
            NSLog(@" ----- 2 ---- \n");
            [lock wait];
        }
        [array removeAllObjects];
        NSLog(@"----- 2 array removeAllObjects  ----\n");
        [lock unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);//以保证让线程2的代码后执行
        [lock lock];
        [array addObject:@(1)];
        NSLog(@"array addObject:@1");
        [lock signal];
        [lock unlock];
    });
    
//    其中 signal 和 broadcast 方法的区别在于，signal 只是一个信号量，只能唤醒一个等待的线程，想唤醒多个就得多次调用，而 broadcast 可以唤醒所有在等待的线程。如果没有等待的线程，这两个方法都没有作用
}

- (void)testSynchronized
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(self) {
            sleep(2);
            NSLog(@"---- 线程1 --- \n");
        }
        NSLog(@"---- 线程1解锁成功 ----\n");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        @synchronized(self) {
            NSLog(@"----- 线程2 -----\n");
        }
    });
    /*
    @synchronized(object) 指令使用的 object 为该锁的唯一标识，只有当标识相同时，才满足互斥，所以如果线程 2 中的 @synchronized(self) 改为@synchronized(self.view)，则线程2就不会被阻塞，@synchronized 指令实现锁的优点就是我们不需要在代码中显式的创建锁对象，便可以实现锁的机制，但作为一种预防措施，@synchronized 块会隐式的添加一个异常处理例程来保护代码，该处理例程会在异常抛出的时候自动的释放互斥锁。@synchronized 还有一个好处就是不用担心忘记解锁了。
    
    如果在 @sychronized(object){} 内部 object 被释放或被设为 nil，从我做的测试的结果来看，的确没有问题，但如果 object 一开始就是 nil，则失去了锁的功能。不过虽然 nil 不行，但 @synchronized([NSNull null]) 是完全可以的。^ ^.
     */

}

- (void)testDispatchSemaphore
{
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(signal, overTime);
        sleep(2);
        NSLog(@"---- 线程1 --- \n");
        dispatch_semaphore_signal(signal);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        dispatch_semaphore_wait(signal, overTime);
        NSLog(@"---- 线程2 --- \n");
        dispatch_semaphore_signal(signal);
    });
}

- (void)testOSSpinLock
{
//    __block OSSpinLock theLock = OS_SPINLOCK_INIT;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        OSSpinLockLock(&theLock);
//        NSLog(@"线程1");
//        sleep(10);
//        OSSpinLockUnlock(&theLock);
//        NSLog(@"线程1解锁成功");
//    });
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        OSSpinLockLock(&theLock);
//        NSLog(@"线程2");
//        OSSpinLockUnlock(&theLock);
//    });

    /*
    拿上面的输出结果和上文 NSLock 的输出结果做对比，会发现 sleep(10) 的情况，OSSpinLock 中的“线程 2”并没有和”线程 1解锁成功“在一个时间输出，而 NSLock 这里是同一时间输出，而是有一点时间间隔，所以 OSSpinLock 一直在做着轮询，而不是像 NSLock 一样先轮询，再 waiting 等唤醒。
    */
}
static pthread_mutex_t theLock;
- (void)testpthread_mutex
{
    pthread_mutex_init(&theLock, NULL);
    
    pthread_t thread;
    pthread_create(&thread, NULL, threadMethotd1, NULL);
    
    pthread_t thread2;
    pthread_create(&thread2, NULL, threadMethotd2, NULL);

}
void *threadMethotd1() {
    pthread_mutex_lock(&theLock);
    printf("线程1\n");
    sleep(2);
    pthread_mutex_unlock(&theLock);
    printf("线程1解锁成功\n");
    return 0;
}

void *threadMethotd2() {
    sleep(1);
    pthread_mutex_lock(&theLock);
    printf("线程2\n");
    pthread_mutex_unlock(&theLock);
    return 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
