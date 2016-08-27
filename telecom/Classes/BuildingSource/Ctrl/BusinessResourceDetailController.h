//
//  BusinessResourceDetailController.h
//  telecom
//
//  Created by SD0025A on 16/7/4.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "BaseViewController.h"

@interface BusinessResourceDetailController : BaseViewController

@property (nonatomic,copy) NSString *deviceId;
@property (nonatomic,copy) NSString *deviceType;

@property (nonatomic,assign) NSInteger viewTag;
@property (nonatomic,copy) NSString *currentAddress;
@end
