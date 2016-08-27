//
//  AssiRoomList.h
//  telecom
//
//  Created by ZhongYun on 15-1-5.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface AssiRoomList : BaseViewController
@property (nonatomic,copy)NSString *originalVc;
@property (nonatomic,copy)NSString* regionId;
@property (nonatomic,retain)UIViewController* rootVC;
@property (nonatomic,copy)void(^respBlock)(id result);
@end
