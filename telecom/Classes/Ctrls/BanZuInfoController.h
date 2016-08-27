//
//  BanZuInfoController.h
//  telecom
//
//  Created by liuyong on 15/7/16.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@protocol BanZuInfoControllerDelegate <NSObject>

- (void)deliverBanZuInfo:(NSString *)banZuInfo;

@end

@interface BanZuInfoController : SXABaseViewController
@property (strong, nonatomic) IBOutlet UITableView *banZuInfoTableView;

@property(nonatomic,weak)id <BanZuInfoControllerDelegate> delegate;
@end
