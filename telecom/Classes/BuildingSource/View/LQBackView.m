//
//  LQBackView.m
//  telecom
//
//  Created by Sundear on 16/3/23.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "LQBackView.h"

@implementation YZIndexButton

@end

@implementation LQBackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.backgroundColor = RGBCOLOR(237, 237, 237);

    }
    return self;
}
@end
