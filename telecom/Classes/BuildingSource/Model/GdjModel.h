//
//  GdjModel.h
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
 "": "设备类别",
 "": "设备类型",
 "": "端口总数",
 "": "可用端口数",
 "": "占用端口数",
 "": "保留端口数"

 */

#import <Foundation/Foundation.h>

@interface GdjModel : NSObject
@property (nonatomic,copy)NSString *searchResult;
@property (nonatomic,copy)NSString *otId;
@property (nonatomic,copy)NSString *otName;
@property (nonatomic,copy)NSString *otRegion;
@property (nonatomic,copy)NSString *otSite;
@property (nonatomic,copy)NSString *otRoom;
@property (nonatomic,copy)NSString *otRoomAddress;
@property (nonatomic,copy)NSString *otCategory;
@property (nonatomic,copy)NSString *otType;
@property (nonatomic,copy)NSString *otPortTotal;
@property (nonatomic,copy)NSString *otPortAvailable;
@property (nonatomic,copy)NSString *otPortTakeup;
@property (nonatomic,copy)NSString *otPortKeep;

@end
