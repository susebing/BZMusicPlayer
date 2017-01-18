//
//  MusicManager.m
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import "BZMusicManager.h"
#import "BZMusicModel.h"
#import "MJExtension.h"

static NSArray *_musics;
static BZMusicModel *_playingMusic;

@implementation BZMusicManager

+ (NSArray *)musics
{
    if (_musics == nil) {
        _musics = [BZMusicModel objectArrayWithFilename:@"Musics.plist"];
    }
    return _musics;
}

+ (BZMusicModel *)playingMusic
{
    return _playingMusic;
}

+ (void)setPlayingMusic:(BZMusicModel *)playingMusic
{
    if (playingMusic == nil || ![_musics containsObject:playingMusic] || playingMusic == _playingMusic) {
        return;
    }
    _playingMusic = playingMusic;
}


+ (BZMusicModel *)nextMusic
{
    int nextIndex = 0;
    if (_playingMusic) {
        int playingIndex = (int)[[self musics] indexOfObject:_playingMusic];
        nextIndex = playingIndex + 1;
        if (nextIndex >= [self musics].count) {
            nextIndex = 0;
        }
    }
    return [self musics][nextIndex];
}

+ (BZMusicModel *)previousMusic
{
    int previousIndex = 0;
    if (_playingMusic) {
        int playingIndex = (int)[[self musics] indexOfObject:_playingMusic];
        previousIndex = playingIndex - 1;
        if (previousIndex < 0) {
            previousIndex = (int)[self musics].count - 1;
        }
    }
    return [self musics][previousIndex];
}

@end
