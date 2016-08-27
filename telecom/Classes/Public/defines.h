//
//  define.h
//  quanzhi
//
//  Created by ZhongYun on 14-1-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#ifndef quanzhi_define_h
#define quanzhi_define_h

/*****************************************************************************/
//Verions
/*****************************************************************************/
#if defined(V_TELECOM)
#define PLIST_URL       @"https://main.telecomsh.cn/ywglappUpdate/release/plist/telecom.plist"
#elif defined(V_ASSISTOR)
#define PLIST_URL       @"https://main.telecomsh.cn/ywglappUpdate/release/plist/telecomAssistor.plist"
#endif
#define VERS_FMT        @"itms-services://?action=download-manifest&url=%@"

#define BaiDu_MAP_KEY   @"ZTpiiN1b5TX3XdT9me6Tc9NB"

/*****************************************************************************/
//Application
/*****************************************************************************/



/*****************************************************************************/

#if ENV_TYPE ==1
#define ADDR_IP                 @"test.telecomsh.cn:9091"
#define ADDR_IP_WEB             @"test.telecomsh.cn:9091"
#elif ENV_TYPE ==4
#define ADDR_IP                 @"test0.telecomsh.cn:9091"
#define ADDR_IP_WEB             @"test.telecomsh.cn:9091"
#elif ENV_TYPE ==5
#define ADDR_IP                 @"test1.telecomsh.cn:9091"
#define ADDR_IP_WEB             @"test.telecomsh.cn:9091"
#elif ENV_TYPE ==6
#define ADDR_IP                 @"test2.telecomsh.cn:9091"
#define ADDR_IP_WEB             @"test.telecomsh.cn:9091"
#elif ENV_TYPE ==7
#define ADDR_IP                 @"test3.telecomsh.cn:9091"
#define ADDR_IP_WEB             @"test.telecomsh.cn:9091"
#elif ENV_TYPE ==2
#define ADDR_IP                 @"moni.telecomsh.cn"
#define ADDR_IP_WEB             @"moni.telecomsh.cn:9091"
#elif ENV_TYPE ==3
#define ADDR_IP                 @"main.telecomsh.cn"
#define ADDR_IP_WEB             @"main.telecomsh.cn"
#else

//#define ADDR_IP                   @"main.telecomsh.cn"
//#define ADDR_IP                 @"192.168.1.190:8180"
//#define ADDR_IP                 @"dev.telecomsh.cn:38452"
//#define ADDR_IP_WEB             @"test.telecomsh.cn:9091"
//王豪本机
//#define ADDR_IP                 @"192.168.1.198:8080"
//#define ADDR_IP                 @"test2.telecomsh.cn:9091"
#define ADDR_IP_WEB             @"test.telecomsh.cn:9091"
//鲁文
//#define ADDR_IP                   @"10.10.101.146:8080"
//#define ADDR_IP                 @"main.telecomsh.cn"
//王豪虚拟机
//#define ADDR_IP                   @"10.10.101.117:8080"

//#define ADDR_IP                   @"10.10.101.134:8080"
#define ADDR_IP                   @"10.10.101.113:9091"
//#define ADDR_IP                     @"test1.telecomsh.cn:9091"
//#define ADDR_IP                 @"test.telecomsh.cn:9091"
//胡从陈
//#define ADDR_IP                   @"10.10.101.130:8080"

//i楼宇环境
//#define ADDR_IP                 @"10.10.101.175:9091"
//钱超虚拟机
//#define ADDR_IP                 @"10.10.101.196:8080"
//王耀峰虚拟机
//#define ADDR_IP                 @"10.10.101.117:8080"
//徐创
//#define ADDR_IP                 @"10.10.100.72:8081"
//祝伟
//#define ADDR_IP                 @"10.10.100.105:8282"
//#define ADDR_IP                 @"test3.telecomsh.cn:9091"
#endif

/*****************************************************************************/


#define APP_COLOR               COLOR(24, 56, 111)

#define APP_SERVER              @"APP_SERVER"
#define U_ACCOUNT               @"U_ACCOUNT"
#define U_USID                  @"U_USID"
#define U_PSWD                  @"U_PSWD"
#define U_NAME                  @"U_NAME"
#define U_TOKEN                 @"U_TOKEN"
#define U_CONFIG                @"U_CONFIG"
#define U_BIND                  @"U_BIND"
#define U_POWER_TOKEN           @"U_POWER_TOKEN"
#define U_LOG                   @"U_LOG"
#define U_VERION                @"U_VERION"
#define U_CONNECTIONWAY         @"U_CONNECTIONWAY"
#define USERLOCATION_LATITUDE   @"USERLOCATION_LATITUDE"
#define USERLOCATION_LONGITUDE  @"USERLOCATION_LONGITUDE"
#define U_GPS_INTV              @"U_GPS_INTV"
#define U_SYSTEMVERSION         @"U_SYSTEMVERSION"
#define U_APPVERSION            @"U_APPVERSION"
#define U_DEVICEVERSION         @"U_DEVICEVERSION"


#define ASSI_CONSTRUCTION_ID    @"ASSI_CONSTRUCTION_ID"
#define ASSI_CONSTRUCTOR        @"ASSI_CONSTRUCTOR"
#define ASSI_MOBILE             @"ASSI_MOBILE"
#define ASSI_IMSI               @"ASSI_IMSI"


#define DEVICE_BIND_OK          @"DEVICE_BIND_OK"
#define DEVICE_TOKEN            @"DEVICE_TOKEN"
#define HIDE_LOADING            @"HIDE_LOADING"
#define SHOW_LOADING            @"SHOW_LOADING"

#define URL_TYPE                @"URL_TYPE"
#define FILE_PATH               @"FILE_PATH"

#define OP_VIEW       1
#define OP_EDIT       2


#define MAX_ROW_NUM             20

/*****************************************************************************/
//network SOAP API
/*****************************************************************************/
//#define ADDR_IP                 @"218.80.246.162:40000"
//#define ADDR_IP                 @"116.228.159.75:9091"
//#define ADDR_IP                 @"10.10.100.81:8080"
//#define ADDR_IP                 @"10.10.100.71:8090"
//#define ADDR_IP                 @"192.168.1.138:8080"
//#define ADDR_IP                 @"test.telecomsh.cn:9091"
//#define ADDR_IP                 @"116.228.159.75:9091"

//#define ADDR_IP                 @"dev.telecomsh.cn:38452"
//#define ADDR_IP                 @"test.telecomsh.cn:9091"


#define ADDR_DIR                @"ywglapp"
//祝伟
//#define ADDR_DIR                @"ywglapp_160809"


#define NW_loginapp             @"loginapp"
#define NW_logoutapp            @"logoutapp"
#define NW_GetConfig            @"GetConfig"
#define NW_BindUser             @"BdPush/BindUser"
#define NW_GetUserInfo          @"GetUserInfo"
#define NW_UploadErrorLog       @"System/UploadErrorLog"
#define NW_uploadGps            @"uploadGps"

#define NW_GetaccessToken               @"MyTask/GetaccessToken"
//#define NW_GetDongliConfig              @"MyTask/GetDongliConfig"

#define NW_GetFilterCondictions         @"MyTask/GetFilterCondictions"

//#define NW_GetSpecTaskAmount            @"MyTask/GetSpecTaskAmount"
//#define NW_GetSpecTaskList              @"MyTask/GetSpecTaskList"

//获取工作列表信息 1
#define NW_GetCycleWork                 @"MyTask/GetCycleWorkInfo"

//获取周期工作各专业数量 2
#define NW_GetSpecTaskAmount            @"MyTask/GetCycleWorkSpecAmount"

//获取周期工作各专业任务列表 3
#define NW_GetSpecTaskList              @"MyTask/GetCycleWorkSpecList"


//#define NW_GetSpecTaskAmount            @"MyTask/GetCycleWorkSpecAmount"
//#define NW_GetSpecTaskList              @"MyTask/GetCycleWorkSpecList"

#define NW_GetSpecSecondaryTaskList     @"MyTask/GetSpecSecondaryTaskList"
#define NW_SignInAtSite                 @"MyTask/SignInAtSite"
#define NW_BatchFinishTasks             @"MyTask/BatchFinishTasks"
#define NW_FinishTask                   @"MyTask/FinishTask"
//获取任务回填信息
#define NW_GetTaskInfo                  @"MyTask/GetTaskInfo"
//一级任务召回重做
#define NW_CallBackTaskLevelOne         @"MyTask/BackFirstTask"
//二级任务召回重做
#define NW_CallBackTaskLevelTwo         @"MyTask/BackSecondTask"
//故障单信息获取
#define NW_GetFaultInfo                 @"KBFault/GetFaultInfo"
//故障单附件上传
#define NW_CommonUpload                 @"KBFault/commonUpload"
//故障单生成
#define NW_GetFaultInsert               @"KBFault/GetFaultInsert"
//矫正资源附件上传
#define NW_RectifyResUploadFile         @"KBFault/commonUpload"
//矫正资源信息上传
#define NW_ExecuteCorrectInfo           @"MyTask/ExecuteCorrectInfo"
//添加隐患附件上传
#define NW_UploadFualtRiskFile          @"MyTask/uploadFualtRiskFile"
//添加隐患操作
#define NW_SubmitFualtRisk              @"MyTask/submitFualtRisk"
//上传GPS坐标
#define NW_uploadGps                     @"uploadGps"

#define NW_GetTaskListMonth             @"MyTask/GetTaskListMonth"
#define NW_GetTaskListByGroup           @"MyTask/GetTaskListByGroup"

#define NW_SignInAtSite                 @"MyTask/SignInAtSite"
#define NW_GetSignFailedReasons         @"MyTask/GetSignFailedReasons"
#define NW_UploadSignFailedFile         @"MyTask/UploadSignFailedFile"
#define NW_uploadFualtRiskFile          @"MyTask/uploadFualtRiskFile"
#define NW_submitSignFailedReason       @"MyTask/submitSignFailedReason"
#define NW_GetWXSecondaryTaskList       @"MyTask/GetWXSecondaryTaskList"
#define NW_submitFualtRisk              @"MyTask/submitFualtRisk"
#define NW_FinishWXTaskForTemp          @"MyTask/FinishWXTaskForTemp"
#define NW_FinishWXTask                 @"MyTask/FinishWXTask"
#define NW_GetSecondaryTaskFileList     @"MyTask/GetSecondaryTaskFileList"
#define NW_DelSecondaryTaskFile         @"MyTask/DelSecondaryTaskFile"
#define NW_UploadSecondaryTaskFile      @"MyTask/UploadSecondaryTaskFile"

#define NW_GetOrgList                   @"MyTask/WithWork/GetOrgList"
//MyTask/WithWork/GetRegionList
#define AssiGetRegionList               @"MyTask/WithWork/GetRegionList"
//MyTask/WithWork/GetRoomList
#define AssiGetRoomList                 @"MyTask/WithWork/GetAddressListForAdmin"

//MyTask/WithWork/TaskAppointmentListForAdmin
#define NW_TaskAppointmentListForAdmin  @"MyTask/WithWork/TaskAppointmentListForAdmin"
#define NW_OpenDoorListForAdmin         @"MyTask/WithWork/OpenDoorListForAdmin"
#define NW_OpenDoorInfo                 @"MyTask/WithWork/OpenDoorInfo"
#define NW_GetAppointmentReason         @"MyTask/WithWork/GetAppointmentReason"
#define NW_GetConstructorList           @"MyTask/WithWork/GetConstructorList"
#define NW_GetRoomList                  @"MyTask/WithWork/GetRoomList"
#define NW_GetSubRegionList             @"MyTask/WithWork/GetSubRegionList"

#define NW_AddTask                      @"MyTask/WithWork/AddTask"
#define NW_TaskInfo                     @"MyTask/WithWork/TaskInfo"
#define NW_TaskCommit                   @"MyTask/WithWork/TaskCommit"
#define NW_TaskCancel                   @"MyTask/WithWork/TaskCancel"
#define NW_TaskAppointmentCommit        @"MyTask/WithWork/TaskAppointmentCommit"


#define NW_GetOrgList                   @"MyTask/WithWork/GetOrgList"
#define NW_GetRegionList                @"MyTask/WithWork/GetRegionList"
#define NW_GetAddressList               @"MyTask/WithWork/GetAddressList"
#define NW_AddTaskAppointment           @"MyTask/WithWork/AddTaskAppointment"
#define NW_TaskAppointmentList          @"MyTask/WithWork/TaskAppointmentList"
#define NW_TaskAppointmentInfo          @"MyTask/WithWork/TaskAppointmentInfo"
#define NW_TaskAppointmentCommit        @"MyTask/WithWork/TaskAppointmentCommit"


#define NW_OpenDoorAdd                  @"MyTask/WithWork/OpenDoorAdd"
#define NW_OpenDoorModify               @"MyTask/WithWork/OpenDoorModify"
#define NW_OpenDoorDel                  @"MyTask/WithWork/OpenDoorDel"
#define NW_OpenDoorAccredit             @"MyTask/WithWork/OpenDoorAccredit"
#define NW_OpenDoorReject               @"MyTask/WithWork/OpenDoorReject"
#define NW_OpenDoorRegister             @"MyTask/WithWork/OpenDoorRegister"

#define NW_GetRepairFault               @"Fault/GetRepairFault"
//故障共享信息
#define AssiGetSharedFaultList          @"KBFault/GetSharedFaultList"
#define NW_FaultFeedback                @"Fault/FaultFeedback"

#define NW_GetRepairFaultList           @"Fault/GetRepairFaultList"
#define NW_GetRepairFaultTab            @"Fault/GetRepairFaultTab"
#define NW_GetRepairFaultDetail         @"Fault/GetRepairFaultDetail"
#define NW_GetRepairFaultTransInfo      @"Fault/GetRepairFaultTransInfo"
#define NW_GetFaultAlarmList            @"Fault/GetFaultAlarmList"
#define NW_GetFaultDeviceList           @"Fault/GetFaultDeviceList"

#define NW_ZbLogDict                    @"MyDuty/ZbLogDict"
#define NW_GetBatchTime                 @"MyDuty/GetBatchTime"
#define NW_ZbLogContent                 @"MyDuty/ZbLogContent"
#define NW_ZbLogAdd                     @"MyDuty/ZbLogAdd"
#define NW_ZbLogList                    @"MyDuty/ZbLogList"
#define NW_ZbLogInfo                    @"MyDuty/ZbLogInfo"
#define NW_ZbLogConfirm                 @"MyDuty/ZbLogConfirm"

#define NW_GetRoomListData              @"MyRoom/GetRoomListData"
#define NW_GetRegionDetailData          @"MyRoom/GetRegionDetailData"
#define NW_GetRoomDetailData            @"MyRoom/GetRoomDetailData"
#define NW_GetRoomPatternData           @"MyRoom/GetRoomPatternData.stream"

#define NW_GetDeviceAlarm               @"MyWebMaster/GetDeviceAlarm"


#define NW_getAppList                   @"appUpdate/GetAppList"
#define NW_getAppDetail                 @"appUpdate/GetAppDetail"

#define NW_RptGetSite                   @"StatisticsReport/GetSite"
#define NW_RptWorkTimePercent           @"StatisticsReport/WorkTimePercent"

#define NW_GetRouterData                 @"MyResource/GetARouteList"
#define NW_GetInfoDetailData             @"MyResource/GetARouteDetail"
#define NW_GetBBUFacilityDetailData      @"MyResource/GetBBUFacilityDetail"
#define NW_GetBBUFacilityData            @"MyResource/GetBBUFacilityList"
#define NW_GetRRUFacilityData            @"MyResource/GetRRUFacilityList"
#define NW_GetRRUFacilityDetailData      @"MyResource/GetRRUFacilityDetail"
#define NW_GetAerialListData             @"MyResource/GetAerialList"
#define NW_GetAerialListDetailData       @"MyResource/GetAerialDetail"
#define NW_GetFSystemListData            @"MyResource/GetSFSystemList"
#define NW_GetFSystemListDataDetail      @"MyResource/GetSFSystemDetail"
//  Assistor
#define NW_OpenDoorListForMember        @"MyTask/WithWork/OpenDoorListForMember"
#define NW_QueryState                   @"MyTask/WithWork/QueryState"
#define NW_OpenDoorLocation             @"MyTask/WithWork/OpenDoorLocation"
#define NW_OpenDoorIn                   @"MyTask/WithWork/OpenDoorIn"
#define NW_OpenDoorOut                  @"MyTask/WithWork/OpenDoorOut"
#define NW_OpenDoorApply                @"MyTask/WithWork/OpenDoorApply"

#define NW_GetSuporvisorList            @"MyTask/WithWork/GetSuporvisorList"
#define NW_bindDeviceToken              @"pushService/bindDeviceToken"
#define NW_unBindDeviceToken            @"pushService/unBindDeviceToken"



/*****************************************************************************/
//notification
/*****************************************************************************/
#define USER_LOGINED            @"USER_LOGINED"
#define USER_CONFIG             @"USER_CONFIG"
#define USER_LOGINOUT           @"USER_LOGINOUT"

#define DEVICE_TOKEN_RECIVED    @"DEVICE_TOKEN_RECIVED"
#define ASSI_REGIST_SUCCESS     @"ASSI_REGIST_SUCCESS"

#define GPS_LOCATION_START      @"GPS_LOCATION_START"
#define GPS_LOCATION_OVER       @"GPS_LOCATION_OVER"

#define LOG_FILTER_OVER         @"LOG_FILTER_OVER"
#define LOG_AUDIT_OVER          @"LOG_AUDIT_OVER"

#define RPT_SITE_DOWN           @"RPT_SITE_DOWN"

#define BOOKING_UPDATE_SGRW     @"BOOKING_UPDATE_SGRW"
#define BOOKING_UPDATE_SGYY     @"BOOKING_UPDATE_XCSG"

#define ASSI_ADD_SGYY           @"ASSI_ADD_SGYY"
#define ASSI_IMSI_UNKNOWN       @"ASSI_IMSI_UNKNOWN"

#define DEL_SELECTED_PHOTO      @"DEL_SELECTED_PHOTO"
#define SUB_TASK_COMMIT         @"SUB_TASK_COMMIT"

#define UP_TASK_LIST            @"UP_TASK_LIST"

/*****************************************************************************/
//EPON信息
/*****************************************************************************/
#define kSearchEponInfo         @"Fault/SearchEponInfo"


/*****************************************************************************/
//故障直查
/*****************************************************************************/
#define kSearchFaultOfLeader    @"Fault/SearchFaultOfLeader"

/*****************************************************************************/
//光连接设备信息
/*****************************************************************************/
#define kGetCableByName         @"myRegion/GetCableByName"
#define kGetCableById           @"myRegion/GetCableById"

/*****************************************************************************/
//推送消息点击进入客保故障单详情
/*****************************************************************************/
#define kSearchFaultLocal       @"Fault/SearchFaultLocal"

/*****************************************************************************/
//首页的视图接口
/*****************************************************************************/
#define kGetEnergyCount         @"myView/GetEnergyCount"//能耗划小
/*****************************************************************************/
//首页的视图接口
/*****************************************************************************/
#define kGetFaultLevel           @"Fault/GetFaultLevel"
/*****************************************************************************/
//首页的视图接口
/*****************************************************************************/
#define kGetTaskStatusOfLeader   @"myView/GetTaskStatusOfLeader"
#endif
