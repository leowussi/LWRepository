//
//  ZYFPickList.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/4.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFPickList.h"

@implementation ZYFPickList

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.value forKey:@"value_picklist"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.value = [decoder decodeObjectForKey:@"value_picklist"];
    }
    return self;
}

-(instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        NSString *NSNumberTypeToNSString = [NSString stringWithFormat:@"%@",dict[@"Value"]];
        self.value = NSNumberTypeToNSString;
        if (self.value == nil || [self.value isEqual:[NSNull null]]) {
            self.value = @"";
        }
    }
    return self;
}

+(instancetype)pickListWithDict:(NSDictionary*)dict
{
    return [[self alloc]initWithDict:dict];
}



@end
