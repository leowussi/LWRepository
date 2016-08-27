//
//  CommandTaskListModel.h
//  telecom
//
//  Created by SD0025A on 16/5/11.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "JSONModel.h"

@interface CommandTaskListModel : JSONModel
@property (nonatomic,copy) NSString *taskId;
@property (nonatomic,copy) NSString *taskNo;
@property (nonatomic,copy) NSString *taskContent;
@property (nonatomic,copy) NSString *taskBeginDate;
@property (nonatomic,copy) NSString *taskEndDate;
@property (nonatomic,copy) NSString *specName;
@property (nonatomic,copy) NSString *taskUrgent;
@property (nonatomic,copy) NSString *tsAcceptPeo;
@property (nonatomic,copy) NSString *upTaskId;
@end
/*
 "taskId": "工单id",
 "taskNo": "工单编号",
 "taskContent": "任务主题",
 "taskBeginDate": "任务开始时间",
 "taskEndDate": "任务结束时间",
 "specName": "专业",
 "taskUrgent": "紧急程度",
 "tsAcceptPeo": "接受人",
 "upTaskId": "父任务工单id",
 */