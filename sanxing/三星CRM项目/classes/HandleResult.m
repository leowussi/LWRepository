//
//  HandleResult.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/25.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "HandleResult.h"

@implementation HandleResult
-(instancetype)init{
    if (self = [super init]) {
        self.keyArray =  @[@"10",@"20",@"30",@"40"];
        self.valueArray = @[@"重新排查",@"完成",@"局方处理",@"内场跟踪"];
    }
    return self;
}

+(instancetype)handleResult
{
    return [[self alloc]init];
}
@end
