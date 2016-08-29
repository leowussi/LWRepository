//
//  SignInStatus.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/9/2.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "SignInStatus.h"

@implementation SignInStatus

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        _signInTime = dict[@"signin"];
        _signOutTime = dict[@"signout"];
    }
    return self;
}

+ (instancetype)signInStatusWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

@end
