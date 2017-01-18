//
//  SysButton.m
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import "BZSysButton.h"

@interface BZSysButton()

@property(nonatomic, strong) ButtonClickBlock btnClickBlock;

@end

@implementation BZSysButton

-(instancetype)initWithFrame:(CGRect)frame
                       withCenter:(CGPoint)center
                          WithTag:(NSInteger)tag
              withNormalImageName:(NSString *)normal
              withSelectImageName:(NSString *)select
             withButtonClick:(ButtonClickBlock)btnClickBlock
{
    self = [super initWithFrame:frame];
    if (self) {

        if (btnClickBlock) {
            self.btnClickBlock = btnClickBlock;
        }

        self.center = center;
        self.tag = tag;
        [self setBackgroundImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:select] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)buttonClick{
    __weak typeof(self) weakSelf = self;
    weakSelf.btnClickBlock(self);
}

@end
