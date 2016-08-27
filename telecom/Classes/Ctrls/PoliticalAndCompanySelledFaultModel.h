//
//  PoliticalAndCompanySelledFaultModel.h
//  telecom
//
//  Created by SD0025A on 16/4/19.
//  Copyright © 2016年 ZhongYun. All rights reserved.

//售后工单model

#import "JSONModel.h"

@interface PoliticalAndCompanySelledFaultModel : JSONModel
@property (nonatomic,copy) NSString *workNo;
@property (nonatomic,copy) NSString *acceptTime;
@property (nonatomic,copy) NSString *expectTime;
@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,copy) NSString *workStatus;
@property (nonatomic,copy) NSString *finishTimeLimit;
@property (nonatomic,copy) NSString *workType;
@property (nonatomic,copy) NSString *faultTimeLimit;
@property (nonatomic,copy) NSString *danger;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *groupNo;
@end
/*
 "workNo": "mxxzz",
 "acceptTime": "2016-03-02 20:08:11",
 "expectTime": "2016-04-03 20:08:11",
 "orderNo": "20150717038145",
 "workStatus": "处理中",
 "finishTimeLimit": "71小时31分",
 "workType": "MSCTP",
 "faultTimeLimit": "MSCTP"
 */