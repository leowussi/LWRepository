//
//  ExpenseType.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/16.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ExpenseType.h"

@implementation ExpenseType

-(instancetype)init{
    if (self = [super init]) {
        self.keyArray =  @[@"10",@"20",@"30",@"40",@"50",@"60",@"70"];
        self.valueArray = @[@"差旅费",@"邮费(快递费)",@"运杂费(运输费用)",@"市内交通费",@"业务招待费",@"会务费",@"招待费"];
    }
    return self;
}

+(instancetype)expenseType
{
    return [[self alloc]init];
}

@end
