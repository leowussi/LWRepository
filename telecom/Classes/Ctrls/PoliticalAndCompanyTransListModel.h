//
//  PoliticalAndCompanyTransListModel.h
//  telecom
//
//  Created by SD0025A on 16/4/13.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoliticalAndCompanyTransListModel : NSObject
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *action;
@property (nonatomic,copy) NSString *actionTime;
@property (nonatomic,copy) NSString *delDept;
@property (nonatomic,copy) NSString *dealUserName;
@property (nonatomic,copy) NSString *agencyName;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *step;
@property (nonatomic,copy) NSString *actionDes;
- (CGFloat)configHeight;
@end

/*
 "num":0,
 "action":"添加",
 "actionTime":0,
 "delDept":"添加",
 "dealUserName":0,
 "dealUserAccount":"添加",
 "agencyName":0
 */
