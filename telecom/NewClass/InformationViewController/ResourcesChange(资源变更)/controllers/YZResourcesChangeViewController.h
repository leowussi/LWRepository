//
//  YZResourcesChangeViewController.h
//  ResouceChanged
//
//  Created by 锋 on 16/4/26.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//
#define TEXTCOLOR [UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1]

#import <UIKit/UIKit.h>

@interface YZResourcesChangeViewController : SXABaseViewController

//系统情况
@property (nonatomic, strong) NSArray *systemArray;

//保存用户填写的数据参数
@property (nonatomic, strong) NSMutableDictionary *dataDict;

//是否是更新变更工单
@property (nonatomic, assign) BOOL isUpdateResources;
//保存图片的URL
@property (nonatomic, strong) NSMutableArray *imageURLArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, assign) BOOL haveSystemInfo;

//系统情况的参数
@property (nonatomic, copy) NSString *resources_type;
@property (nonatomic, copy) NSString *resources_id;
@property (nonatomic, copy) NSString *resources_sceneId;
@end
