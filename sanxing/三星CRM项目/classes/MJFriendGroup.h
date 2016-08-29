//
//  MJFriendGroup.h
//  03-QQ好友列表
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJFriendGroup : NSObject
@property (nonatomic, copy) NSString *name;
/**
 *  数组中装的都是MJFriend模型
 */
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, assign) int online;

/**
 *  标识这组是否需要展开,  YES : 展开 ,  NO : 关闭
 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;

+ (instancetype)groupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
