//
//  MyUtil.m
//  LimitFree
//
//  Created by gaokunpeng on 15/1/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MyUtil.h"

@implementation MyUtil

+ (UILabel *)createLabel:(CGRect)frame text:(NSString *)text alignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor numberOflines:(NSInteger)numberOfLines lineBreakMode:(NSLineBreakMode)linebreakMode font:(CGFloat)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textAlignment = alignment;
    label.textColor = textColor;
    label.numberOfLines = numberOfLines;
    label.lineBreakMode = linebreakMode;
    label.font = [UIFont systemFontOfSize:font];
    return label;
    
    
}

//创建UILabel的另外一个方法
+ (UILabel *)createLabel:(CGRect)frame text:(NSString *)text alignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor font:(CGFloat)font
{
    return [self createLabel:frame text:text alignment:alignment textColor:textColor numberOflines:1 lineBreakMode:NSLineBreakByWordWrapping font:font];
}

+ (UILabel *)createLabel:(CGRect)frame text:(NSString *)text alignment:(NSTextAlignment)alignment textColor:(UIColor *)textColor
{
    return [self createLabel:frame text:text alignment:alignment textColor:textColor font:15.0f];
}


+ (UIButton *)createBtnFrame:(CGRect)frame bgImage:(NSString *)bgImageName image:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (bgImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return btn;
}

@end
