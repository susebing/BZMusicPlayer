//
//  Defines.h
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/18.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

//主题色
#define MainThemeColorString @"#5597fc"
//歌词 & PlayView背景色 
#define MainBgColorString @"#E9EAF0"

//进度条背景颜色
#define SliderBgColorString @"#BEC2D1"
//进度条按钮颜色
#define SliderButtonColorString @"#FBFBFB"

typedef void(^ButtonClickBlock)(UIButton *sender);
typedef void(^TapGestureBlock)(UITapGestureRecognizer *sender);
typedef void(^PanGestureBlock)(UIPanGestureRecognizer *sender);


#endif /* Defines_h */
