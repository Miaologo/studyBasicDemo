//
//  LMAudioPlayViewController.m
//  LMStudyBasicDemo
//
//  Created by tim on 2018/7/21.
//  Copyright © 2018年 LM. All rights reserved.
//

#import "LMAudioPlayViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LMAudioPlayViewController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation LMAudioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    [session setActive:YES error:nil];
    
    //开启接近监视(靠近耳朵的时候听筒播放,离开的时候扬声器播放)
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)name:UIDeviceProximityStateDidChangeNotification object:nil];
    
    // LM-TODO
    NSString *filePath = @"";
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filePath] error:nil];
    
    self.audioPlayer.delegate = self;
    //准备播放 / 播放
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
    //停止播放
    [self.audioPlayer stop];
    //暂停播放
    [self.audioPlayer pause];
    
    //proximityStateChange:(NSNotificationCenter *)notification方法
    if ([[UIDevice currentDevice] proximityState] == YES) {
        //靠近耳朵
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        //离开耳朵
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    

}

//AVAudioPlayerDelegate
//when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption(播放完成)
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}
//if an error occurs while decoding it will be reported to the delegate.(解码结束)
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    
}
//when the audio session has been interrupted while the player was playing. The player will have been paused(被打断)
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player NS_DEPRECATED_IOS(2_2, 8_0)
{
    
}
//when the audio session interruption has ended and this player had been interrupted while playing(被打断结束)
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags NS_DEPRECATED_IOS(6_0, 8_0)
{
    
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
