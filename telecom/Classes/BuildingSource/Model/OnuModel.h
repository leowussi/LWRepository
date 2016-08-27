//
//  OnuModel.h
//  telecom
//
//  Created by liuyong on 16/3/3.
//  Copyright © 2016年 ZhongYun. All rights reserved.
/*

 "": "生命周期",
 "": "语音总端口",
 "": "语音占用端口",
 "": "语音可用端口",
 "": "语音保留端口",
 "": "ADSL总端口",
 "": "ADSL占用端口",
 "": "ADSL可用端口",
 "": "ADSL保留端口",
 "": "LAN总端口",
 "": "LAN占用端口",
 "": "LAN可用端口",
 "": "LAN保留端口",
 "": "覆盖范围
 */

#import <Foundation/Foundation.h>

@interface OnuModel : NSObject
@property (nonatomic,copy)NSString *searchResult;
@property (nonatomic,copy)NSString *onuId;
@property (nonatomic,copy)NSString *onuName;
@property (nonatomic,copy)NSString *onuCode;
@property (nonatomic,copy)NSString *onuType;
@property (nonatomic,copy)NSString *onuRegion;
@property (nonatomic,copy)NSString *onuSite;
@property (nonatomic,copy)NSString *onuRoom;
@property (nonatomic,copy)NSString *onuRoomAddress;

@property (nonatomic,copy)NSString *onuLifecycle;

@property (nonatomic,copy)NSString *onuVoicePortTotal;
@property (nonatomic,copy)NSString *onuVoicePortTackup;
@property (nonatomic,copy)NSString *onuVoicePortAvailable;
@property (nonatomic,copy)NSString *onuVoicePortKeep;

@property (nonatomic,copy)NSString *onuAdslPortTotal;
@property (nonatomic,copy)NSString *onuAdslPortTackup;
@property (nonatomic,copy)NSString *onuAsdlPortAvailable;
@property (nonatomic,copy)NSString *onuAdslPortKeep;

@property (nonatomic,copy)NSString *onuLanPortTotal;
@property (nonatomic,copy)NSString *onuLanPortTackup;
@property (nonatomic,copy)NSString *onuLanPortAvailable;
@property (nonatomic,copy)NSString *onuLanPortKeep;

@property (nonatomic,copy)NSString *onuRange;
@end
