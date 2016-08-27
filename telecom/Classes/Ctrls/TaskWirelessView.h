//
//  TaskWirelessView.h
//  telecom
//
//  Created by ZhongYun on 15-3-23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskWirelessView : UIView
@property(nonatomic,retain)NSDictionary* typeInfo;
@property(nonatomic,retain)NSDictionary* task;
@property(nonatomic,retain)NSDictionary* group;
@property(nonatomic,retain)NSMutableArray* commitArray;
@end
