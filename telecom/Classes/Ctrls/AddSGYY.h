//
//  AssiMainAddSGYY.h
//  telecom
//
//  Created by ZhongYun on 15-1-5.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface AddSGYY : BaseViewController
@property (nonatomic,copy)void(^respBlock)(id resp);
@property (nonatomic,copy)NSString *orderNo;
@property(nonatomic,strong)NSDictionary *workInfo;
@end
