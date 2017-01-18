//
//  PlayView.h
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BZPlayView : UIView

@property(nonatomic, strong) BZSysButton *pausePlayButton;
@property(nonatomic, strong) BZSysButton *preButton;
@property(nonatomic, strong) BZSysButton *nextButton;

/**
 播放工具条

 @param frame       播放视图frame
 @param playBlock   播放被点击
 @param pauseBlock  暂停被点击
 @param preBlock    上一首被点击
 @param nextBlock   下一首被点击
 @return            返回播放视图
 */
-(instancetype)initWithFrame:(CGRect)frame
         withBackGroundColor:(UIColor *)bgColor
               withPlayBlock:(ButtonClickBlock)playBlock
              withPauseBlock:(ButtonClickBlock)pauseBlock
                withPreBlock:(ButtonClickBlock)preBlock
               withNextBlock:(ButtonClickBlock)nextBlock;

@end
