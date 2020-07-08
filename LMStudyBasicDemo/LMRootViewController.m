//
//  ViewController.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/2/20.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "LMRootViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+KVO.h"

#import "LMRumtimeViewController.h"
#import "LMRunloopViewController.h"
#import "LMKVCViewController.h"
#import "LMKVOViewController.h"
#import "LMRefreshTestViewController.h"
#import "LMLockViewController.h"
#import "LMCoreAnimationMainViewController.h"
#import "LMThreadViewController.h"
#import "LMAudioViewController.h"
#import "LMOpenGLStudyViewController.h"
#import "ARSCNViewViewController.h"

@interface MyObject : NSObject
@property (nonatomic, strong) NSString *title;
@end

@implementation MyObject

@end

@interface LMRootViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *contentArr;

@end

@implementation LMRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"titles";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.contentArr = @[@"RunLoop", @"Runtime", @"KVO", @"KVC", @"Refresh", @"Lock", @"CoreAnimation", @"ConcurrencyProgramming", @"AudioRecord", @"openGLES", @"photo", @"ARKit"];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    [self test];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LMRunloopViewController *runloopVC = [[LMRunloopViewController alloc] init];
        [self.navigationController pushViewController:runloopVC animated:YES];
    } else if (indexPath.row == 1) {
        LMRumtimeViewController *rumtime = [[LMRumtimeViewController alloc] init];
        [self.navigationController pushViewController:rumtime animated:YES];
    } else if (indexPath.row == 2) {
        LMKVOViewController *kvo = [[LMKVOViewController alloc] init];
        [self.navigationController pushViewController:kvo animated:YES];
    } else if (indexPath.row == 3) {
        LMKVCViewController *kvc = [[LMKVCViewController alloc] init];
        [self.navigationController pushViewController:kvc animated:YES];
    } else if (indexPath.row == 4) {
        LMRefreshTestViewController *testVC = [[LMRefreshTestViewController alloc] init];
        [self.navigationController pushViewController:testVC animated:YES];
    } else if (indexPath.row == 5) {
        LMLockViewController *lockVC = [[LMLockViewController alloc] init];
        [self.navigationController pushViewController:lockVC animated:YES];
    } else if (indexPath.row == 6) {
        LMCoreAnimationMainViewController *coreAnimationVC = [[LMCoreAnimationMainViewController alloc] init];
        [self.navigationController pushViewController:coreAnimationVC animated:YES];
    } else if (indexPath.row == 7) {
        LMThreadViewController *threadVC = [[LMThreadViewController alloc] init];
        [self.navigationController pushViewController:threadVC animated:YES];
    } else if(indexPath.row == 8) {
        LMAudioViewController *audioVC = [[LMAudioViewController alloc] init];
        [self.navigationController pushViewController:audioVC animated:YES];
    } else if (indexPath.row == 9) {
        LMOpenGLStudyViewController *opengles = [[LMOpenGLStudyViewController alloc] init];
        [self.navigationController pushViewController:opengles animated:YES];
    } else if (indexPath.row == 10) {

    } else if (indexPath.row == 11) {
        ARSCNViewViewController *arscnVC = [[ARSCNViewViewController alloc] init];
        [self.navigationController pushViewController:arscnVC animated:YES];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = self.contentArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)test{
    //Now create an instance 'myobj' of class 'MyObject'
    NSLog(@"Now create an instance 'myobj' of class 'MyObject'");
    MyObject *myobj = [[MyObject alloc] init];
    Class aclass = [myobj class];
    NSLog(@"[myobj class] returns:%@(%p)", aclass, aclass);
    Class aclass2 = object_getClass(myobj);
    NSLog(@"object_getClass(myobj) returns:%@(%p)", aclass2, aclass2);
    Class aclass3 = object_getClass([myobj class]);
    NSLog(@"object_getClass([myobj class]) returns:%@(%p)", aclass3, aclass3);
    
    //Now recursively call 'class'
    NSLog(@"Now recursively call 'class'");
    id obj = myobj;
    for (int i=0; i<4; i++) {
        Class aclass = [obj class];
        obj = aclass;
        NSLog(@"pass%d [obj class] returns %@(%p)", i+1, aclass, aclass);
    }
    
    // Now recursively call 'object_getClass'.
    NSLog(@"Now recursively call 'object_getClass'");
    obj = myobj;
    for (int i=0; i<4; i++) {
        Class aclass = object_getClass(obj);
        obj = aclass;
        NSLog(@"pass%d object_getClass(obj) returns %@(%p)", i+1, aclass, aclass);
    }
    
    
    // Now add KVO to myobj.
    NSLog(@"Now add KVO to myobj.");
//    [myobj addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    NSLog(@"After KVO. [myobj class] returns %@(%p)", [myobj class], [myobj class]);
    NSLog(@"After KVO. object_getClass(myobj) returns %@(%p)", object_getClass(myobj), object_getClass(myobj));
    
    myobj.title = @"Hello, this is new title!";
    [myobj LM_addObserver:self forKey:@"title" withBlock:^(id observeObject, NSString *observedKey, id oldValue, id newValue) {
        NSLog(@"new observe ------------- ********");
    }];
    myobj.title = @"seconde new title";
    
    // Now remove KVO of myobj.
    NSLog(@"Now remove KVO of myobj.");
    [myobj removeObserver:self forKeyPath:@"title"];
    NSLog(@"KVO removed. [myobj class] returns %@(%p)", [myobj class], [myobj class]);
    NSLog(@"KVO removed. object_getClass(myobj) returns %@(%p)", object_getClass(myobj), object_getClass(myobj));
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"title"]) {
//        NSLog(@"KVO title changed:%@", [change objectForKey:NSKeyValueChangeNewKey]);
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
