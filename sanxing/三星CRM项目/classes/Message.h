//
//  Message.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/1.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

//主题
@property (nonatomic,copy) NSString *title;
//发送时间
@property (nonatomic,copy) NSString *time;
//内容
@property (nonatomic,copy) NSString *contentText;
//Entity
@property (nonatomic,copy) NSString *Entity;
//Id
@property (nonatomic,copy) NSString *Id;



- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end
