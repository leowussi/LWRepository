//
//  SignInStatus.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/9/2.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInStatus : NSObject
//签到时间
@property (nonatomic,copy) NSString *signInTime;
//签退时间
@property (nonatomic,copy) NSString *signOutTime;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)signInStatusWithDict:(NSDictionary *)dict;

@end
