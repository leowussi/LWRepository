//
//  ZYFDisplayCols.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/3.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFDisplayCols.h"

@implementation ZYFDisplayCols

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.keyArray forKey:@"keyArray"];
    [encoder encodeObject:self.valueArray forKey:@"valueArray"];
    [encoder encodeObject:self.nameArray forKey:@"nameArray"];
    [encoder encodeObject:self.editableArray forKey:@"editableArray"];
    [encoder encodeInteger:self.page forKey:@"page"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.keyArray = [decoder decodeObjectForKey:@"keyArray"];
        self.valueArray = [decoder decodeObjectForKey:@"valueArray"];
        self.nameArray = [decoder decodeObjectForKey:@"nameArray"];
        self.editableArray = [decoder decodeObjectForKey:@"editableArray"];
        self.page = [decoder decodeIntegerForKey:@"page"];
    }
    return self;
}

-(instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        self.keyArray = dict[@"Cols"];
        self.valueArray = dict[@"ColsType"];
        self.nameArray = dict[@"ColsName"];
        self.editableArray = dict[@"ColsEdit"];
        NSNumber *page = dict[@"Page"];
        self.page = page.integerValue;
    }
    return self;
}
+(instancetype)displayColWithDict:(NSDictionary*)dict
{
    return [[self alloc]initWithDict:dict];
}


@end
