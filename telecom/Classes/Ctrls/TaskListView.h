//
//  TaskListView.h
//  telecom
//
//  Created by ZhongYun on 14-6-14.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskListViewDelegate <NSObject>

- (void)pushToTaskCallBackWithInfo:(NSDictionary *)dict;

@end

@interface TaskListView : UIView
@property(nonatomic,retain)NSDictionary* siteInfo;
@property(nonatomic,retain)NSDictionary* typeInfo;
@property(nonatomic, copy)NSString* planDate;
@property(nonatomic,readonly)NSInteger todoNum;
@property(nonatomic,assign)NSInteger vcTag;

@property(nonatomic,assign)id <TaskListViewDelegate> delegate;
- (void)commitCheck;
- (void)onCommitAfter:(NSArray*)commitList;
@end

@interface YZIndexPathButton : UIButton

@property (nonatomic, strong) NSIndexPath *ButtonIndexPath;

@end

