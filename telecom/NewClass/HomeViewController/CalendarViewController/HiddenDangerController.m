//
//  HiddenDangerController.m
//  telecom
//
//  Created by liuyong on 15/6/29.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "HiddenDangerController.h"

@interface HiddenDangerController ()

@end

@implementation HiddenDangerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐患";
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT(0, 64, APP_W, APP_H-44)];
    imageView.image = [UIImage imageNamed:@"正在建设中底.png"];
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
