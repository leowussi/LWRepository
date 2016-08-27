//
//  PoliticalAndCompanyOrderBegin.m
//  telecom
//
//  Created by SD0025A on 16/8/9.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "PoliticalAndCompanyOrderBegin.h"
#import "PoliticalAndCompanyOrder.h"
@interface PoliticalAndCompanyOrderBegin ()

@end

@implementation PoliticalAndCompanyOrderBegin

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}


- (IBAction)sellingBtn:(UIButton *)sender {
    PoliticalAndCompanyOrder *ctrl = [[PoliticalAndCompanyOrder alloc] init];
    ctrl.urlType =@"Medium/sellingOrderList";
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)selledBtn:(UIButton *)sender {
    PoliticalAndCompanyOrder *ctrl = [[PoliticalAndCompanyOrder alloc] init];
    ctrl.urlType = @"Trouble/SaleTroubleList";
    [self.navigationController pushViewController:ctrl animated:YES];
}
@end
