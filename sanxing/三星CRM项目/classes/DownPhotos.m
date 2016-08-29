//
//  DownPhotos.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/2.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "DownPhotos.h"

@implementation DownPhotos

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.beforeArray = dict[@"list_before"];
        self.afterArray = dict[@"list_after"];
    }
    return self;
}

+ (instancetype)downPhotoWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

@end
