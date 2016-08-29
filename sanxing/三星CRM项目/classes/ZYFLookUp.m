//
//  ZYFLookUp.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/4.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFLookUp.h"

@implementation ZYFLookUp


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Id forKey:@"Id_logicName"];
    [encoder encodeObject:self.LogicalName forKey:@"LogicalName_LogicalName"];
    [encoder encodeObject:self.Name forKey:@"Name_LogicalName"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.Id = [decoder decodeObjectForKey:@"Id_logicName"];
        self.LogicalName = [decoder decodeObjectForKey:@"LogicalName_LogicalName"];
        self.Name = [decoder decodeObjectForKey:@"Name_LogicalName"];
    }
    return self;
}


-(instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        self.Id = dict[@"Id"];
        self.LogicalName = dict[@"LogicalName"];
        self.Name = dict[@"Name"];
        //进行异常判断
        if (self.Id == nil || [self.Id isEqual:[NSNull null]]) {
            self.Id = @"";
        }
        if (self.LogicalName == nil || [self.LogicalName isEqual:[NSNull null]]) {
            self.LogicalName = @"";
        }
        if (self.Name == nil || [self.Name isEqual:[NSNull null]]) {
            self.Name = @"";
        }
    }
    return self;
}

@end
