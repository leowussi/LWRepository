//
//  FaultInfoModel.h
//  telecom
//
//  Created by liuyong on 15/10/27.
//  Copyright © 2015年 ZhongYun. All rights reserved.
/*
 "workNo": 故障单号，
 "businessNo": 业务号,
 "orderNo": 订单流水号,
 "region": 区域,
 "site": 站点信息,
 "acceptTime": 告警开始时间,
 "workType": 工种,
 "workStatus": 处理状态,
 "workContent": 故障信息,
 "room": 机房,
 "expectTime": 预计修复时间,
 "contactWay": 联系人,
 "faultTimeLimit": 工单时限,
 "dealTimeLimit": 挂起时长,
 "finishTimeLimit": 完成时长,
 "handupTime": 挂起时长,
 "faultLevel": 故障等级,
 "spec": 专业,
 "faultPartDesc1": 故障部位1,
 "faultPartDesc2": 故障部位2,
 "faultPartDesc3": 故障部位3,
 "faultPartDesc4": 故障部位4,
 "faultPartDesc5": 故障部位5,
 "faultPartDesc6": 故障部位6,
 "faultPartDesc7": 故障部位7,
 "faultPartDesc8": 故障部位8,
 
 */

#import <Foundation/Foundation.h>

@interface FaultInfoModel : NSObject
@property (nonatomic,copy)NSString *workNo;
@property (nonatomic,copy)NSString *businessNo;
@property (nonatomic,copy)NSString *orderNo;
@property (nonatomic,copy)NSString *region;
@property (nonatomic,copy)NSArray *site;
@property (nonatomic,copy)NSString *acceptTime;
@property (nonatomic,copy)NSArray *workType;
@property (nonatomic,copy)NSString *workStatus;
@property (nonatomic,copy)NSString *workContent;
@property (nonatomic,copy)NSString *room;
@property (nonatomic,copy)NSString *expectTime;
@property (nonatomic,copy)NSString *contactWay;
@property (nonatomic,copy)NSString *faultTimeLimit;
@property (nonatomic,copy)NSString *dealTimeLimit;
@property (nonatomic,copy)NSString *finishTimeLimit;
@property (nonatomic,copy)NSString *handupTime;
@property (nonatomic,copy)NSString *faultLevel;
@property (nonatomic,copy)NSString *spec;
@property (nonatomic,copy)NSString *sharedUser;
@property (nonatomic,copy)NSString *faultPartDesc1;
@property (nonatomic,copy)NSString *faultPartDesc2;
@property (nonatomic,copy)NSString *faultPartDesc3;
@property (nonatomic,copy)NSString *faultPartDesc4;
@property (nonatomic,copy)NSString *faultPartDesc5;
@property (nonatomic,copy)NSString *faultPartDesc6;
@property (nonatomic,copy)NSString *faultPartDesc7;
@property (nonatomic,copy)NSString *faultPartDesc8;

@property(nonatomic,strong)NSArray *transList;
@end

/*
 "transList": [{
 "action": 操作动作,
 "actionTime": 操作时间,
 "dealDept": 处理部门,
 "dealUser": 处理人员,
 "description": 描述
 }
 */
@interface TranslistInfoModel : NSObject
@property (nonatomic,copy)NSString *action;
@property (nonatomic,copy)NSString *actionTime;
@property (nonatomic,copy)NSString *dealDept;
@property (nonatomic,copy)NSString *dealUser;
@property (nonatomic,copy)NSString *Description;
@property (nonatomic,copy)NSString *faultId;
@end

