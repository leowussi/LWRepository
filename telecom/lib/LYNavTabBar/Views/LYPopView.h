//
//  LYPopView.h
//  LYNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 LYNavTabBarController. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYPopViewDelegate <NSObject>

@optional
- (void)viewHeight:(CGFloat)height;
- (void)itemPressedWithIndex:(NSInteger)index;

@end

@interface LYPopView : UIView

@property (nonatomic, weak)     id      <LYPopViewDelegate>delegate;
@property (nonatomic, strong)   NSArray *itemNames;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
