//
//  ZYFLookUp.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/4.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 
 Id = "98572233-0b8b-e411-8008-1cc1de1df924";
 LogicalName = contact;
 Name = wrwe;
 */

@interface ZYFLookUp : NSObject <NSCoding>

@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *LogicalName;
@property (nonatomic,copy) NSString *Name;

-(instancetype)initWithDict:(NSDictionary*)dict;



@end
