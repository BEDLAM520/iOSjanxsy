//
//  ViewController.m
//  SULoader
//
//  Created by 万众科技 on 16/6/24.
//  Copyright © 2016年 万众科技. All rights reserved.
//

#import "ViewController.h"
//#import "SUPlayer.h"
#import "SUResourceLoader.h"
//    NSURL * url = [[NSBundle mainBundle]URLForResource:@"Take a back" withExtension:@"mp3"];
//    NSURL *url = [NSURL URLWithString:@"http://zyvideo1.oss-cn-qingdao.aliyuncs.com/zyvd/7c/de/04ec95f4fd42d9d01f63b9683ad0"];
typedef NS_ENUM(NSInteger, SUPlayerState) {
    SUPlayerStateWaiting,
    SUPlayerStatePlaying,
    SUPlayerStatePaused,
    SUPlayerStateStopped,
    SUPlayerStateBuffering,
    SUPlayerStateError
};
#import <AVKit/AVKit.h>
@interface ViewController ()<SULoaderDelegate>

//@property (nonatomic, strong) SUPlayer * llplayer;
@property (nonatomic, assign) NSInteger songIndex;
@property (nonatomic, strong)UIView *playerView;

@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) AVPlayerItem * currentItem;
@property (nonatomic, strong) SUResourceLoader * resourceLoader;
@property (nonatomic, strong) AVPlayerLayer *avlayer;
@property (nonatomic, strong) id timeObserve;
@property (nonatomic, assign) SUPlayerState state;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat cacheProgress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playerView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.playerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.playerView];
    
    NSURL * url = [NSURL URLWithString:@"https://mvvideo5.meitudata.com/56ea0e90d6cb2653.mp4"];
    self.url = url;
    [self reloadCurrentItem];
    
//    [self.progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeProgress:(UISlider *)slider {
//    float seekTime = self.llplayer.duration * slider.value;
//    [self.llplayer seekToTime:seekTime];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"progress"]) {
//        if (self.progressSlider.state != UIControlStateHighlighted) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                self.progressSlider.value = self.llplayer.progress;
////                self.currentTime.text = [self convertStringWithTime:self.llplayer.duration * self.llplayer.progress];
//            });
//        }
//    }
//    if ([keyPath isEqualToString:@"duration"]) {
//        if (self.llplayer.duration > 0) {
//            self.durationLbl.text = [self convertStringWithTime:self.llplayer.duration];
//            self.durationLbl.hidden = NO;
//            self.currentTime.hidden = NO;
//        }else {
//            self.durationLbl.hidden = YES;
//            self.currentTime.hidden = YES;
//        }
//    }
    if ([keyPath isEqualToString:@"cacheProgress"]) {
//        NSLog(@"缓存进度：%f", self.player.cacheProgress);
    }
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        AVPlayerItem * songItem = object;
        NSArray * array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        NSLog(@"共缓冲%.2f",totalBuffer);
    }
    if ([keyPath isEqualToString:@"rate"]) {
        if (self.player.rate == 0.0) {
            _state = SUPlayerStatePaused;
        }else {
            _state = SUPlayerStatePlaying;
        }
    }
}

- (NSString *)convertStringWithTime:(float)time {
    if (isnan(time)) time = 0.f;
    int min = time / 60.0;
    int sec = time - min * 60;
    NSString * minStr = min > 9 ? [NSString stringWithFormat:@"%d",min] : [NSString stringWithFormat:@"0%d",min];
    NSString * secStr = sec > 9 ? [NSString stringWithFormat:@"%d",sec] : [NSString stringWithFormat:@"0%d",sec];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@",minStr, secStr];
    return timeStr;
}

///////////////////////////////////////////////
- (void)reloadCurrentItem {
    //Item
    if ([self.url.absoluteString hasPrefix:@"http"]) {
        //有缓存播放缓存文件
        NSString * cacheFilePath = [SUFileHandle cacheFileExistsWithURL:self.url];
        if (cacheFilePath) {
            NSURL * url = [NSURL fileURLWithPath:cacheFilePath];
            self.currentItem = [AVPlayerItem playerItemWithURL:url];
            NSLog(@"有缓存，播放缓存文件");
        }else {
            //没有缓存播放网络文件
            self.resourceLoader = [[SUResourceLoader alloc]init];
            self.resourceLoader.delegate = self;
            
            AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[self.url customSchemeURL] options:nil];
            [asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
            self.currentItem = [AVPlayerItem playerItemWithAsset:asset];
            NSLog(@"无缓存，播放网络文件");
        }
    }else {
        self.currentItem = [AVPlayerItem playerItemWithURL:self.url];
        NSLog(@"播放本地文件");
    }
    //Player
    self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterrupted:) name:AVAudioSessionInterruptionNotification object:nil];
    
    //Observer
    [self addObserver];
    
    //State
    _state = SUPlayerStateWaiting;
}

- (void)replaceItemWithURL:(NSURL *)url {
    self.url = url;
    [self reloadCurrentItem];
}


- (void)play {
    if (self.state == SUPlayerStatePaused || self.state == SUPlayerStateWaiting) {
        [self.player play];
    }
}


- (void)pause {
    if (self.state == SUPlayerStatePlaying) {
        [self.player pause];
    }
}

- (BOOL)isPlaying{
    if (self.state == SUPlayerStatePlaying) {
        return YES;
    }
    return NO;
}

- (void)stop {
    if (self.state == SUPlayerStateStopped) {
        return;
    }
    [self.player pause];
    [self.resourceLoader stopLoading];
    [self removeObserver];
    self.resourceLoader = nil;
    self.currentItem = nil;
    self.player = nil;
    self.progress = 0.0;
    self.duration = 0.0;
    self.state = SUPlayerStateStopped;
}

- (void)seekToTime:(CGFloat)seconds {
    if (self.state == SUPlayerStatePlaying || self.state == SUPlayerStatePaused) {
        // 暂停后滑动slider后    暂停播放状态
        // 播放中后滑动slider后   自动播放状态
        //        [self.player pause];
        self.resourceLoader.seekRequired = YES;
        [self.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
            NSLog(@"seekComplete!!");
            if ([self isPlaying]) {
                [self.player play];
            }
        }];;
    }
}

#pragma mark - NSNotification 打断处理

- (void)audioSessionInterrupted:(NSNotification *)notification{
    //通知类型
    NSDictionary * info = notification.userInfo;
    // AVAudioSessionInterruptionTypeBegan ==
    if ([[info objectForKey:AVAudioSessionInterruptionTypeKey] integerValue] == 1) {
        [self.player pause];
    }else{
        [self.player play];
    }
}


#pragma mark - KVO
- (void)addObserver {
    AVPlayerItem * songItem = self.currentItem;
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
    //播放进度
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat current = CMTimeGetSeconds(time);
        CGFloat total = CMTimeGetSeconds(songItem.duration);
        weakSelf.duration = total;
        weakSelf.progress = current / total;
    }];
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [songItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [songItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    AVPlayerItem * songItem = self.currentItem;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    [songItem removeObserver:self forKeyPath:@"status"];
    [songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [songItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [songItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [self.player replaceCurrentItemWithPlayerItem:nil];
}


- (void)playbackFinished {
    NSLog(@"播放完成");
    [self stop];
}

#pragma mark - SULoaderDelegate
- (void)loader:(SUResourceLoader *)loader cacheProgress:(CGFloat)progress {
    self.cacheProgress = progress;
}

#pragma mark - Property Set
- (void)setProgress:(CGFloat)progress {
    [self willChangeValueForKey:@"progress"];
    _progress = progress;
    [self didChangeValueForKey:@"progress"];
}

- (void)setState:(SUPlayerState)state {
    [self willChangeValueForKey:@"progress"];
    _state = state;
    [self didChangeValueForKey:@"progress"];
}

- (void)setCacheProgress:(CGFloat)cacheProgress {
    [self willChangeValueForKey:@"progress"];
    _cacheProgress = cacheProgress;
    [self didChangeValueForKey:@"progress"];
}

- (void)setDuration:(CGFloat)duration {
    if (duration != _duration && !isnan(duration)) {
        [self willChangeValueForKey:@"duration"];
        NSLog(@"duration %f",duration);
        _duration = duration;
        [self didChangeValueForKey:@"duration"];
    }
}

#pragma mark - CacheFile
- (BOOL)currentItemCacheState {
    if ([self.url.absoluteString hasPrefix:@"http"]) {
        if (self.resourceLoader) {
            return self.resourceLoader.cacheFinished;
        }
        return YES;
    }
    return NO;
}

- (NSString *)currentItemCacheFilePath {
    if (![self currentItemCacheState]) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/%@", [NSString cacheFolderPath], [NSString fileNameWithURL:self.url]];;
}

+ (BOOL)clearCache {
    [SUFileHandle clearCache];
    return YES;
}

@end
