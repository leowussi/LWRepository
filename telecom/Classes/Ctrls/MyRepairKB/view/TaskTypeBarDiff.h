//
//  TaskTypeBarDiff.h
//  telecom
//
//  Created by ZhongYun on 14-6-14.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskTypeBarDiff;

@protocol TaskTypeBarDiffDelegate<NSObject>

@optional

- (void)changeBefore:(TaskTypeBarDiff*)sender;

- (void)changeAfter:(TaskTypeBarDiff*)sender;

- (void)zhhData:(NSInteger )zhhTag;

@end

@interface TaskTypeBarDiff : UIView

@property(nonatomic,assign)BOOL isWireless;

@property(nonatomic,retain)NSMutableArray* typeList;

@property(nonatomic,assign)NSInteger selected;

@property(nonatomic,assign)NSInteger buttonWidth;

@property (nonatomic, assign)id<TaskTypeBarDiffDelegate> delegate;

- (void)updatePointStatus:(NSInteger)index Count:(NSInteger)count;

- (id)initWithFrame:(CGRect)frame flag:(NSString *)flag;

@end
