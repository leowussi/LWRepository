//
//  RequestSupportDetailModel.h
//  telecom
//
//  Created by SD0025A on 16/5/24.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "JSONModel.h"

@interface RequestSupportDetailModel : JSONModel
@property (nonatomic,copy) NSString *taskId;
@property (nonatomic,copy) NSString *taskNo;
@property (nonatomic,copy) NSString *sceneType;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *taskCreatePeo;
@property (nonatomic,copy) NSString *oneType;
@property (nonatomic,copy) NSString *twoType;
@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) NSString *taskBeginDate;
@property (nonatomic,copy) NSString *taskEndDate;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSArray *attachmentList;

@end
/*
 "taskId": "工单id",
 "taskNo": "工单编号",
 "sceneType": "适用场景类型",
 "name": "名称",
 "taskCreatePeo": "申请人",
 "oneType": "一级类别",
 "twoType": "二级类别",
 "account": "受派人（组）",
 "taskBeginDate": "任务开始时间",
 "taskEndDate": "任务结束时间",
 "remark": "任务描述",
 "status": "任务状态，0=待执行,1=执行中,2=已执行待点评",
 "attachmentList": ["附件id"]
 */