//
//  XGW_comboboxButton.m
//  telecom
//
//  Created by SD0025A on 16/5/25.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "XGW_comboboxButton.h"

@implementation XGW_comboboxButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        self.layer.cornerRadius = 5;
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
        CFRelease(colorSpaceRef);
        [self.layer setBorderWidth:1];//设置边界的宽度
        
        [self.layer setBorderColor:color];//设置边界的颜色
        CFRelease(color);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-15, 0, 15, self.bounds.size.height)];
        imageView.image = [UIImage imageNamed:@"week_right.png"];
        [self addSubview:imageView];
        
    }
    return self;
}

@end
