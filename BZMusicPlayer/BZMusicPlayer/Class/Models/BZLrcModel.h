//
//  BZLrcModel.h
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZLrcModel : NSObject
/**
 *  时间点
 */
@property (nonatomic, copy) NSString *time;
/**
 *  词
 */
@property (nonatomic, copy) NSString *word;
/**
 *  返回所有的歌词model
 *
 */
+ (NSMutableArray *)lrcLinesWithFileName:(NSString *)fileName;

@end
