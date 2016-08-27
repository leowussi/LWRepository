//
//  OltModel.h
//  telecom
//
//  Created by liuyong on 16/3/3.
//  Copyright © 2016年 ZhongYun. All rights reserved.
/*
 "": "检索情况（0：记录条数正常   1：记录条数>20、且按设备名称查询时）等于“1”时前端需出提醒信息",
 "": "设备ID",
 "": "设备名称",
 "": "设备编码",
 "": "设备类型",
 "": "区局",
 "": "站点",
 "": "所在机房",
 "": "机房地址",
 "": "所在机架",
 "": "厂商",
 "": "型号",
 "": "用途",
 "": "端口总数",
 "": "可用端口数",
 "": "占用端口数",
 "": "保留端口数",
 "": "覆盖范围"
 */

#import <Foundation/Foundation.h>

@interface OltModel : NSObject
@property (nonatomic,copy)NSString *searchResult;
@property (nonatomic,copy)NSString *oltId;
@property (nonatomic,copy)NSString *oltName;
@property (nonatomic,copy)NSString *oltCode;
@property (nonatomic,copy)NSString *oltType;
@property (nonatomic,copy)NSString *oltRegion;
@property (nonatomic,copy)NSString *oltSite;
@property (nonatomic,copy)NSString *oltRoom;
@property (nonatomic,copy)NSString *oltRoomAddress;
@property (nonatomic,copy)NSString *oltRack;
@property (nonatomic,copy)NSString *oltManufacturer;
@property (nonatomic,copy)NSString *oltModel;
@property (nonatomic,copy)NSString *oltPurpose;
@property (nonatomic,copy)NSString *oltPortTotal;
@property (nonatomic,copy)NSString *oltPortAvailable;
@property (nonatomic,copy)NSString *oltPortTackup;
@property (nonatomic,copy)NSString *oltPortKeep;
@property (nonatomic,copy)NSString *oltRange;
@end
