//
//  LMAudioRecordViewController.m
//  LMStudyBasicDemo
//
//  Created by tim on 2018/7/21.
//  Copyright © 2018年 LM. All rights reserved.
//

#import "LMAudioRecordViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LMAudioRecordViewController () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@end

// temp code 
//http://www.voidcn.com/article/p-wsjwrcad-bu.html

@implementation LMAudioRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    /* AVAudioSessionCategoryPlayAndRecord :录制和播放 AVAudioSessionCategoryAmbient :用于非以语音为主的应用,随着静音键和屏幕关闭而静音. AVAudioSessionCategorySoloAmbient :类似AVAudioSessionCategoryAmbient不同之处在于它会中止其它应用播放声音。 AVAudioSessionCategoryPlayback :用于以语音为主的应用,不会随着静音键和屏幕关闭而静音.可在后台播放声音 AVAudioSessionCategoryRecord :用于需要录音的应用,除了来电铃声,闹钟或日历提醒之外的其它系统声音都不会被播放,只提供单纯录音功能. */
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    [session setActive:YES error:nil];
    // 录音参数
    NSDictionary *setting = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,// 编码格式
                             [NSNumber numberWithFloat:8000], AVSampleRateKey, //采样率
                             [NSNumber numberWithInt:2], AVNumberOfChannelsKey, //通道数
                             [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,  //采样位数(PCM专属)
                             [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,  //是否允许音频交叉(PCM专属)
                             [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,  //采样信号是否是浮点数(PCM专属)
                             [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,  //是否是大端存储模式(PCM专属)
                             [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,  //音质
                             nil];
    self.audioRecorder.delegate = self;
    //开启音频测量
    self.audioRecorder.meteringEnabled = YES;
    // LM-TODO
    NSString *filePath = @"";
    //保存路径
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:filePath] settings:setting error:nil];
    //准备 / 开始录音
    [self.audioRecorder prepareToRecord];
    [self.audioRecorder record];
    
    //暂停录音
    [self.audioRecorder pause];
    //停止录音
    [self.audioRecorder stop];
    //删除录音
    

}

//AVAudioRecorderDelegate
//when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption.(录音完成)
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    
}
//if an error occurs while encoding it will be reported to the delegate(编码发生错误)
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error
{
    
}
//when the audio session has been interrupted while the recorder was recording. The recorded file will be closed.(被打断)
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder NS_DEPRECATED_IOS(2_2, 8_0)
{
    
}
//when the audio session interruption has ended and this recorder had been interrupted while recording(被打断结束)
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags NS_DEPRECATED_IOS(6_0, 8_0)
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
