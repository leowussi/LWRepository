//
//  CommandTaskDetailModel.h
//  telecom
//
//  Created by SD0025A on 16/5/16.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "JSONModel.h"

@interface CommandTaskDetailModel : JSONModel
@property (nonatomic,copy) NSString *taskNo;
@property (nonatomic,copy) NSString *sceneType;
@property (nonatomic,copy) NSString *taskContent;
@property (nonatomic,copy) NSString *taskCreateDate;
@property (nonatomic,copy) NSString *taskAppltReason;
@property (nonatomic,copy) NSString *taskCreateOrg;
@property (nonatomic,copy) NSString *taskCreatePeo;
@property (nonatomic,copy) NSString *applyPeoPh;
@property (nonatomic,copy) NSString *applyEmail;
@property (nonatomic,copy) NSString *taskUrgent;
@property (nonatomic,copy) NSString *taskType;
@property (nonatomic,copy) NSString *taskBeginDate;
@property (nonatomic,copy) NSString *taskEndDate;
@property (nonatomic,copy) NSString *costTime;
@property (nonatomic,copy) NSString *score;
@property (nonatomic,copy) NSString *specialSkill;
@property (nonatomic,copy) NSString *needPerNum;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSArray *attachmentList;


- (CGFloat)configHeight;
@end
/*
 "detail": [
 {
 "taskNo": "工单编号",
 "sceneType": "适用场景类型",
 "taskContent": "任务主题",
 "taskCreateDate": "制定时间",
 "taskAppltReason": "发起原因",
 "taskCreateOrg": "申请单位",
 "taskCreatePeo": "申请人",
 "applyPeoPh": "申请人联系电话",
 "applyEmail": "申请人邮箱",
 "taskUrgent": "缓急程度",
 "taskType": "任务类型",
 "taskBeginDate": "任务开始时间",
 "taskEndDate": "任务结束时间",
 "costTime": "经验耗时",
 "score": "积分",
 "specialSkill": "特殊技能资质要求",
 "needPerNum": "需要人数",
 "attachmentList": [{
 "id": "附件id"
 }]
 */