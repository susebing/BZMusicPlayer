//
//  BZSliderView.m
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import "BZSliderView.h"

@interface BZSliderView()

@property(nonatomic, copy) TapGestureBlock tapGstBlock;
@property(nonatomic, copy) PanGestureBlock panGstBlock;

@end

@implementation BZSliderView

-(instancetype)initWithFrame:(CGRect)frame withBackgroundColor:(UIColor *)bgColor withTapGestureBlock:(TapGestureBlock)tapGestureBlock withPanGestureBlock:(PanGestureBlock)panGestureBlock{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = bgColor;

        if (tapGestureBlock) {
            self.tapGstBlock = tapGestureBlock;
        }
        if (panGestureBlock) {
            self.panGstBlock = panGestureBlock;
        }

        //进度背景
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AAdaption(92), frame.size.height)];
        [_progressView setBackgroundColor:[UIColor colorFromHexString:MainThemeColorString]];
        [self addSubview:_progressView];

        //时长
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - AAdaption(100), 0, AAdaption(100), frame.size.height)];
        [_totalTimeLabel setFont:AAFont(24)];
        [self addSubview:_totalTimeLabel];

        //滑块
        _sliderButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, AAdaption(100), frame.size.height)];
        _sliderButton.layer.cornerRadius = frame.size.height/2;
        [_sliderButton setBackgroundColor:[UIColor colorFromHexString:SliderButtonColorString]];
        [_sliderButton.titleLabel setFont:AAFont(24)];
        [_sliderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_sliderButton];

        UITapGestureRecognizer *tapGst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGstEvent:)];
        [self addGestureRecognizer:tapGst];

        UIPanGestureRecognizer *panGst = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGstEvent:)];
        [self.sliderButton addGestureRecognizer:panGst];
    }
    return self;
}

#pragma mark 手势事件
-(void)tapGstEvent:(UITapGestureRecognizer *)sender{
    self.tapGstBlock(sender);
}

-(void)panGstEvent:(UIPanGestureRecognizer *)sender{
    self.panGstBlock(sender);
}

@end
