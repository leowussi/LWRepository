//
//  BusinessResourceModel.h
//  telecom
//
//  Created by SD0025A on 16/7/7.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "JSONModel.h"

@interface BusinessResourceModel : JSONModel
@property (nonatomic,copy) NSString *deviceId;
@property (nonatomic,copy) NSString *deviceType;
@property (nonatomic,copy) NSString *deviceName;
@property (nonatomic,copy) NSString *region;
@property (nonatomic,copy) NSString *site;
@property (nonatomic,copy) NSString *room;
@property (nonatomic,copy) NSString *roomAddress;
@property (nonatomic,copy) NSString *lifeCycle;
@property (nonatomic,copy) NSString *range;
@property (nonatomic,copy) NSString *onuCode;
@property (nonatomic,copy) NSString *coverageFloor;


@property (nonatomic,copy) NSString *voicePortTotal;
@property (nonatomic,copy) NSString *voicePortTackup;
@property (nonatomic,copy) NSString *voicePortKeep;
@property (nonatomic,copy) NSString *adslPortTotal;
@property (nonatomic,copy) NSString *adslPortTackup;
@property (nonatomic,copy) NSString *adslPortKeep;



@property (nonatomic,copy) NSString *lanPortTotal;
@property (nonatomic,copy) NSString *lanPortTackup;
@property (nonatomic,copy) NSString *lanPortKeep;
@property (nonatomic,copy) NSString *lanPortAvailable;
@property (nonatomic,copy) NSString *adslPortAvailable;
@property (nonatomic,copy) NSString *voicePortAvailable;



@property (nonatomic,copy) NSString *obdSubType;
@property (nonatomic,copy) NSString *obdGrade;
@property (nonatomic,copy) NSString *obdManufactuer;
@property (nonatomic,copy) NSString *obdPortTotal;
@property (nonatomic,copy) NSString *obdPortTackup;
@property (nonatomic,copy) NSString *obdPortAvailable;
@property (nonatomic,copy) NSString *obdState;

@property (nonatomic,copy) NSString *oltUserfor;
@property (nonatomic,copy) NSString *obdPortKeep;
@property (nonatomic,copy) NSString *gTerminalsTotal;
@property (nonatomic,copy) NSString *gTerminalsAvailable;
@property (nonatomic,copy) NSString *gTerminalsTakeup;
@property (nonatomic,copy) NSString *gTerminalsKeep;

@property (nonatomic,copy) NSString *tjCirAvaliable;
@property (nonatomic,copy) NSString *zwswAvaliable;
@property (nonatomic,copy) NSString *fttoPortAvailable;
@end
/*
 

 
 

 "tjCirAvaliable":"通局光路可用数量",
 "zwswAvaliable":"专网上网可用端口",
 "fttoPortAvailable":"ftto可用端口"
 }
 */