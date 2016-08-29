//
//  ZYFPickList.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/4.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYFPickList : NSObject <NSCoding>

@property (nonatomic,copy) NSString *value;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)pickListWithDict:(NSDictionary*)dict;

@end
