//
//  TaskJiaohunList.h
//  telecom
//
//  Created by ZhongYun on 14-7-5.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface TaskJiaohunList : BaseViewController
@property(nonatomic, retain)NSMutableDictionary* detail;
@property(nonatomic, copy)NSString* planDate;
@property (nonatomic,copy)NSString *siteName;
@property(nonatomic,assign)BOOL isSecondaryTask;
@property(nonatomic, copy)void (^respBlock)(int undoCount);
@end
