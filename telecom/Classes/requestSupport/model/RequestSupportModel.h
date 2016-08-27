//
//  RequestSupportModel.h
//  telecom
//
//  Created by SD0025A on 16/5/24.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "JSONModel.h"

@interface RequestSupportModel : JSONModel
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *oneType;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *taskId;
@property (nonatomic,copy) NSString *taskNo;
@end
/*
 {"name":"aaaaaaaaaa","oneType":"服务支撑","status":"执行中","taskId":"12","taskNo":"ZW_XCZC_160527_10_0011"}
 */