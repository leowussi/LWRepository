//
//  GjjxModel.h
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

@interface GjjxModel : NSObject
/**
 *  检索情况
 */
@property (nonatomic,copy)NSString *searchResult;
/**
 *  设备ID
 */
@property (nonatomic,copy)NSString *gId;
/**
 *  "设备名称"
 */
@property (nonatomic,copy)NSString *gName;
/**
 *  ": "区局名称",
 */
@property (nonatomic,copy)NSString *gRegion;
/**
 *  "站点名称",
 */
@property (nonatomic,copy)NSString *gSite;
/**
 *   "": "所在机房",

 */
@property (nonatomic,copy)NSString *gRoom;
/**
 *   "": "机房地址",

 */
@property (nonatomic,copy)NSString *gRoomAddress;
/**
 *   "": "端子总数",

 */
@property (nonatomic,copy)NSString *gTerminalsTotal;
/**
 *   "": "可用端子数",

 */
@property (nonatomic,copy)NSString *gTerminalsAvailable;
/**
 *   "": "占用端子数",

 */
@property (nonatomic,copy)NSString *gTerminalsTakeup;
/**
 *   "": "保留端子数",

 */
@property (nonatomic,copy)NSString *gTerminalsKeep;

/**
 *   "": "覆盖范围"
 */
@property (nonatomic,copy)NSString *gRange;

@property(nonatomic,strong)NSMutableArray *focList;


+ (instancetype)ModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
