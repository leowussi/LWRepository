//
//  UserAndWANAndLANTwoModel.h
//  telecom
//
//  Created by SD0025A on 16/4/15.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JSONModel.h"

@interface UserAndWANAndLANTwoModel : JSONModel
@property (nonatomic,copy) NSString *lanRoute;
@property (nonatomic,copy) NSString *lanRoom;
@property (nonatomic,copy) NSString *lanNu;
@property (nonatomic,copy) NSString *lanDisk;
@property (nonatomic,copy) NSString *lanPort;
@property (nonatomic,copy) NSString *lanControl;
@property (nonatomic,copy) NSString *lanTag;
@property (nonatomic,copy) NSString *lanType;
@property (nonatomic,copy) NSString *lanQos;
@property (nonatomic,copy) NSString *lanEletric;
@property (nonatomic,copy) NSString *lanVlanId;
@property (nonatomic,copy) NSString *lanLink;
@property (nonatomic,copy) NSString *lanUseful;
@property (nonatomic,copy) NSString *lanMaxLen;
@property (nonatomic,copy) NSString *lanPass;
- (CGFloat)configCellHeight;
@end
/*
 lanRoute
 lanRoom
 lanNu
 lanDisk
 lanPort
 lanControl
 lanTag
 lanType
 lanQos
 lanEletric
 lanVlanId
 lanLink
 lanUseful
 lanMaxLen
 lanPass
 */