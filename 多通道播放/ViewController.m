//
//  ViewController.m
//  多通道播放
//
//  Created by william on 16/8/19.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic,strong) AVAudioEngine *engine;

@property (nonatomic,strong) AVAudioPCMBuffer *buffer;

@property (nonatomic,strong) AVAudioPlayerNode *player;

//另一个播放器
@property (nonatomic,strong) AVAudioPlayerNode *player2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAVAudioSession];
    [self playMoreAudio];
}

- (void)playMoreAudio{
    _player = [[AVAudioPlayerNode alloc] init];
    NSError *error;
    AVAudioFile *file = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"五环之歌" ofType:@"mp3"]] error:nil];
    _buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[file processingFormat] frameCapacity:((AVAudioFrameCount)file.length)];
    [file readIntoBuffer:_buffer error:&error];
    
    _player2 = [[AVAudioPlayerNode alloc] init];
    AVAudioFile *file2 = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"drumLoop" ofType:@"caf"]] error:nil];
    AVAudioPCMBuffer *buffer2 = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[file2 processingFormat] frameCapacity:((AVAudioFrameCount )file2.length)];
    [file2 readIntoBuffer:buffer2 error:&error];
    
    AVAudioFormat *stereoFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:44100 channels:4];
    
    _engine = [[AVAudioEngine alloc] init];
    [_engine attachNode:_player];
    [_engine attachNode:_player2];
    [_engine connect:_player to:[_engine mainMixerNode] fromBus:0 toBus:2 format:stereoFormat];
    [_engine connect:_player2 to:[_engine mainMixerNode] fromBus:0 toBus:1 format:stereoFormat];
    
    [_engine startAndReturnError:&error];
    [_player scheduleBuffer:_buffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
    [_player2 scheduleBuffer:buffer2 atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
    [_player play];
    [_player2 play];
    _player.volume = 0.5;
    
}

- (void)initAVAudioSession
{
    // Configure the audio session
    AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
    NSError *error;
    
    // set the session category
    bool success = [sessionInstance setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (!success) NSLog(@"Error setting AVAudioSession category! %@\n", [error localizedDescription]);
    success = [sessionInstance setActive:YES error:&error];
    if (!success) NSLog(@"Error setting session active! %@\n", [error localizedDescription]);
}


@end
