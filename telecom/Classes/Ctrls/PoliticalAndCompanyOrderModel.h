//
//  PoliticalAndCompanyOrderModel.h
//  telecom
//
//  Created by SD0025A on 16/3/30.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JSONModel.h"

@interface PoliticalAndCompanyOrderModel : JSONModel
@property (nonatomic,copy) NSString *workNo;
@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,copy) NSString *groupNo;//集团流水号
@property (nonatomic,copy) NSString *linkName;//链路名称
@property (nonatomic,copy) NSString *cusName;
@property (nonatomic,copy) NSString *crmType;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *finishTime;
@property (nonatomic,strong) NSNumber *danger;
- (CGFloat)configHeight;
@end


/*
 "workNo":"xxx12345",
 "orderNo":"JC160287893",
 "groupNo":"",
 "linkName":"",
 "cusName":"中国人寿股份有限股份公司",
 "crmType":"CN2-MSTP",
 "status":"工单处理中",
 "finishTime":"2016-03-24 10:39",
 "RemanTime":10}
 */