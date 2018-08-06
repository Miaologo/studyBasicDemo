//
//  LMAudioViewController.m
//  LMStudyBasicDemo
//
//  Created by tim on 2018/7/23.
//  Copyright © 2018年 LM. All rights reserved.
//

#import "LMAudioViewController.h"
#import "LMAudioReplicatorAnimationView.h"
#import <AVFoundation/AVFoundation.h>

@interface LMAudioViewController ()

@property (nonatomic, strong) LMAudioReplicatorAnimationView *replicatorAnimationView;

@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, strong) NSTimer *recordTimer;
@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, strong) NSString *filePath;


@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器
@property (nonatomic, strong) AVAudioPlayer *player; //播放器
@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址

@property (nonatomic, strong) KSLiveAudioRecordCountDownView *countDownAlertView;

@property (nonatomic, strong) UIView *recordContainerView;

@property (nonatomic, strong) CALayer *firstLayer;
@property (nonatomic, strong) CALayer *secondeLayer;

@property (nonatomic, strong) UIImageView *voiceInputImage;

@end

@implementation LMAudioViewController

- (void)LMNSLogStyle:(NSString *)text
{
    NSLog(@"\n --------- %@ ------- \n", text);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.replicatorAnimationView = [[LMAudioReplicatorAnimationView alloc] initWithFrame:CGRectMake(50, 100, 200, 100)];
    [self.view addSubview:self.replicatorAnimationView];
    
    self.recordContainerView = [[UIView alloc] initWithFrame:CGRectMake(50, 400, 250, 200)];
    self.recordContainerView.backgroundColor = [UIColor lightGrayColor];
    self.recordContainerView.layer.borderColor = [UIColor greenColor].CGColor;
    self.recordContainerView.layer.borderWidth = 0.5;
    self.recordContainerView.clipsToBounds = YES;
    [self.view addSubview:self.recordContainerView];
    
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 30, 30)];
    [self.recordButton setImage:[UIImage imageNamed:@"live_icon_voice_l_normal"] forState:UIControlStateNormal];
    [self.recordButton setImage:[UIImage imageNamed:@"live_icon_voice_l_normal"] forState:UIControlStateNormal|UIControlStateHighlighted];
    self.recordButton.layer.borderColor = [UIColor redColor].CGColor;
    self.recordButton.layer.borderWidth = 0.5;
    [self.recordContainerView addSubview:self.recordButton];
    
    
//    //添加点击事件
//    //开始监听用户的语音
//    [self.recordButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
//    //开始停止监听 并处理用户的输入
//    [self.recordButton addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
//    //取消这一次的监听
//    [self.recordButton addTarget:self action:@selector(cancelSpeak) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchCancel];
//    [self.recordButton addTarget:self action:@selector(remindCancel) forControlEvents:UIControlEventTouchCancel];
//    //显示上划取消的动画
//    [self.recordButton addTarget:self action:@selector(remindDragExit) forControlEvents:UIControlEventTouchDragExit];
//    //显示下滑发送的动画
//    [self.recordButton addTarget:self action:@selector(remindDragEnter) forControlEvents:UIControlEventTouchDragEnter];
    
//    [self.recordButton addTarget:self action:@selector(remindDragInside) forControlEvents:UIControlEventTouchDragInside];
//    [self.recordButton addTarget:self action:@selector(remindDragOutside) forControlEvents:UIControlEventTouchDragOutside];
//    [self LMNSLogStyle:[@(CACurrentMediaTime()) stringValue]];
//    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [self LMNSLogStyle:[@(CACurrentMediaTime()) stringValue]];
//    }];
    
    self.voiceInputImage = [[KSLiveVoiceInputButton alloc] initWithFrame:CGRectMake(50, 650, 40, 40)];
    self.voiceInputImage.userInteractionEnabled = YES;
    self.voiceInputImage.layer.borderColor = [UIColor redColor].CGColor;
    self.voiceInputImage.layer.borderWidth = 0.5;
    self.voiceInputImage.image = [UIImage imageNamed:@"live_icon_voice_l_normal"];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.voiceInputImage addGestureRecognizer:panGesture];
    [self.view addSubview:self.voiceInputImage];

}

- (void)handleGesture:(UIPanGestureRecognizer *)panGesture
{
    [self LMNSLogStyle:@"handleGesture"];
    CGPoint translation = [panGesture translationInView:panGesture.view];
    // 2. 让当前控件做响应的平移
    panGesture.view.transform = CGAffineTransformTranslate(panGesture.view.transform, translation.x, translation.y);
    // 3. 每次平移手势识别完毕后, 让平移的值不要累加
    [panGesture setTranslation:CGPointZero inView:panGesture.view];

}

- (void)cancelSpeak
{
    [self LMNSLogStyle:@"UIControlEventTouchUpOutside"];
}

//
- (void)remindCancel
{
    [self LMNSLogStyle:@"UIControlEventTouchCancel"];
}

- (void)remindDragInside
{
//    [self LMNSLogStyle:@"UIControlEventTouchDragInside"];
    [self LMNSLogStyle:@"  -- "];

}
- (void)remindDragOutside
{
    [self LMNSLogStyle:@"UIControlEventTouchDragOutside"];
}

//

- (void)remindDragExit
{
    [self LMNSLogStyle:@"UIControlEventTouchDragExit"];
}

- (void)remindDragEnter
{
    [self LMNSLogStyle:@"UIControlEventTouchDragEnter"];
}

- (void)showCircleBackground
{
    CALayer *firstLayer = [CALayer new];
    firstLayer.backgroundColor = [UIColor colorWithRed:256 green:128 blue:0 alpha:1].CGColor;
    CGFloat firstRadius = 50;
    firstLayer.bounds = CGRectMake(0, 0, firstRadius, firstRadius);
    firstLayer.anchorPoint = CGPointZero;
    CGFloat orignX = (firstRadius - self.recordButton.frame.size.width)/2;
    firstLayer.position = CGPointMake(-orignX, -orignX);
    firstLayer.cornerRadius = firstRadius/2;
    [self.recordButton.layer addSublayer:firstLayer];
    self.firstLayer = firstLayer;
    CALayer *secondLayer = [CALayer new];
    secondLayer.backgroundColor = [UIColor colorWithRed:256 green:128 blue:0 alpha:0.5].CGColor;
    CGFloat secondRadius = 112;
    secondLayer.bounds = CGRectMake(0, 0, secondRadius, secondRadius);
    secondLayer.anchorPoint = CGPointZero;
    CGFloat orignX2 = (secondRadius - self.recordButton.frame.size.width)/2;
    secondLayer.position = CGPointMake(-orignX2, -orignX2);
    secondLayer.cornerRadius = secondRadius/2;
    [self.recordButton.layer addSublayer:secondLayer];
    self.secondeLayer = secondLayer;
    
}


- (void)startRecord
{
    [self LMNSLogStyle:@"UIControlEventTouchDown"];
    [self showCircleBackground];
    self.countDown = 15;
    return;
    [self addTimer];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (session == nil) {
        NSLog(@"Error creating session: %@",[sessionError description]);
    } else {
        [session setActive:YES error:nil];
    }
    self.session = session;
    
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.filePath = [path stringByAppendingString:@"/RRecord.wav"];
    
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:self.filePath];
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0], AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM], AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh], AVEncoderAudioQualityKey,
                                   nil];
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    if (_recorder) {
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopRecord];
        });
    } else {
        [self LMNSLogStyle:@"音频格式和文件存储格式不匹配,无法初始化Recorder"];
    }
}

- (void)stopRecord {
    [self.firstLayer removeFromSuperlayer];
    [self.secondeLayer removeFromSuperlayer];
    return;
    [self removeTimer];
    [self LMNSLogStyle:@"停止录音 -- UIControlEventTouchUpInside"];
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.filePath]){
//        _noticeLabel.text = [NSString stringWithFormat:@"录了 %ld 秒,文件大小为 %.2fKb", 60 - (long)self.countDown,[[manager attributesOfItemAtPath:self.filePath error:nil] fileSize]/1024.0];
    } else {
//        _noticeLabel.text = @"最多录60秒";
    }
}

- (void)PlayRecord {
    [self LMNSLogStyle:@"播放录音"];
    [self.recorder stop];
    if ([self.player isPlaying])return;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    [self LMNSLogStyle:[@(self.player.data.length/1024) stringValue]];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLabelText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [_recordTimer invalidate];
    self.recordTimer = nil;
    
}


- (void)refreshLabelText{
    
   self.countDown--;
//    _noticeLabel.text = [NSString stringWithFormat:@"还剩 %ld 秒",(long)self.countDown];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.replicatorAnimationView startRelicatorAnimation];
//    [self.replicatorAnimationView circleRotationAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
