//
//  AllTaskViewController.h
//  telecom
//
//  Created by 郝威斌 on 15/7/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@interface AllTaskViewController : SXABaseViewController

@property(assign,nonatomic)NSInteger vcTag;
@property(strong,nonatomic)NSString *strID;
@property(strong,nonatomic)NSString *strType;
@property(strong,nonatomic)NSArray *allArr;
@property(nonatomic,strong)NSDate* date;

@end
