//
//  MJFriendGroup.m
//  03-QQ好友列表
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJFriendGroup.h"
#import "MJFriend.h"

@implementation MJFriendGroup
+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.注入所有属性
        [self setValuesForKeysWithDictionary:dict];
        
        // 2.特殊处理friends属性
        NSMutableArray *friendArray = [NSMutableArray array];
        for (NSDictionary *dict in self.friends) {
            MJFriend *friend = [MJFriend friendWithDict:dict];
            [friendArray addObject:friend];
        }
        self.friends = friendArray;
    }
    return self;
}
@end