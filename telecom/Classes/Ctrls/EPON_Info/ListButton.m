//
//  ListButton.m
//  telecom
//
//  Created by liuyong on 15/10/19.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "ListButton.h"

@implementation ListButton



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.cornerRadius = 10.0f;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
        self.layer.masksToBounds = YES;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.contentMode = UIViewContentModeCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width*0.8, 0, contentRect.size.width*0.2, contentRect.size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width*0.8, contentRect.size.height);
}

@end
