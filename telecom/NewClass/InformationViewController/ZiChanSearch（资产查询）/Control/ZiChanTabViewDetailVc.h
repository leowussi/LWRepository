//
//  ZiChanTabViewDetailVc.h
//  telecom
//
//  Created by Sundear on 16/4/13.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "SXABaseViewController.h"

#import "ZiChanModel.h"

@interface ZiChanTabViewDetailVc : SXABaseViewController

@property(nonatomic,strong)ZiChanModel *model;
@property(nonatomic,strong)NSString *assetDes;
@property(nonatomic,assign)BOOL mark;
@property (nonatomic, copy) NSString *type;

@end
