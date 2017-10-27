//
//  LMRefreshTestViewController.m
//  LMStudyBasicDemo
//
//  Created by Tim on 2017/9/26.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "LMRefreshTestViewController.h"
#import "UIScrollView+LMRefreshHeaderView.h"

@interface LMRefreshTestViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *contentOffsetLabel;

@end

@implementation LMRefreshTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.scrollView];
    self.scrollView.refreshHeaderView = [[MAYRefreshHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    __weak typeof(self) weakSelf = self;
    self.scrollView.refreshHeaderView.action = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.scrollView.refreshHeaderView endRefreshing];
        });
        
    };
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1000)];
    greenView.backgroundColor = [UIColor whiteColor];
    _contentOffsetLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    _contentOffsetLabel.textColor = [UIColor redColor];
    _contentOffsetLabel.font = [UIFont systemFontOfSize:20];
    [greenView addSubview:_contentOffsetLabel];
    
    [self.scrollView addSubview:greenView];
    self.scrollView.contentSize = greenView.frame.size;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        self.contentOffsetLabel.text = [NSString stringWithFormat:@"%f", self.scrollView.contentOffset.y];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
