//
//  TaskTypeBar.h
//  telecom
//
//  Created by ZhongYun on 14-6-14.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskTypeBar;

@protocol TaskTypeBarDelegate<NSObject>

@optional

- (void)changeBefore:(TaskTypeBar*)sender;

- (void)changeAfter:(TaskTypeBar*)sender;

- (void)zhhData:(NSInteger )zhhTag;

@end

@interface TaskTypeBar : UIView

@property(nonatomic,assign)BOOL isWireless;

@property(nonatomic,retain)NSMutableArray* typeList;

@property(nonatomic,assign)NSInteger selected;

@property(nonatomic,assign)NSInteger vcTag;

@property(nonatomic,assign)NSInteger buttonWidth;

@property (nonatomic, assign)id<TaskTypeBarDelegate> delegate;

- (void)updatePointStatus:(NSInteger)index Count:(NSInteger)count;

@end
