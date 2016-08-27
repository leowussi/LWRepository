//
//  Resource.h
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resource : NSObject

@property (nonatomic, copy) NSString *boardMinorType;
@property (nonatomic, copy) NSString *boardType;
@property (nonatomic, copy) NSString *shelfId;
@property (nonatomic, copy) NSString *slotId;
@property (nonatomic, copy) NSString *slotNumber;
@property (nonatomic, copy) NSString *slotState;

+ (instancetype)friendWithDic:(NSDictionary *)dict;
- (instancetype)initWithDic:(NSDictionary *)dict;

@end
