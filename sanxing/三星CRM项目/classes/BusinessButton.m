//
//  BusinessButton.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "BusinessButton.h"

@implementation BusinessButton

- (instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"BusinessButton" owner:nil options:nil]lastObject];
    }
    return self;
}

@end
