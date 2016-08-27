//
//  Const.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#ifndef telecom_Const_h
#define telecom_Const_h

//响应
#define kRespondAction                 @"Fault/FaultFeedback"
//
#define kGetFaultShareInfo             @"KBFault/GetFaultShareInfo"
//
#define kGetSharedFaultList            @"KBFault/GetSharedFaultList"
//
#define kSaveCommentsContent           @"KBFault/SaveCommentsContent"
//上传文件
#define kUploadFile                    @"KBFault/UploadFile"
//下载文件
#define kDownloadFile                  @"KBFault/DownloadFile"
//获取文件列表
#define kGetFileList                   @"KBFault/GetFileList"
//删除附件
#define kDeleteFile                    @"KBFault/DelFile"
//获取共享人员
#define kGetShareableUser              @"KBFault/GetShareableUser"
//获取共享信息
#define kGetFaultShareInfo             @"KBFault/GetFaultShareInfo"
//设置共享人员
#define kSetShareableUser              @"KBFault/SetShareableUser"
//语音关键字
#define kGetKeyWords                   @"VoiceUtils/GetKeyWords"
//修复原因
#define kGetVoiceResultList            @"VoiceUtils/GetResultList"
//修复方式
#define kFixWayReasons                 @"Fault/FaultFixWayReasons"
//修复操作
#define kFaultFix                      @"Fault/FaultFix"
//挂起原因
#define kHangUpReason                  @"Fault/FaultHangUpReasons"
//挂起操作
#define kHangUpAction                  @"Fault/FaultHangUp"
//支撑申请
#define kApplyForSupportAction         @"Fault/ApplySupport"
//历史故障单列表
#define kGetHistoryFault               @"Fault/GetHistoryFault"
//故障轨迹数据
#define kGetFaultTrajectory            @"Fault/GetFaultTrajectory"//Fault/GetPeriodTrajectory
//考评对象取得
#define kGetCheckTarget                @"Fault/GetCheckTarget"
//逆向考评不满意原因
#define kGetDissatisfyReason           @"Fault/GetDissatisfyReason"
//考评结果提交
#define kSendCheckResult               @"Fault/SendCheckResult"
////故障流设备信息查询（关联资源）
#define kGetFaultDeviceList            @"Fault/GetFaultDeviceList"
//流水号对应告警查询（关联网管告警）
#define kGetFaultAlarmList             @"Fault/GetFaultAlarmList"
#endif
