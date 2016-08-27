//
//  AnnotationDataModel.h
//  telecom
//
//  Created by SD0025A on 16/6/23.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "JSONModel.h"

@interface AnnotationDataModel : JSONModel
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *gpsX;
@property (nonatomic,copy) NSString *gpsY;
@property (nonatomic,copy) NSString *buildingId;
@property (nonatomic,copy) NSString *buildingNo;
@property (nonatomic,copy) NSString *isUrgency;
@property (nonatomic,copy) NSString *road;
@property (nonatomic,copy) NSString *lane;
@property (nonatomic,copy) NSString *gate;
@end
/*
 "list": [
 {
 "address": "地址点（XX路XX号）",
 "gpsX": "坐标点X",
 "gpsY": "坐标点Y",
 "buildingId": "楼宇ID",
 "buildingNo": "楼号",
 "isUrgency": "是否紧张----0：充足，1：紧张"
 }
 "........... "
 ]
 */