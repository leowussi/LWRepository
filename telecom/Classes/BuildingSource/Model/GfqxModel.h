//
//  GfqxModel.h
//  telecom
//
//  Created by liuyong on 16/3/3.
//  Copyright © 2016年 ZhongYun. All rights reserved.
/*
 "": "检索情况（0：记录条数正常   1：记录条数>20、且按设备名称查询时）等于“1”时前端需出提醒信息",
 "": "设备ID",
 "": "设备名称",
 "": "区局名称",
 "": "站点名称",
 "": "所在机房",
 "": "机房地址",
 "": "端子总数",
 "": "可用端子数",
 "": "占用端子数",
 "": "保留端子数",
 "": "覆盖范围"
 */

#import <Foundation/Foundation.h>

@interface GfqxModel : NSObject
@property (nonatomic,copy)NSString *searchResult;
@property (nonatomic,copy)NSString *gId;
@property (nonatomic,copy)NSString *gName;
@property (nonatomic,copy)NSString *gRegion;
@property (nonatomic,copy)NSString *gSite;
@property (nonatomic,copy)NSString *gRoom;
@property (nonatomic,copy)NSString *gRoomAddress;
@property (nonatomic,copy)NSString *gTerminalsTotal;
@property (nonatomic,copy)NSString *gTerminalsAvailable;
@property (nonatomic,copy)NSString *gTerminalsTakeup;
@property (nonatomic,copy)NSString *gTerminalsKeep;
@property (nonatomic,copy)NSString *gRange;
@property(nonatomic,strong)NSArray *focList;
+ (instancetype)ModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
