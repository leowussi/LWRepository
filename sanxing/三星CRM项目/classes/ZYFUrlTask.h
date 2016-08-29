//
//  ZYFUrlTask.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/20.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRMHelper.h"


/**
 *  运维派工
 * 该url默认最后面的1表示，默认请求page等于1的页，如果下拉刷新时，应该讲page改为当前已经更新好的 最大的page数目 + 1
 */
//集抄
#define kMainTaskMuster kBaseUrl@"/api/new_operation_fault_task/GetOperationFultTasksjc/"
//[NSString stringWithFormat:@"%@%@",kBaseUrl,kPath];
//台区
#define kMainTaskCollect kBaseUrl@"/api/new_operation_fault_task/GetOperationFultTaskstq/"
//公专变
#define kMainTaskElectricMeter kBaseUrl@"/api/new_operation_fault_task/GetOperationFultTasksgz/"


//消缺记录明细

#define kCleanDefect kBaseUrl@"/api/new_operation_fault_details/GetOperationFultDetails"

//用户类型修改
#define kModeifyUserType @"http://100.100.100.68:61113/api/new_operation_fault_details/UpdateOperationFultDetail/"

//处理结果
#define kHandleResult kBaseUrl@"/api/new_operation_fault_task/UpdateOperationFultTask/"

//问题大类
#define kProblemBig kBaseUrl@"/api/problem_category/GetProblemCategories"

//问题小类
#define kProblemSmall kBaseUrl@"/api/problem_category/GetProblemClasses"

//消缺明细设备位置更新
#define kPositionUpdate kBaseUrl@"/api/new_operation_fault_details/UpdateOperationFultDetail/"
//台区任务接口
#define kTaiQuTask kBaseUrl@"/api/new_operation_fault_task/GetOperationFultTaskDetails"

//上传照片
#define kUploadPhoto kBaseUrl@"/upload.aspx"
//下载照片
#define kDownloadPhoto kBaseUrl@"/api/new_operation_fault_task/GetOperationFultTaskImage"
#define kDownloadPhoto22 kBaseUrl@"/upload.aspx"


//下载app页面
#define kDownloadIosApp @"https://sxcrm.auxgroup.com:6064/app/index.aspx"

//检查更新
#define kCheckForUpdate @"https://sxcrm.auxgroup.com:6064/app/ios/sxapp.plist"





@interface ZYFUrlTask : NSObject



@end
