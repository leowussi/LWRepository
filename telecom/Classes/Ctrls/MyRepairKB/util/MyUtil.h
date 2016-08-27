//
//  MyUtil.h
//  LimitFree
//
//  Created by gaokunpeng on 15/1/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyUtil : NSObject

//创建UILabel对象的便利方法
+ (UILabel *)createLabel:(CGRect)frame text:(NSString *)text alignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor numberOflines:(NSInteger)numberOfLines lineBreakMode:(NSLineBreakMode)linebreakMode font:(CGFloat)font;

//创建UILabel的另外一个方法
+ (UILabel *)createLabel:(CGRect)frame text:(NSString *)text alignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(CGFloat)font;

+ (UILabel *)createLabel:(CGRect)frame text:(NSString *)text alignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor;

//创建UIButton的方法
//frame:位置和大小
//bgImageName:背景图片
//imageName:图片
//title:文字
//target:响应事件的对象
//action:响应事件调用的方法
+ (UIButton *)createBtnFrame:(CGRect)frame bgImage:(NSString *)bgImageName image:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action;




@end
