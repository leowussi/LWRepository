//
//  TaskWirelessDetail.h
//  telecom
//
//  Created by ZhongYun on 15-3-23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

#define STK_ID  @"subTaskId"
#define STK_NM  @"subTaskName"
#define STK_RM  @"remark"
#define STK_CT  @"workContent"

@interface TaskWirelessDetail : BaseViewController
@property(nonatomic,assign)int op;
@property(nonatomic,assign)BOOL isBack;
@property(nonatomic,retain)NSDictionary* task;
@property(nonatomic,retain)UIView* superList;
- (void)changeSubTask:(NSString*)sid Key:(NSString*)key Value:(NSString*)value;
@end
