//
//  ViewController.m
//  LyricScrollDemo
//
//  Created by jj L on 2017/6/1.
//  Copyright © 2017年 jj L. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "Track.h"
#import "DOUAudioStreamer.h"
#import "LyricView.h"
#import "LyricUtils.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;

static const CGFloat PlayButtonWidth = 80;

@interface ViewController ()

@property (nonatomic, strong) DOUAudioStreamer *streamer;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) LyricView *lyricView;
@property (nonatomic, assign) NSInteger currentLine;
@property (nonatomic, strong) NSTimer *playTimer;
@property (nonatomic, strong) NSArray<NSNumber *> *lyricTimes;
@property (nonatomic, strong) NSArray<NSString *> *lyricLines;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPlayButton];
    [self setupLyricView];
    [self startTimer];
}

- (void)setupPlayButton {
    UIButton *playButton = [[UIButton alloc] init];
    [playButton setTitle:@"pause" forState:UIControlStateNormal];
    [playButton setTitle:@"play" forState:UIControlStateSelected];
    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    playButton.backgroundColor = [UIColor redColor];
    playButton.layer.cornerRadius = PlayButtonWidth / 2;
    playButton.clipsToBounds = YES;
    [playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(PlayButtonWidth));
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_bottom).offset(-PlayButtonWidth);
    }];
    self.playButton = playButton;
}

- (void)setupLyricView {
    self.lyricView = [[LyricView alloc] init];
    [self.view addSubview:self.lyricView];
    
    [self.lyricView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lyricView.superview).offset(50);
        make.bottom.equalTo(self.playButton.mas_top).offset(-20);
        make.left.right.equalTo(self.lyricView.superview);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.streamer == nil) {
        [self setupStramer];
    }
}

- (void)playButtonPressed:(UIButton *)button {
    button.selected = !button.selected;
    if (self.streamer.status == DOUAudioStreamerPaused) {
        [self.streamer play];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MusicPlayStatus" object:self userInfo:@{@"play": @(YES)}];
    } else {
        [self.streamer pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MusicPlayStatus" object:self userInfo:@{@"play": @(NO)}];
    }
}

- (void)cancelStreamer {
    if (self.streamer != nil) {
        [self.streamer stop];
        [self.streamer removeObserver:self forKeyPath:@"status"];
        [self.streamer removeObserver:self forKeyPath:@"duration"];
        self.streamer = nil;
    }
}

- (void)setupStramer {
    Track *track = [[Track alloc] init];
    track.audioFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", [[NSBundle mainBundle] pathForResource:@"music.mp3" ofType:nil]]];
    self.lyricTimes = [LyricUtils timeArrayWithLyric:track.lyric];
    self.lyricLines = [LyricUtils lyricArrayWithLyric:track.lyric];
    self.streamer = [DOUAudioStreamer streamerWithAudioFile:track];
    [self.streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [self.streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    [self.streamer play];
}

#pragma mark - KVO Handler

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    } else if (context == kDurationKVOKey) {
        [self performSelector:@selector(updatePlayerSlider:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)updatePlayerSlider:(id)timer {
    if (self.streamer == nil) {
        return;
    }
    if (self.streamer.status == DOUAudioStreamerFinished) {
        [self.streamer play];
    }
    if (self.currentLine < self.lyricLines.count && fabs([self.streamer currentTime] - self.lyricTimes[self.currentLine].floatValue) < 0.01) {
        CGFloat duration = 1;
        if (self.currentLine == self.lyricLines.count - 1) {
            duration = self.streamer.duration - self.lyricTimes[self.currentLine].floatValue;
        } else {
            duration = self.lyricTimes[self.currentLine + 1].floatValue - self.lyricTimes[self.currentLine].floatValue;
        }
        [self.lyricView bindDataWithLyricArray:self.lyricLines playingLine:self.currentLine duration:duration];
        self.currentLine += 1;
    }
}

- (void)updateStatus {
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            NSLog(@"DOUAudioStreamerPlaying");
            break;
            
        case DOUAudioStreamerPaused:
            NSLog(@"DOUAudioStreamerPaused");
            break;
            
        case DOUAudioStreamerIdle:
            NSLog(@"DOUAudioStreamerIdle");
            break;
            
        case DOUAudioStreamerFinished:
            NSLog(@"DOUAudioStreamerFinished");
            break;
            
        case DOUAudioStreamerBuffering:
            NSLog(@"DOUAudioStreamerBuffering");
            break;
            
        case DOUAudioStreamerError:
            NSLog(@"DOUAudioStreamerError");
            break;
    }
}

- (void)startTimer {
    [self stopTimer];
    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updatePlayerSlider:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.playTimer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (self.playTimer != nil) {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

@end
