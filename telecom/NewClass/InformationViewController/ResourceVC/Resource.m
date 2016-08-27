//
//  Resource.m
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "Resource.h"

@implementation Resource

+ (instancetype)friendWithDic:(NSDictionary *)dict
{
    return [[self alloc] initWithDic:dict];
}
- (instancetype)initWithDic:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
