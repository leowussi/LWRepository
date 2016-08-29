//
//  ZYFUrlTask.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/20.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  运维派工
 * 该url默认最后面的1表示，默认请求page等于1的页，如果下拉刷新时，应该讲page改为当前已经更新好的 最大的page数目 + 1
 */
//集抄
#define kMainTaskMuster @"http://100.100.100.68:61112/api/new_operation_fault_task/GetOperationFultTasksjc/"
//台区
#define kMainTaskCollect @"http://100.100.100.68:61112/api/new_operation_fault_task/GetOperationFultTaskstq/"
//公专变
#define kMainTaskElectricMeter @"http://100.100.100.68:61112/api/new_operation_fault_task/GetOperationFultTasksgz/"


//消缺记录明细

#define kCleanDefect @"http://100.100.100.68:61112/api/new_operation_fault_details"

//用户类型修改
#define kModeifyUserType @"http://100.100.100.68:61113/api/new_operation_fault_details/UpdateOperationFultDetail/"

//处理结果
#define kHandleResult @"http://100.100.100.68:61112/api/new_operation_fault_task/UpdateOperationFultTask/"

//问题大类
#define kProblemBig @"http://100.100.100.68:61112/api/problem_category/GetProblemCategories"

//问题小类
#define kProblemSmall @"http://100.100.100.68:61112/api/problem_category/GetProblemClasses"

//消缺明细设备位置更新
#define kPositionUpdate @"http://100.100.100.68:61112/api/new_operation_fault_details/UpdateOperationFultDetail/"
//台区任务接口
#define kTaiQuTask @"http://100.100.100.68:61112/api/new_operation_fault_task/GetOperationFultTaskDetails"

//上传照片
#define kUploadPhoto @"http://100.100.100.68:61112/upload.aspx"
//下载照片
#define kDownloadPhoto @"http://100.100.100.68:61112/api/new_operation_fault_task/GetOperationFultTaskImage"

//下载app页面
#define kDownloadIosApp @"http://sxcrm.auxgroup.com:6064/app.aspx"

//检查更新
#define kCheckForUpdate @"https://sxcrm.auxgroup.com:6064/inhousetest.plist"




@interface ZYFUrlTask : NSObject

@end
