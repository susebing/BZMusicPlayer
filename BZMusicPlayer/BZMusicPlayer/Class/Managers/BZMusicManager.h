//
//  MusicManager.h
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BZMusicModel;

/**
 音乐管理员：用于操作数据层
 */
@interface BZMusicManager : NSObject

/**
 *  正在播放的歌曲
 *
 */
+ (BZMusicModel *)playingMusic;
/**
 *  重新设置歌曲
 *
 */
+ (void)setPlayingMusic:(BZMusicModel *)playingMusic;

/**
 *
 *
 *  @return 所有歌曲
 */
+ (NSArray *)musics;

/**
 *
 *  下一首歌曲
 */
+ (BZMusicModel *)nextMusic;

/**
 *  上一首歌曲
 *
 */
+ (BZMusicModel *)previousMusic;


@end
