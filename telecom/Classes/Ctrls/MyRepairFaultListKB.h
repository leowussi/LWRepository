//
//  MyRepairFaultListKB.h
//  telecom
//
//  Created by ZhongYun on 14-11-15.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@protocol MyRepairFaultListKBDelegate <NSObject>

//- (void)deliverMemorySelectItem:(NSString *)memorySelect;
- (void)deliverMemorySelectItem:(NSString *)memorySelect urlFlag:(NSString *)urlFlag;

@end

@interface MyRepairFaultListKB : BaseViewController
@property(nonatomic,assign)id <MyRepairFaultListKBDelegate> delegate;
@property (nonatomic,copy)NSString *urlType;
@property (nonatomic,copy)NSString *flagType;

@property (nonatomic,copy)NSString *memoryFlagType;
@property (nonatomic,copy)NSString *memoryUrlType;
@end
