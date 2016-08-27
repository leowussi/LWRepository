//
//  YZPersonnelWhereaboutsViewController.h
//  telecom
//
//  Created by 锋 on 16/6/17.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface YZPersonnelWhereaboutsViewController : UIViewController

@end

@interface YZPersonLocationPointAnnotation : BMKPointAnnotation

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *status;

@end
