//
//  ZYFFormattedValue.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYFFormattedValue : NSObject <NSCoding>

@property (nonatomic,copy) NSString *myKey;

@property (nonatomic,copy) NSString *myValueString;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)formattedWithDict:(NSDictionary*)dict;

@end
