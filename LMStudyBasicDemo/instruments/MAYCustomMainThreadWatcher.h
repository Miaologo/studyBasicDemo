//
//  MAYCustomMetricsInterceptor.h
//  MeituanMovie
//
//  Created by LiuMiao on 2018/3/23.
//  Copyright © 2018年 sankuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LMMainThreadWatcherDelegate<NSObject>
- (void)onMainThreadSlowStackDetected:(NSArray *)slowStack;
@end

@interface LMMainThreadWatcher : NSObject

@property (nonatomic, weak) id<LMMainThreadWatcherDelegate> watchDelegate;

+ (instancetype)shareInstance;
- (void)startWatch;

@end
