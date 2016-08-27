//
//  SelledFaultListDetailModel.h
//  telecom
//
//  Created by SD0025A on 16/4/19.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JSONModel.h"

@interface SelledFaultListDetailModel : JSONModel
@property (nonatomic,copy) NSString *workNo;
@property (nonatomic,copy) NSString *businessNo;
@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,copy) NSString *region;
@property (nonatomic,copy) NSString *site;
@property (nonatomic,copy) NSString *acceptTime;
@property (nonatomic,copy) NSString *WORKTYPE;
@property (nonatomic,copy) NSString *workStatus;
@property (nonatomic,copy) NSString *workContent;
@property (nonatomic,copy) NSString *room;
@property (nonatomic,copy) NSString *expectTime;
@property (nonatomic,copy) NSString *contactWay;
@property (nonatomic,copy) NSString *faultLevel;
@property (nonatomic,copy) NSString *faultTimeLimit;
@property (nonatomic,copy) NSString *dealTimeLimit;
@property (nonatomic,copy) NSString *handupTime;
@property (nonatomic,copy) NSString *finishTimeLimit;
@property (nonatomic,copy) NSString *speciality;
@property (nonatomic,copy) NSString *workType1;
@property (nonatomic,copy) NSString *faultPart1;
@property (nonatomic,copy) NSString *faultPart2;
@property (nonatomic,copy) NSString *faultPart3;
@property (nonatomic,copy) NSString *faultPart4;
@property (nonatomic,copy) NSString *faultPart5;
@property (nonatomic,copy) NSString *faultPart6;
@property (nonatomic,copy) NSString *faultPart7;
@property (nonatomic,copy) NSString *faultPart8;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *groupNo;

- (CGFloat)configSiteHeight;
@end
/*
 businessNo
 orderNo
 region
 site
 acceptTime
 workType
 workStatus
 workContent
 room
 expectTime
 contactWay
 faultLevel
 faultTimeLimit
 dealTimeLimit
 handupTime
 finishTimeLimit
 speciality
 workType
 faultPart1
 faultPart2
 faultPart3
 faultPart4
 faultPart5
 faultPart6
 faultPart7
 faultPart8
 */