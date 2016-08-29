//
//  ZYFGroup.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/18.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFGroup.h"

@implementation ZYFGroup

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.ID forKey:@"ID"];
    [encoder encodeObject:self.cols forKey:@"cols"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.ID = [decoder decodeObjectForKey:@"ID"];
        self.cols = [decoder decodeObjectForKey:@"cols"];
    }
    return self;
}

@end
