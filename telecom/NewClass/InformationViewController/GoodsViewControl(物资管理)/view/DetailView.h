//
//  DetailView.h
//  telecom
//
//  Created by Sundear on 16/4/15.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

typedef void(^bolck)();
@interface DetailView : UIView
@property(nonatomic,strong)GoodsModel *Model;
@property(nonatomic,copy)bolck bolckk;
@end
