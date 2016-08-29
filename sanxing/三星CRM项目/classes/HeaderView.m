//
//  HeaderView.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/13.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

-(instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"Header" owner:nil options:nil]lastObject];
        self.userNumber.hidden = YES;
        self.userIcon.hidden = YES;
        [self setJobNum];
    }
    return self;
}

- (void)setJobNum
{

}


@end
