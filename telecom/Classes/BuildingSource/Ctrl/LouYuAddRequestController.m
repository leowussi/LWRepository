//
//  LouYuAddRequestController.m
//  telecom
//
//  Created by SD0025A on 16/6/29.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "LouYuAddRequestController.h"

@interface LouYuAddRequestController ()

@end

@implementation LouYuAddRequestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"请求支撑";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, APP_W, APP_H-64)];
    imageView.image = [UIImage imageNamed:@"正在建设中底"];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
