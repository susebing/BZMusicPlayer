//
//  BZNavagationView.h
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZShowLrcView : UIView

@property(nonatomic, strong) NSString *fileName;
@property (nonatomic, assign) NSTimeInterval currentTime;

@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UITableView *lrcTableView;

@property(nonatomic, strong) UIView *introView;

@property(nonatomic, strong) UILabel *singerLabel;
@property(nonatomic, strong) UILabel *songLabel;

@property(nonatomic, strong) BZSysButton *leftButton;
@property(nonatomic, strong) BZSysButton *rightButton;


-(instancetype)initWithFrame:(CGRect)frame withLeftBlock:(ButtonClickBlock)leftBlock withRightBlock:(ButtonClickBlock)rightBlock;

@end
