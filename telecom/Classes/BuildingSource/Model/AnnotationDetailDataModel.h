//
//  AnnotationDetailDataModel.h
//  telecom
//
//  Created by SD0025A on 16/6/23.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "JSONModel.h"
//#import "FloorListDataModel.h"

@protocol  FloorListDataModel
@end
@interface AnnotationDetailDataModel : JSONModel
@property (nonatomic,copy) NSString *gdjCount;
@property (nonatomic,copy) NSString *gfqxCount;
@property (nonatomic,copy) NSString *gjjxCount;
@property (nonatomic,copy) NSString *obdCount;
@property (nonatomic,copy) NSString *oltCount;
@property (nonatomic,copy) NSString *onuCount;
@property (nonatomic,copy) NSString *avail;
@property (nonatomic,copy) NSString *total;
@property (nonatomic,copy) NSArray<FloorListDataModel> *floorList;

@end
/*
 "detail": {
 "gdjCount": "光端机数量",
 "gfqxCount": "光分纤箱数量",
 "gjjxCount": "光交接箱数量",
 "obdCount": "OBD数量",
 "oltCount": "OLT数量",
 "onuCount": "ONU数量",
 "avail": "可用数",
 "total": "总数",
 "floorList":[
 {
 "coverageFloor":"楼层",
 "deviceOnu":"onu 设备id---五类线宽带/ADSL宽带/普通电话的设备ID",
 "deviceOnuType":"onu 设备类型---五类线宽带/ADSL宽带/普通电话的设备类型",
 "deviceFtth":"c类obd 设备id---光纤宽带/光电话的设备ID",
 "deviceFtthType":"c类obd 类型---光纤宽带/光电话的设备类型",
 "devicedFtto":"专网设备id",
 "devicedFttoType":"专网设备类型",
 "deviceCir":"通局光路光分id---IPMAN/30B+D/DID/SDH/MSTP的设备ID",
 "deviceCirType":"通局光路设备类型----IPMAN/30B+D/DID/SDH/MSTP的设备类型",
 "ponLan":"五类线宽带可用端口数",
 "ponAdsl":"ADSL宽带可用端口数",
 "voice":"普通电话可用端口数",
 "ftth":"OBD中“光纤宽带可用端口数“或光分纤箱中“FTTO可用端口数----光纤宽带/光电话由该值判断业务是否开通",
 "ftto":"“专网上网可用端口数“----专网上网由该值判断业务是否开通",
 "gfCir":"通局光路可用数量---IPMAN/30B+D/DID/SDH/MSTP均由该值判断业务是否开通"
 
 }
 ]
 */