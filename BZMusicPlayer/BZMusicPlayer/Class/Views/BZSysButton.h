//
//  SysButton.h
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZSysButton : UIButton

-(instancetype)initWithFrame:(CGRect)frame
                  withCenter:(CGPoint)center
                     WithTag:(NSInteger)tag
         withNormalImageName:(NSString *)normal
         withSelectImageName:(NSString *)select
             withButtonClick:(ButtonClickBlock)btnClickBlock;

@end
