//
//  AutomobileRecorderController.h
//  telecom
//
//  Created by SD0025A on 16/7/20.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "BaseViewController.h"

@interface AutomobileRecorderController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)uploadAction:(UIButton *)sender;//上传

@property (weak, nonatomic) IBOutlet UIButton *beginUse;//开始使用
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beginUseConstant;//
@end
