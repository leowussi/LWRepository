//
//  SelfImgeView.m
//  telecom
//
//  Created by SD0025A on 16/4/21.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SelfImgeView.h"

@implementation SelfImgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleBtn.frame = CGRectMake(self.frame.size.width-20, 0, 20, 20);
        [deleBtn setImage:[UIImage imageNamed:@"deleteRed"] forState:UIControlStateNormal];
        [deleBtn addTarget:self action:@selector(deleteBtn:)forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleBtn];
    }
    return self;
}
- (void)deleteBtn:(UIButton *)deleBtn
{
    [self.delegate deleteBtnInImageView:self];
}
@end
