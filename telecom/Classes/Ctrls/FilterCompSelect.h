//
//  FilterCompSelect.h
//  telecom
//
//  Created by ZhongYun on 14-6-13.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface FilterCompSelect : BaseViewController
@property (nonatomic,retain)NSArray* data;
@property (nonatomic,assign)NSInteger selected;

@property (nonatomic,copy)NSString* idKey;
@property (nonatomic,copy)NSString* nameKey;

@property (nonatomic,assign)BOOL multiModule;
@property (nonatomic,retain)NSMutableArray* multiSelected;

@property (nonatomic,copy)void(^respBlock)(NSInteger selected);
@property (nonatomic,copy)void(^respMultiBlock)(id selected);
@end
