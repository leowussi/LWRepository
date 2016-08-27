//
//  FaultTrackModel.h
//  telecom
//
//  Created by liuyong on 15/8/27.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaultTrackModel : NSObject
@property (nonatomic,copy)NSString *action;
@property (nonatomic,copy)NSString *dealUser;
@property (nonatomic,copy)NSString *gpsX;
@property (nonatomic,copy)NSString *gpsY;
@property (nonatomic,copy)NSString *startTime;
@property (nonatomic,copy)NSString *endTime;
@property (nonatomic,copy)NSString *userId;
@end
