//
//  LMAudioReplicatorAnimationView.h
//  LMStudyBasicDemo
//
//  Created by tim on 2018/7/23.
//  Copyright © 2018年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

// http://www.devtalking.com/articles/calayer-animation-replicator-animation/

@interface LMAudioReplicatorAnimationView : UIView

- (void)startRelicatorAnimation;

- (void)circleRotationAnimation;

@end


@interface KSLiveAudioRecordCountDownView : UIView

- (void)setCountDownSecond:(NSUInteger)sec;

@end


@interface KSLiveVoiceInputButton : UIImageView

@end
