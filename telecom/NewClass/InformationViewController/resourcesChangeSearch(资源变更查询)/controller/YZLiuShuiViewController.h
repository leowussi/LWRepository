//
//  YZLiuShuiViewController.h
//  telecom
//
//  Created by 锋 on 16/5/10.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZLiuShuiViewController : SXABaseViewController


@property (nonatomic, copy) NSString *infoId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *liuShuiArray;
@property (nonatomic, strong) NSMutableArray *heightArray;
@end
