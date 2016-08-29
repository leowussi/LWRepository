//
//  ZYFForm.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/17.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYFRelateEntity.h"

@interface ZYFForm : NSObject

@property (nonatomic,copy) NSString *ColsKey;
@property (nonatomic,copy) NSString *ColsGroup;
@property (nonatomic,copy) NSString *ColsType;
@property (nonatomic,copy) NSString *ColsName;
@property (nonatomic,copy) NSString *ColsEdit;

@property (nonatomic,strong) ZYFRelateEntity *relateEntity;

//- (instancetype)initWithDict:(NSDictionary *)dict;
//+ (instancetype)formWithDict:(NSDictionary *)dict;

@end
