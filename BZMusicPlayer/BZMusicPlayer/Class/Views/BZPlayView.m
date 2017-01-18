//
//  PlayView.m
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import "BZPlayView.h"

@interface BZPlayView()

@property(nonatomic, copy) ButtonClickBlock playBlock;
@property(nonatomic, copy) ButtonClickBlock pauseBlock;
@property(nonatomic, copy) ButtonClickBlock preBlock;
@property(nonatomic, copy) ButtonClickBlock nextBlock;

@end

@implementation BZPlayView

-(instancetype)initWithFrame:(CGRect)frame
         withBackGroundColor:(UIColor *)bgColor
               withPlayBlock:(ButtonClickBlock)playBlock
              withPauseBlock:(ButtonClickBlock)pauseBlock
                withPreBlock:(ButtonClickBlock)preBlock
               withNextBlock:(ButtonClickBlock)nextBlock{

    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;

        self.backgroundColor = bgColor;

        if (playBlock) {
            self.playBlock = playBlock;
        }
        if (pauseBlock) {
            self.pauseBlock = pauseBlock;
        }
        if (preBlock) {
            self.preBlock = preBlock;
        }
        if (nextBlock) {
            self.nextBlock = nextBlock;
        }
        //播放暂停按钮
        _pausePlayButton = [[BZSysButton alloc] initWithFrame:AAdaptionRect(0, 0, 144, 92)
                                                           withCenter:CGPointMake(frame.size.width/2, frame.size.height/2)
                                                              WithTag:1000
                                                  withNormalImageName:@"play"
                                                  withSelectImageName:@"pause"
                                                      withButtonClick:^(UIButton *sender) {
                                                          sender.selected = !sender.selected;
                                                          if (sender.selected) {
                                                              weakSelf.playBlock(sender);
                                                          }else{
                                                              weakSelf.pauseBlock(sender);
                                                          }
                                                      }];
        _pausePlayButton.selected = YES;
        [self addSubview:_pausePlayButton];

        //上一首
        _preButton = [[BZSysButton alloc] initWithFrame:AAdaptionRect(0, 0, 83, 92)
                                                  withCenter:CGPointMake(CGRectGetMaxX(_pausePlayButton.frame) - 244/2, frame.size.height/2)
                                                     WithTag:1001
                                         withNormalImageName:@"previous"
                                         withSelectImageName:@"previous"
                                                withButtonClick:^(UIButton *sender) {
                                                    weakSelf.preBlock(sender);
                                         }];
        [self addSubview:_preButton];

        //下一首
        _nextButton = [[BZSysButton alloc] initWithFrame:AAdaptionRect(0, 0, 83, 92)
                                                   withCenter:CGPointMake(CGRectGetMaxX(_pausePlayButton.frame) + 100/2, frame.size.height/2)
                                                      WithTag:1002
                                          withNormalImageName:@"next"
                                          withSelectImageName:@"next" withButtonClick:^(UIButton *sender) {
                                              weakSelf.nextBlock(sender);
                                          }];
        [self addSubview:_nextButton];
    }
    return self;
}

@end
