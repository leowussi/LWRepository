//
//  ZYFForm.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/17.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFForm.h"

@implementation ZYFForm

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.ColsKey forKey:@"ColsKey"];
    [encoder encodeObject:self.ColsGroup forKey:@"ColsGroup"];
    [encoder encodeObject:self.ColsType forKey:@"ColsType"];
    [encoder encodeObject:self.ColsName forKey:@"ColsName"];
    [encoder encodeObject:self.ColsEdit forKey:@"ColsEdit"];
 
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.ColsKey = [decoder decodeObjectForKey:@"ColsKey"];
        self.ColsGroup = [decoder decodeObjectForKey:@"ColsGroup"];
        self.ColsType = [decoder decodeObjectForKey:@"ColsType"];
        self.ColsName = [decoder decodeObjectForKey:@"ColsName"];
        self.ColsEdit = [decoder decodeObjectForKey:@"ColsEdit"];
    }
    return self;
}

//- (instancetype)init
//{
//    if (self = [super init]) {
//        self.relateEntity = [[ZYFRelateEntity alloc]init];
//    }
//    return self;
//}

//- (instancetype)initWithDict:(NSDictionary *)dict
//{
//    if (self = [super init]) {
//        self.ColsKey = dict[@"ColsKey"];
//        self.ColsGroup = dict[@"ColsGroup"];
//        self.ColsType = dict[@"ColsType"];
//        self.ColsName = dict[@"ColsName"];
//        self.ColsEdit = dict[@"ColsEdit"];
//    }
//    return self;
//}
//
//+ (instancetype)formWithDict:(NSDictionary *)dict
//{
//    return [[self alloc]initWithDict:dict];
//}

@end
