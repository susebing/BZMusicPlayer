//
//  NSString+Time.m
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/18.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)

+ (NSString *)stringWithTime:(NSTimeInterval)time
{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute, second];
}

@end
