//
//  LMFrequenceWaveViewController.m
//  LMStudyBasicDemo
//
//  Created by Miao Liu on 2019/5/22.
//  Copyright © 2019 LM. All rights reserved.
//

#import "LMFrequenceWaveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>

static const int fftsize = 2048;

@interface LMFrequenceWaveViewController ()

@property (nonatomic, strong) AVAudioEngine *engine;
@property (nonatomic, strong) AVAudioPlayerNode *playerNode;
@property (nonatomic, assign) int fftSize;
@property (nonatomic, assign) FFTSetup fftSetup;

@end

@implementation LMFrequenceWaveViewController

- (void)dealloc {
    vDSP_destroy_fftsetup(_fftSetup);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.engine = [AVAudioEngine new];
    self.playerNode = [AVAudioPlayerNode new];
    
    [self.engine attachNode:self.playerNode];
    [self.engine connect:self.playerNode to:self.engine.mainMixerNode format:nil];
    
    __weak typeof(self) weak_self = self;
    [self.engine.mainMixerNode installTapOnBus:0 bufferSize:(AVAudioFrameCount)fftsize format:nil block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        __strong typeof(self) strong_self = weak_self;
        if (!strong_self.playerNode.isPlaying) {
            return;
        }
        buffer.frameLength = (AVAudioFrameCount)strong_self.fftSize;
//        float *amplitudes = [strong_self fft:buffer];
        if (strong_self) {
            
        }
        
    }];
    
    [self.engine prepare];
    
    NSError *error;
    [self.engine startAndReturnError:&error];
    
}

- (void)playWithFileName:(NSString *)fileName {
    NSURL *audioFileUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    NSError *readingError;
    AVAudioFile *audioFile = [[AVAudioFile alloc] initForReading:audioFileUrl error:&readingError];
    [self.playerNode stop];
    [self.playerNode scheduleFile:audioFile atTime:nil completionHandler:nil];
    [self.playerNode play];
}

- (void)stop {
    [self.playerNode stop];
}

- (FFTSetup)fftSetup {
    if (!_fftSetup) {
        vDSP_Length log2n = (vDSP_Length)(round(log2(self.fftSize)));
        _fftSetup = vDSP_create_fftsetup(log2n, kFFTRadix2);
    }
    return _fftSetup;
}

//- (float *)fft:(AVAudioPCMBuffer *)buffer {
//    float *amplitudes;
//
//    float *floatChannelData = malloc(buffer.frameLength * sizeof(float));
//    memcpy(floatChannelData, buffer.floatChannelData[0], buffer.frameLength * sizeof(float));
//
//    float *channels = floatChannelData;
//
//    int channelCount = (int)buffer.format.channelCount;
//    BOOL isInterLeaved = buffer.format.interleaved;
//
//    if (isInterLeaved) {
//        float *interleaveData = malloc(sizeof(self.fftSize * channelCount));
//        memcpy(interleaveData, buffer.floatChannelData[0], sizeof(float) * self.fftSize * channelCount);
//        float *channelsTemp = malloc(sizeof(self.fftSize * channelCount));
//        for (int i = 0; i < channelCount; i++) {
//
//        }
//    }
//
//    for (int i = 0; i < channelCount; i+=1) {
//        float *channel = channels;
//
//        float *window = (float *)malloc(self.fftSize * sizeof(float));
//        memset(window, 0, self.fftSize * sizeof(float));
//        vDSP_hann_window(window, self.fftSize, vDSP_HANN_NORM);
//        vDSP_vmul(channel, 1, window, 1, channel, 1, self.fftSize);
//
//        COMPLEX_SPLIT fftInOut;
//        fftInOut.realp = (float *)malloc(self.fftSize / 2 * sizeof(float));
//        fftInOut.imagp = (float *)malloc(self.fftSize / 2 * sizeof(float));
//        memset(fftInOut.realp, 0, self.fftSize / 2 * sizeof(float));
//        memset(fftInOut.imagp, 0, self.fftSize / 2 * sizeof(float));
//
//        float *in_real = (float *)malloc(sizeof(float) * self.fftSize);
//
//        vDSP_ctoz(<#const DSPComplex * _Nonnull __C#>, <#vDSP_Stride __IC#>, <#const DSPSplitComplex * _Nonnull __Z#>, <#vDSP_Stride __IZ#>, <#vDSP_Length __N#>)
//
//
//    }
//
//    return NULL;
//}

- (float *)performFFT:(AVAudioPCMBuffer *)buffer {
    if (buffer == NULL) {
        return NULL;
    }
    
    int frameLength = buffer.frameLength;
    long nOver2 = frameLength / 2;
    vDSP_Length fftLength = nOver2;
    
    float *imag = (float *)calloc(frameLength, sizeof(float));
    DSPSplitComplex splitComplex;
    
    splitComplex.realp = buffer.floatChannelData[0];
    splitComplex.imagp = imag;
    
//    int log2n = (vDSP_Length)(floor(log2((float)frameLength)));
//    int radix = kFFTRadix2;
    vDSP_Length log2n = (vDSP_Length)(round(log2(self.fftSize)));
    
    FFTSetup weights = self.fftSetup;
    vDSP_fft_zip(weights, &splitComplex, 1, log2n, (FFTDirection)FFT_FORWARD);
    
    
}

@end
