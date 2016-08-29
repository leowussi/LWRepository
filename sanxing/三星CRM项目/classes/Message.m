//
//  Message.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/1.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "Message.h"

@implementation Message

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.title = dict[@"Subject"];
        self.time = dict[@"Time"];
        self.contentText = dict[@"Content"];
        self.Entity = dict[@"Entity"];
        self.Id = dict[@"Id"];
    }
    return self;
}

+ (instancetype)messageWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

@end
