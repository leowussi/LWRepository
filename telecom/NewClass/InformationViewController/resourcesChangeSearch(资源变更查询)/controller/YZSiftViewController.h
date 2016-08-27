//
//  YZSiftViewController.h
//  CheckResourcesChange
//
//  Created by 锋 on 16/4/29.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZSiftViewController : SXABaseViewController

//记录筛选的条件
@property (nonatomic, strong) NSMutableArray *siftArray;
//记录筛选的条件索引
@property (nonatomic, strong) NSMutableDictionary *recordSelectedDict;
//提交筛选后的block回调
@property (nonatomic, copy) void(^completionBlock)(void);

@end
