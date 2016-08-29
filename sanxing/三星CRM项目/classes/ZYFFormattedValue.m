//
//  ZYFFormattedValue.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFFormattedValue.h"

@implementation ZYFFormattedValue

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.myKey forKey:@"myKey_formated"];
    [encoder encodeObject:self.myValueString forKey:@"myValueString_formated"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.myKey = [decoder decodeObjectForKey:@"myKey_formated"];
        self.myValueString = [decoder decodeObjectForKey:@"myValueString_formated"];
    }
    return self;
}

-(instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        self.myKey = dict[@"Key"];
        self.myValueString = dict[@"Value"];
        if (self.myKey == nil || [self.myKey isEqual:[NSNull null]]) {
            self.myKey = @"";
        }
        if (self.myValueString == nil || [self.myValueString isEqual:[NSNull null]]) {
            self.myValueString = @"";
        }
    }
    return self;
}

+(instancetype)formattedWithDict:(NSDictionary*)dict
{
    return [[self alloc]initWithDict:dict];
}

@end
