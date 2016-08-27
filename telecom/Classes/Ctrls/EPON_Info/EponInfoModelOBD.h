//
//  EponInfoModelOBD.h
//  telecom
//
//  Created by liuyong on 15/10/21.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//
/*
 "searchResult": 检索情况（0：记录条数<=20   1：记录条数>20）超过20条前端需出提醒信息，
 "kind": 区分（OLT：1   OBD：2  ONU：3），
 "equipName": 设备名称（OLT/OBD/ONU）,
 "equipCode": 设备编码（OLT/OBD/ONU）,
 "room": 所属机房（OLT/OBD）,
 "rack": 所在机架（OLT）,
 "equipType": 设备类型（OLT/OBD/ONU）,
 "factory": 厂商（OLT/OBD）,
 "type": 型号（OLT）,
 "region": 所属区局（OBD）,
 "site": 所属站点（OBD）,
 "subType": 所属子类型（OBD）,
 "obdLevel": OBD等级（OBD）,
 "upPortNo": 上联设备端口号（OBD/ONU）,
 "equipSubType": 设备子类（ONU）,
 "cycle": 生命周期（ONU）,
 "address": 地址（ONU）,
 "inputTime": 入库时间（ONU）,
 "upEquipKind": 上联设备区分（OLT：1   OBD：2），
 "upEquipCode": 上联设备编码,
 "bottomList": [{
 "btmEquipCode": 下联设备编码,
 "btmEquipKind": 下联设备区分（OBD：2  ONU：3）
 }
 */
#import <Foundation/Foundation.h>
//设备名称、设备编码、所属区局、所属站点、所属机房、设备类型、所属子类型、OBD等级、厂商、上联设备端口号
@interface EponInfoModelOBD : NSObject
@property(nonatomic,strong)NSString *searchResult;
@property(nonatomic,strong)NSString *kind;
@property(nonatomic,strong)NSString *equipName;
@property(nonatomic,strong)NSString *equipCode;
@property(nonatomic,strong)NSString *region;
@property(nonatomic,strong)NSString *site;
@property(nonatomic,strong)NSString *room;
@property(nonatomic,strong)NSString *subType;
@property(nonatomic,strong)NSString *equipType;
@property(nonatomic,strong)NSString *obdLevel;
@property(nonatomic,strong)NSString *factory;
@property(nonatomic,strong)NSString *upPortNo;
@property (nonatomic,copy)NSString *cableName;

@property(nonatomic,strong)NSString *upEquipKind;
@property(nonatomic,strong)NSString *upEquipCode;
@property(nonatomic,strong)NSArray  *bottomList;
@end
