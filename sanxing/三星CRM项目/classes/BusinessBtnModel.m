//
//  BusinessBtnModel.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/30.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "BusinessBtnModel.h"

@implementation BusinessBtnModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.displayName forKey:@"displayName"];
    [encoder encodeObject:self.iconName forKey:@"iconName"];
    [encoder encodeObject:self.iconUrl forKey:@"iconUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.displayName = [decoder decodeObjectForKey:@"displayName"];
        self.iconName = [decoder decodeObjectForKey:@"iconName"];
        self.iconUrl = [decoder decodeObjectForKey:@"iconUrl"];
    }
    return self;
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.displayName = dict[@"DisplayName"];
        self.iconName = dict[@"IconName"];
        self.iconUrl = dict[@"IconUrl"];

    }
    return self;
}


+(instancetype)businessBtnModelWithDict:(NSDictionary*)dict
{
    return [[self alloc]initWithDict:dict];
}


@end
