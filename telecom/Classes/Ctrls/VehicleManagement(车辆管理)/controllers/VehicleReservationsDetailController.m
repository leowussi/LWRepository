//
//  VehicleReservationsDetailController.m
//  telecom
//
//  Created by SD0025A on 16/7/21.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//车辆预约详情

#import "VehicleReservationsDetailController.h"

@interface VehicleReservationsDetailController ()

@end

@implementation VehicleReservationsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}
- (void)createUI
{
    self.navigationItem.title = @"车辆预约详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

@end
