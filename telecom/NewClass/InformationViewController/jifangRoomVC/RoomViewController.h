//
//  RoomViewController.h
//  telecom
//
//  Created by 郝威斌 on 15/7/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@interface RoomViewController : SXABaseViewController

@property(assign,nonatomic)NSInteger vcTag;
@property(strong,nonatomic)NSString *strID;
@property(strong,nonatomic)NSArray *roomArr;

@end
