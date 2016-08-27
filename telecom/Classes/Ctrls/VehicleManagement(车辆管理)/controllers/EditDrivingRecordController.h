//
//  EditDrivingRecordController.h
//  telecom
//
//  Created by SD0025A on 16/7/22.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "BaseViewController.h"

@interface EditDrivingRecordController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)uploadAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beginUseConstant;

@end
