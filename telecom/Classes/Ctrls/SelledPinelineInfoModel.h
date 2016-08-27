//
//  SelledPinelineInfoModel.h
//  telecom
//
//  Created by SD0025A on 16/5/20.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JSONModel.h"

@interface SelledPinelineInfoModel : JSONModel
@property (nonatomic,copy) NSString *action;
@property (nonatomic,copy) NSString *actionTime;
@property (nonatomic,copy) NSString *dealDept;
@property (nonatomic,copy) NSString *dealUser;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *desc;
@end
/*
 {"error":"操作成功","request":"/Trouble/SaleTroubleSerial.json","result":"0000000","urlTokenMap":{},"return_data":[{"num":"001","action":"处理中","actionTime":"2016-05-03 10:01:03","dealDept":"研发部","dealUser":"小明","dealUserAccount":"236587512","source":"页面","description":"快速测试","flag":"1"}],"return_code":"0"}
 */