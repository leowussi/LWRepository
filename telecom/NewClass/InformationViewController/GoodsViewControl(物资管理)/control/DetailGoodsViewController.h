//
//  DetailGoodsViewController.h
//  telecom
//
//  Created by Sundear on 16/4/5.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "SXABaseViewController.h"
#import "GoodsModel.h"
typedef void(^bolck)();
@interface DetailGoodsViewController : SXABaseViewController

@property(nonatomic,strong)GoodsModel *Model;
@property(nonatomic,copy)bolck bolck;

@end
