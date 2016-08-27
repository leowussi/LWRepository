//
//  ShaiXuanViewController.h
//  telecom
//
//  Created by Sundear on 16/2/24.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

typedef void(^shaixuanBlock)();
@interface ShaiXuanViewController : SXABaseViewController
@property(nonatomic,strong)NSMutableArray *arr;
@property(nonatomic,strong)shaixuanBlock ShaiXuan;
@end
