//
//  BZMusicPlayViewController.m
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import "BZMusicPlayViewController.h"
#import "BZShowLrcView.h"
#import "BZSliderView.h"
#import "BZPlayView.h"

#import "BZMusicModel.h"

#import <MediaPlayer/MediaPlayer.h>


@interface BZMusicPlayViewController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) BZMusicModel *playingMusic;
@property (nonatomic, strong) AVAudioPlayer *player;
/**
 *  显示播放进度条的定时器
 */
@property (nonatomic, strong) NSTimer *timer;
/**
 *  显示歌词的定时器
 */
@property (nonatomic, strong) CADisplayLink *lrcTimer;

@property(nonatomic,strong)BZShowLrcView *lrcView;
@property(nonatomic,strong)BZSliderView *bottomSliderView;
@property(nonatomic,strong)BZPlayView *bottomPlayView;

@end

@implementation BZMusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark addSubviews
-(void)addSubviews{
    [self.view addSubview:self.lrcView];
    [self.view addSubview:self.bottomSliderView];
    [self.view addSubview:self.bottomPlayView];
}
#pragma mark ----设置数据
-(void)setData{

    if (self.playingMusic != [BZMusicManager playingMusic]) {
        [self resetPlayingMusic];
    }
    [self startPlayingMusic];
}
#pragma mark ----音乐控制
//重置播放的歌曲
- (void)resetPlayingMusic
{
    [self setLrcViewData];
    [self setBottomSliderView];

    //停止播放音乐
    [[BZAudioManager defaultManager] stopMusic:self.playingMusic.filename];
    self.player = nil;

    //清空歌词
    self.lrcView.fileName = @"";
    self.lrcView.currentTime = 0;

    [self removeCurrentTimer];
    [self removeLrcTimer];
}

-(void)setLrcViewData{
    // 重置界面数据
    self.lrcView.bgImageView.hidden = NO;
    self.lrcView.bgImageView.image = [UIImage imageNamed:self.playingMusic.icon];
    self.lrcView.songLabel.text = self.playingMusic.name;
    self.lrcView.singerLabel.text = self.playingMusic.singer;
    self.lrcView.rightButton.selected = YES;
    self.lrcView.lrcTableView.hidden = YES;
    self.lrcView.introView.hidden = NO;

    //切换歌词
    self.lrcView.fileName = self.playingMusic.lrcname;
}

-(void)setBottomSliderView{

    self.bottomSliderView.sliderButton.titleLabel.text = [NSString stringWithTime:0];
    self.bottomSliderView.sliderButton.x = 0;
    self.bottomSliderView.progressView.width = self.bottomSliderView.sliderButton.center.x;
    [self.bottomSliderView.sliderButton setTitle:[NSString stringWithTime:0] forState:UIControlStateNormal];
    self.bottomSliderView.totalTimeLabel.text = [NSString stringWithTime:self.player.duration];
}

//开始播放音乐
- (void)startPlayingMusic
{
    [self removeCurrentTimer];
    [self removeLrcTimer];

    if (self.playingMusic == [BZMusicManager playingMusic])  {

        [self addCurrentTimer];
        [self addLrcTimer];
        return;
    }else{

        self.playingMusic = [BZMusicManager playingMusic];


        //开发播放音乐
        self.player = [[BZAudioManager defaultManager] playingMusic:self.playingMusic.filename];
        self.player.delegate = self;

        // 设置所需要的数据
        self.bottomPlayView.pausePlayButton.selected = YES;
        [self setLrcViewData];
        [self setBottomSliderView];

        //添加定时器,使得 Slider 每秒移动
        [self addCurrentTimer];
        [self addLrcTimer];
        
        //切换锁屏
        [self updateLockedScreenMusic];
    }
}
#pragma mark ----锁屏时候的设置，效果需要在真机上才可以看到
- (void)updateLockedScreenMusic
{
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];

    // 初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = self.playingMusic.name;
    // 歌手
    info[MPMediaItemPropertyArtist] = self.playingMusic.singer;
    // 歌曲名称
    info[MPMediaItemPropertyTitle] = self.playingMusic.name;
    // 设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:self.playingMusic.icon]];

    // 设置持续时间（歌曲的总时间）
    info[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    // 设置当前播放进度
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.player.currentTime);

    // 切换播放信息
    center.nowPlayingInfo = info;

    // 远程控制事件 Remote Control Event
    // 加速计事件 Motion Event
    // 触摸事件 Touch Event

    // 开始监听远程控制事件
    // 成为第一响应者（必备条件）
    [self becomeFirstResponder];
    // 开始监控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark ----进度条定时器处理
/**
 *  添加定时器
 */
- (void)addCurrentTimer
{
    if (![self.player isPlaying]) return;

    //在新增定时器之前，先移除之前的定时器
    [self removeCurrentTimer];

    [self updateCurrentTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeCurrentTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  触发定时器
 */
- (void)updateCurrentTimer
{
    double temp = self.player.currentTime / self.player.duration;
    self.bottomSliderView.sliderButton.x = temp * (self.view.width - self.bottomSliderView.sliderButton.width);
    [self.bottomSliderView.sliderButton setTitle:[NSString stringWithTime:self.player.currentTime] forState:UIControlStateNormal];
    self.bottomSliderView.progressView.width = self.bottomSliderView.sliderButton.center.x;
}

#pragma mark ----歌词定时器

- (void)addLrcTimer
{
    if (self.lrcView.hidden == YES) return;

    if (self.player.isPlaying == NO && self.lrcTimer) {
        [self updateLrcTimer];
        return;
    }

    [self removeLrcTimer];

    [self updateLrcTimer];

    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcTimer)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

- (void)updateLrcTimer
{
    self.lrcView.currentTime = self.player.currentTime;
}

#pragma mark Getter
-(BZShowLrcView *)lrcView{
    if (!_lrcView) {
        __weak typeof(self) weakSelf = self;
        _lrcView = [[BZShowLrcView alloc] initWithFrame:AAdaptionRect(0, 0, 750, 1334-188-40) withLeftBlock:^(UIButton *sender) {

            [weakSelf dismissViewControllerAnimated:YES completion:^{

            }];
        } withRightBlock:^(UIButton *sender) {

            if (sender.selected) {
                weakSelf.lrcView.bgImageView.hidden = NO;
//                weakSelf.lrcView.bgImageView.image = [UIImage imageNamed:self.playingMusic.icon];
                weakSelf.lrcView.lrcTableView.hidden = YES;
                weakSelf.lrcView.introView.hidden = NO;
            }else{

                weakSelf.lrcView.bgImageView.hidden = YES;
//                weakSelf.lrcView.bgImageView.image = [UIImage imageNamed:@"play_cover_pic_bg2"];
                weakSelf.lrcView.lrcTableView.hidden = NO;
                weakSelf.lrcView.introView.hidden = YES;
            }
        }];
    }
    return _lrcView;
}

-(BZSliderView *)bottomSliderView{
    if (!_bottomSliderView) {
        __weak typeof(self) weakSelf = self;
        _bottomSliderView = [[BZSliderView alloc] initWithFrame:AAdaptionRect(0, 1334 - 188 - 40, 750, 40) withBackgroundColor:[UIColor colorFromHexString:SliderBgColorString] withTapGestureBlock:^(UITapGestureRecognizer *sender) {
            CGPoint point = [sender locationInView:sender.view];
            weakSelf.player.currentTime = (point.x / sender.view.width) * self.player.duration;
            [weakSelf updateCurrentTimer];
            [weakSelf updateLrcTimer];

        } withPanGestureBlock:^(UIPanGestureRecognizer *sender) {
            //得到挪动距离
            CGPoint point = [sender translationInView:sender.view];
            //将translation清空，免得重复叠加
            [sender setTranslation:CGPointZero inView:sender.view];

            CGFloat maxX = self.view.width - sender.view.width;
            sender.view.x += point.x;

            if (sender.view.x < 0) {
                sender.view.x = 0;
            }
            else if (sender.view.x > maxX){
                sender.view.x = maxX;
            }
            CGFloat time = (sender.view.x / (self.view.width - sender.view.width)) * self.player.duration;
            [weakSelf.bottomSliderView.sliderButton setTitle:[NSString stringWithTime:time] forState:UIControlStateNormal];
            [weakSelf.bottomSliderView.sliderButton setTitle:[NSString stringWithTime:time] forState:UIControlStateNormal];
            weakSelf.bottomSliderView.progressView.width = sender.view.center.x;

            if (sender.state == UIGestureRecognizerStateBegan) {
                [weakSelf removeCurrentTimer];
                [weakSelf removeLrcTimer];
            }
            else if (sender.state == UIGestureRecognizerStateEnded)
            {
                weakSelf.player.currentTime = time ;
                [weakSelf addCurrentTimer];
                [weakSelf addLrcTimer];
            }
        }];
    }
    return _bottomSliderView;
}

-(BZPlayView *)bottomPlayView{
    __weak typeof(self) weakSelf = self;

    if (!_bottomPlayView) {
        _bottomPlayView = [[BZPlayView alloc] initWithFrame:AAdaptionRect(0, 1334 - 188, 750, 188) withBackGroundColor:[UIColor colorFromHexString:MainBgColorString] withPlayBlock:^(UIButton *sender) {

            [weakSelf play];

        } withPauseBlock:^(UIButton *sender) {

            [weakSelf pause];

        } withPreBlock:^(UIButton *sender) {

            [weakSelf pre];

        } withNextBlock:^(UIButton *sender) {

            [weakSelf next];
        }];
    }
    return _bottomPlayView;
}
#pragma mark ----AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self next];
}
/**
 *  当电话给过来时，进行相应的操作
 *
 */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [self pause];
}
/**
 *  打断结束，做相应的操作
 *
 */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    [self play];
}

#pragma mark ----私有方法
/**
 播放
 */
-(void)play{
    [[BZAudioManager defaultManager] playingMusic:self.playingMusic.filename];
    [self addCurrentTimer];
    [self addLrcTimer];
}
/**
 暂停
 */
-(void)pause{
    [[BZAudioManager defaultManager] pauseMusic:self.playingMusic.filename];
    [self removeCurrentTimer];
    [self removeLrcTimer];
}
/**
 上一首
 */
-(void)pre{
    [[BZAudioManager defaultManager] stopMusic:self.playingMusic.filename];
    [BZMusicManager setPlayingMusic:[BZMusicManager previousMusic]];
    [self startPlayingMusic];
}
/**
 下一首
 */
- (void)next {
    [[BZAudioManager defaultManager] stopMusic:self.playingMusic.filename];
    [BZMusicManager setPlayingMusic:[BZMusicManager nextMusic]];
    [self startPlayingMusic];
}

#pragma mark - 远程控制事件监听(BackGround)
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self pause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self next];
            break;

        case UIEventSubtypeRemoteControlPreviousTrack:
            [self pre];
        default:
            break;
    }
}

@end
