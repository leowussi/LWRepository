//
//  ResourceModel.h
//  telecom
//
//  Created by liuyong on 16/2/29.
//  Copyright © 2016年 ZhongYun. All rights reserved.
/*
 address = "\U6c5f\U6e7e\U5730\U94c1\U7ad9";
 gdjCount = 1;
 gfqxCount = 1;
 gjjxCount = 1;
 gpsX = "121.488058";
 gpsY = "31.307373";
 isHref = 0;
 obdCount = 1;
 oltCount = 1;
 onuCount = 1;
 pglCount = 1;
 totalCount = 7;*/

#import <Foundation/Foundation.h>

@interface ResourceModel : NSObject
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *road;
@property (nonatomic,copy)NSString *lane;
@property (nonatomic,copy)NSString *gate;
@property (nonatomic,copy)NSString *gdjCount;
@property (nonatomic,copy)NSString *gfqxCount;
@property (nonatomic,copy)NSString *gjjxCount;
@property (nonatomic,copy)NSString *gpsX;
@property (nonatomic,copy)NSString *gpsY;
@property (nonatomic,copy)NSString *isHref;
@property (nonatomic,copy)NSString *obdCount;
@property (nonatomic,copy)NSString *oltCount;
@property (nonatomic,copy)NSString *onuCount;
@property (nonatomic,copy)NSString *pglCount;
@property (nonatomic,copy)NSString *totalCount;

@end
