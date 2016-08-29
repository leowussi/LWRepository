//
//  BusinessBtn.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/13.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "BusinessBtn.h"
#import "CRMHelper.h"

#define kButtonW self.bounds.size.width
#define kButtonH self.bounds.size.height


@implementation BusinessBtn

//-(instancetype)init
//{
//    if (self = [super init]) {
//        
//        // 图标居中
//        self.imageView.contentMode = UIViewContentModeCenter;
//        // 文字居中
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        // 字体大小
//        self.titleLabel.font = [UIFont systemFontOfSize:11];
//        
//    }
//    return self;
//}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 图标居中
//        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
//        [self.layer setMasksToBounds:YES];
//        self.layer.cornerRadius = 10.0;
        // 字体大小
        if (kSystemScreenWidth > 320) {
            //如果屏幕宽度大于320
            self.titleLabel.font = [UIFont systemFontOfSize:15];
        }else{
            //如果屏幕宽度小于320
            self.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
//        [self setBackgroundColor:[UIColor greenColor]];

    }
    return self;
}

//-(void)layoutSubviews
//{
//
//}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0 ;
    CGFloat titleY = kButtonH * 2.0 / 3.0;

    CGFloat titleW = kButtonW;
    CGFloat titleH = kButtonH / 3.0;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = kButtonW;
    CGFloat imageH = kButtonH * 2.0 / 3.0;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}


@end
