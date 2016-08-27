//
//  TransmisionViewController.m
//  telecom
//
//  Created by liuyong on 15/8/3.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "TransmisionViewController.h"

@interface TransmisionViewController ()

@end

@implementation TransmisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转报";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView.hidden = YES;
    
    [self setUpRightNavButton];
    
    self.bottomScrollView.backgroundColor = RGBCOLOR(249, 249, 249);
    self.orderNoLabel.text = self.orderNo;
    self.handlePersonLabel.text = UGET(U_ACCOUNT);
    self.handelDeptLabel.layer.borderWidth = 0.5;
    self.handelDeptLabel.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    self.handelDeptLabel.text = @" 选择部门";
    [self.handelDeptLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseDept)]];
    
    [self.checkBtn setBackgroundColor:RGBCOLOR(55, 166, 250)];
    [self.checkBtn setTitle:@"验证" forState:UIControlStateNormal];
    
    self.workStationLabel.layer.borderWidth = 0.5;
    self.workStationLabel.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    self.workStationLabel.text = @" 请选择转报目的工位";
    [self.workStationLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseWorkStation)]];
    
    self.transferReasonTextView.layer.borderWidth = 0.5;
    self.transferReasonTextView.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    self.transferReasonTextView.text = @"请选择原因";
    
    self.transferDescTextView.layer.borderWidth = 0.5;
    self.transferDescTextView.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    self.transferDescTextView.text = @"请选择原因";
}

#pragma mark - 选择部门
- (void)chooseDept
{

}

#pragma mark - 选择转报目的工位
- (void)chooseWorkStation
{
    
}

#pragma mark - 验证
- (IBAction)checkAction:(UIButton *)sender {
    
}

#pragma mark - setUpRightNavButton
- (void)setUpRightNavButton
{
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"checkBtn.png"];
    checkBtn.frame = RECT(APP_W-40, 7, image.size.width/2, image.size.height/2);
    [checkBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - checkAction
- (void)check
{
    
}
@end
