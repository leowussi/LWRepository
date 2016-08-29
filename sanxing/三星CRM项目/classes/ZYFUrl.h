//
//  ZYFUrl.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRMHelper.h"

//登录url
#define kLogin kBaseUrl@"/api/Home/login"
//#define kLogin kBaseUrl@"/app.aspx"


/**
 *  业务中的按钮url
 */
#define kGetButtonsUrl kBaseUrl@"/api/menu/getmy/1"


/**
 *  售后派工
 * 该url默认最后面的1表示，默认请求page等于1的页，如果下拉刷新时，应该讲page改为当前已经更新好的 最大的page数目 + 1
 */
#define kAfterSaleUrl kBaseUrl@"/api/new_customer_service_work_order/getmyorder/"

/**
 *  签到签退
 */
#define kSignInUrl kBaseUrl@"/api/new_app_sign/sign"


 //  获取当日签到签退状态
#define kSignInOutStatusUrl kBaseUrl@"/api/new_app_sign/GetSignStatus"


/**
 *  售后派工中，根据id获取对应id的工作日志
 */
#define kWorkLogs kBaseUrl@"/api/new_customer_service_work_order_report/GetworkReport/"

/**
 *  售后派工中，根据id获取对应id的延期申请
 */
#define kDelayApply kBaseUrl@"/api/new_customer_service_work_order_delay/GetworkDelay/"


/**
 *  售后派工中，根据id获取对应id的服务内容
 */
#define kServerContent kBaseUrl@"/api/new_customer_service_work_order_content/GetServiceContent/"

/**
 *  售后派工中，延期申请保存,put
 */
#define kDelayApplySave kBaseUrl@"/api/new_customer_service_delay_application/delay/"

/**
 *  售后派工中，创建新的工作日志,put
 */
#define kWorkLogCreate kBaseUrl@"/api/new_work_date_report/CreateWorkReport"

/**
 *  售后派工中，工作日志保存,put
 */
#define kWorkLogSave kBaseUrl@"/api/new_customer_service_work_order_report/CreateWorkReport"

/**
 *  售后派工中，派工状态修改后保存,put
 */
#define kWorkLogAssignStatusSave kBaseUrl@"/api/new_work_date_report/UpdateRepot/"


/**
 *  工作日志明细
 */
#define kWorkLogDetail kBaseUrl@"/api/new_work_date_report_details/GetReportDetails/"
/**
 *  工作日志明细，服务内容
 */
#define kServiceContent kBaseUrl@"/api/new_customer_service_work_order_content/GetServiceContent"
/**
 *  工作日志明细，服务内容保存
 */
#define kServiceContentSave kBaseUrl@"/api/new_work_date_report_details/UpdateRepotDetails/"

/**
 *  工作日志明细，产品型号
 */
#define kProdcutType kBaseUrl@"/api/test/getfetchxml?formxml=active_new_producttype"

/**
 *  工作日志明细创建
 */
#define kCreateLogDetail  kBaseUrl@"/api/new_work_date_report_details/AddReportDetails/"

/**
 *  费用登记查询
 */
#define kExpenseSubmit  kBaseUrl@"/api/new_sh_order_fee/GetOrder_Fees/"

/**
 *  费用登记,更改、保存
 */
#define kUpdateExpenseSubmit  kBaseUrl@"/api/new_sh_order_fee/UpdateOrder_Fee/"

/**
 *  派工费用类型查询
 */
#define kSerarchExpenseType  kBaseUrl@"/api/picklist/new_sh_order_fee/new_order_fee_type"

/**
 *  派工费用创建
 */
#define kExpenseCreate  kBaseUrl@"/api/new_sh_order_fee/AddOrder_Fee/"

/**
 *  上传照片
 */
#define kPostPhotoAfterSale  kBaseUrl@"/upload.aspx"
/**
 *  查看照片
 */
#define kDownLoadPhotoAfterSale  kBaseUrl@"/api/new_customer_service_work_order/GetServiceRequireImage"


/**
 *  远程推送,上传accessToken到服务器,put 
 *  参数
 *  deviceid:  devicetoken android
 *  type: ios  android
 *  version : 版本
 */
#define kAPNS  kBaseUrl@"/api/device/ActiveDevice/"

//通知消息推送和查询
#define kMessage kBaseUrl@"/api/new_app_mess/GetAppMesses"

//上传通知消息是否已经阅读的状态
#define kMessageStatus kBaseUrl@"/api/new_app_mess/UpdateAppMess"

////通知消息推送和查询
//#define kMessage @"100.100.100.68:61113/api/new_app_mess/GetAppMesses"
//
////上传通知消息是否已经阅读的状态
//#define kMessageStatus @"100.100.100.68:61113/api/new_app_mess/UpdateAppMess"



@interface ZYFUrl : NSObject
@end
