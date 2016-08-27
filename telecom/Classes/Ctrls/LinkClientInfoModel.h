//
//  LinkClientInfoModel.h
//  telecom
//
//  Created by SD0025A on 16/3/31.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkClientInfoModel : NSObject
@property (nonatomic,copy) NSString *linkNo;
@property (nonatomic,copy) NSString *cusName;
@property (nonatomic,copy) NSString *cusAddress;
@property (nonatomic,copy) NSString *contract;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *startInfo;
@property (nonatomic,copy) NSString *startCompany;
@property (nonatomic,copy) NSString *startAddress;
@property (nonatomic,copy) NSString *startContract;
@property (nonatomic,copy) NSString *startTel;
@property (nonatomic,copy) NSString *endInfo;
@property (nonatomic,copy) NSString *endCompany;
@property (nonatomic,copy) NSString *endAddress;
@property (nonatomic,copy) NSString *endContract;
@property (nonatomic,copy) NSString *endTel;
- (CGFloat)configHeight;
@end
/*
 linkNo
 cusName
 cusAddress
 contract
 tel
 startInfo
 startCompany
 startAddress
 startContract
 startTel
 endInfo
 endCompany
 endAddress
 endContract
 endTel
*/