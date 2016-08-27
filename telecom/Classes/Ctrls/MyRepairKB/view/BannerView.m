//
//  BannerView.m
//  telecom
//
//  Created by liuyong on 15/8/18.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BannerView.h"

@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame withImage:(NSString *)imageName title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *iconView = [[UIView alloc] initWithFrame:RECT(0, 0, 10, 25)];
        iconView.backgroundColor = RGBCOLOR(108, 193, 251);
        [self addSubview:iconView];
        
        UIView *titleView = [[UIView alloc] initWithFrame:RECT(iconView.ex+5, 0, self.fw-10-5, 25)];
        titleView.backgroundColor = RGBCOLOR(108, 193, 251);
        [self addSubview:titleView];
        
        if (imageName != nil) {
            UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:RECT(3, 0, 25, 25)];
            titleImageView.image = [UIImage imageNamed:imageName];
            [titleView addSubview:titleImageView];
            
            UILabel *titleLabel = [MyUtil createLabel:RECT(titleImageView.ex+2, 0, titleView.fw-3-2-titleImageView.fw-25-2, 25) text:title alignment:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
            titleLabel.tag = 12345;
            [titleView addSubview:titleLabel];
            
            UIImage *image = [UIImage imageNamed:@"arrow_right_white.png"];
            UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:RECT(titleLabel.ex+10, 5, image.size.width, image.size.height)];
            leftImageView.tag = 12346;
            leftImageView.image = image;
            [titleView addSubview:leftImageView];
        }else{
            
            UILabel *titleLabel = [MyUtil createLabel:RECT(5, 0, titleView.fw-5-25-2, 25) text:title alignment:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
            titleLabel.tag = 12345;
            [titleView addSubview:titleLabel];
            
            UIImage *image = [UIImage imageNamed:@"arrow_right_white.png"];
            UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:RECT(titleLabel.ex+10, 5,image.size.width, image.size.height)];
            leftImageView.tag = 12346;
            leftImageView.image = image;
            [titleView addSubview:leftImageView];
        }
    }
    return self;
}

@end
