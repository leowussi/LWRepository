//
//  TroubleBtn.m
//  telecom
//
//  Created by Sundear on 16/2/18.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "TroubleBtn.h"

@implementation TroubleBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
        
        [self.layer setBorderWidth:1];//设置边界的宽度
        
        [self.layer setBorderColor:color];//设置边界的颜色
        CFRelease(colorSpaceRef);
        CFRelease(color);
    }
    return self;
}
@end
