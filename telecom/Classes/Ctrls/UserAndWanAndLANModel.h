//
//  UserAndWanAndLANModel.h
//  telecom
//
//  Created by SD0025A on 16/4/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JSONModel.h"

@interface UserAndWanAndLANModel : JSONModel
@property (nonatomic,copy) NSString *wanRoute;
@property (nonatomic,copy) NSString *wanRoom;
@property (nonatomic,copy) NSString *wanNu;
@property (nonatomic,copy) NSString *wanDisk;
@property (nonatomic,copy) NSString *wanPort;
@property (nonatomic,copy) NSString *wanTag;
@property (nonatomic,copy) NSString *wanProtocol;
@property (nonatomic,copy) NSString *wanV5;
@property (nonatomic,copy) NSString *wanChkLen;
@property (nonatomic,copy) NSString *wanLcas;
@property (nonatomic,copy) NSString *wanVwanId;
@property (nonatomic,copy) NSString *wanPass;
- (CGFloat)configCellHeight;
@end
/*
 wanRoute
 wanRoom
 wanNu
 wanDisk
 wanPort
 wanTag
 wanProtocol
 wanV5
 wanChkLen
 wanLcas
 wanVlanid
 wanPass
 */