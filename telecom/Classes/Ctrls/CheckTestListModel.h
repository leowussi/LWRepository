//
//  CheckTestListModel.h
//  telecom
//
//  Created by SD0025A on 16/4/19.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JSONModel.h"

@interface CheckTestListModel : JSONModel
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *action;
@property (nonatomic,copy) NSString *actionTime;
@property (nonatomic,copy) NSString *dealDept;
@property (nonatomic,copy) NSString *dealRoom;
@property (nonatomic,copy) NSString *dealUser;
@property (nonatomic,copy) NSString *dealUserAccount;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *desc;

@end
/*
 num
 action
 actionTime
 dealDept
 dealRoom
 dealUser
 dealUserAccount
 source
 description
 */