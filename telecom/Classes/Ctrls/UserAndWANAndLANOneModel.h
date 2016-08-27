//
//  UserAndWANAndLANOneModel.h
//  telecom
//
//  Created by SD0025A on 16/4/15.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JSONModel.h"

@interface UserAndWANAndLANOneModel : JSONModel
@property (nonatomic,copy) NSString *userRoute;
@property (nonatomic,copy) NSString *userRoom;
@property (nonatomic,copy) NSString *userEquip;
@property (nonatomic,copy) NSString *userPort;
@property (nonatomic,copy) NSString *userPortSpeed;
@property (nonatomic,copy) NSString *userType;
@property (nonatomic,copy) NSString *userLink;
@property (nonatomic,copy) NSString *userWlanId;
@property (nonatomic,copy) NSString *userIp;
@property (nonatomic,copy) NSString *userMask;

- (CGFloat)configCellHeight;


@end
/*
 userRoute
 userRoom
 userEquip
 userPort
 userPortSpeed
 userType
 userLink
 userWlanId
 userIp
 userMask
 */