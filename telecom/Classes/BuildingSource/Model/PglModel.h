//
//  PglModel.h
//  telecom
//
//  Created by liuyong on 16/3/3.
//  Copyright © 2016年 ZhongYun. All rights reserved.
/*
 "": "检索情况（0：记录条数正常   1：记录条数>20、且按设备名称查询时）等于“1”时前端需出提醒信息",
 "": "光缆ID",
 "": "光缆名称",
 "": "光缆类型",
 "": "总纤芯数",
 "": "占用数",
 "": "损坏数",
 "": "可用数",
 "": "保留数",
 "": "覆盖范围"
 */
/**
 *  "focId": "光缆ID",
 "focName": "光缆名称",
 "focType": "光缆类型",
 "focFiberTotal": "总纤芯数",
 "focFiberTackup": "占用数",
 "focFiberDestroy": "损坏数",
 "focFiberAvailable": "可用数",
 "focFiberKeep": "保留数",
 "focRange": "覆盖范围"
 */
#import <Foundation/Foundation.h>

@interface PglModel : NSObject
//@property (nonatomic,copy)NSString *searchResult;
@property (nonatomic,copy)NSString *focId;
@property (nonatomic,copy)NSString *gId;
@property (nonatomic,copy)NSString *focName;
@property (nonatomic,copy)NSString *focType;
@property (nonatomic,copy)NSString *focFiberTotal;
@property (nonatomic,copy)NSString *focFiberTackup;
@property (nonatomic,copy)NSString *focFiberDestroy;
@property (nonatomic,copy)NSString *focFiberAvailable;
@property (nonatomic,copy)NSString *focFiberKeep;
@property (nonatomic,copy)NSString *focRange;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end
