//
//  EponInfoModelONU.h
//  telecom
//
//  Created by liuyong on 15/10/21.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>
//设备名称、设备编码、设备类型、设备子类、生命周期、地址、入库时间、上联设备端口号
@interface EponInfoModelONU : NSObject
@property(nonatomic,strong)NSString *searchResult;
@property(nonatomic,strong)NSString *kind;
@property(nonatomic,strong)NSString *equipName;
@property(nonatomic,strong)NSString *equipCode;
@property(nonatomic,strong)NSString *equipType;
@property(nonatomic,strong)NSString *equipSubType;
@property(nonatomic,strong)NSString *cycle;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *inputTime;
@property(nonatomic,strong)NSString *upPortNo;
@property (nonatomic,copy)NSString *cableName;

@property(nonatomic,strong)NSString *upEquipKind;
@property(nonatomic,strong)NSString *upEquipCode;
@property(nonatomic,strong)NSArray  *bottomList;
@end

