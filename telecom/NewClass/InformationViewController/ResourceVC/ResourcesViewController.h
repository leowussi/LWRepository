//
//  ResourcesViewController.h
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@interface ResourcesViewController : SXABaseViewController
@property (nonatomic,copy)NSString *searchCondition;

-(void)loadDataWithSearchCondition:(NSString *)searchCondition;
@end
