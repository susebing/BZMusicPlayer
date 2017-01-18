//
//  BZSliderView.h
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZSliderView : UIView

@property(nonatomic, strong) UILabel *totalTimeLabel;

@property(nonatomic, strong) UIView *progressView;

@property(nonatomic, strong) UIButton *sliderButton;

/**
 自定义 Slider 进度条

 @param frame       进度条尺寸
 @param bgColor     进度条背景色
= @param tapGestureBlock tapGestureBlock 进度按钮被点击
 @param panGestureBlock panGestureBlock 进度按钮被拖动
 @return            进度条视图对象
 */
-(instancetype)initWithFrame:(CGRect)frame withBackgroundColor:(UIColor *)bgColor withTapGestureBlock:(TapGestureBlock)tapGestureBlock withPanGestureBlock:(PanGestureBlock)panGestureBlock;

@end
