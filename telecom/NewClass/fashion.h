//
//  fashion.h
//  FashionChina
//
//  Created by chenliang on 14-1-8.
//  Copyright (c) 2014年 chenliang. All rights reserved.
//

#ifndef FashionChina_fashion_h
#define FashionChina_fashion_h


#define VersionNumber_iOS_7  [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define VersionNumber_iOS_6  [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0
#define kNavigationHeight   (VersionNumber_iOS_7 ? 70.0 : 50.0)
#define kIos6HeigtState     (VersionNumber_iOS_7 ? 0 : 20.0)
#define kBottomHeight 43.0
#define KStatusBarHeight 20.0


#define  kScreenSize   [[UIScreen mainScreen] bounds].size
#define  kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define  kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define  kScreenFrame  [UIScreen mainScreen].applicationFrame
#define  kContentHeight [[UIScreen mainScreen] bounds].size.height-44-20

#ifdef DEBUG
#define DLLog(...) NSLog(@"\n\t\t\t_________>（方法名)%s_________(行号)>%d____________(文件名)>%@____________(自定义参数)>%@ \n",__func__,__LINE__,[[NSString stringWithUTF8String:__FILE__] lastPathComponent],[NSString stringWithFormat:__VA_ARGS__])
#else
#define DLLog(format, ...)
#endif


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]



#endif
