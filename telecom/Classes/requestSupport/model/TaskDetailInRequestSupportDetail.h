//
//  TaskDetailInRequestSupportDetail.h
//  telecom
//
//  Created by SD0025A on 16/6/16.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "JSONModel.h"

@interface TaskDetailInRequestSupportDetail : JSONModel
@property (nonatomic,copy) NSString *executivePerson;
@property (nonatomic,copy) NSString *executiveTime;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *remark;
@end
/*
 "executivePerson": "执行人",
 "executiveTime": "执行时间",
 "status": "执行状态",
 "remark": "执行描述"
 */