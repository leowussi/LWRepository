//
//  NearTaskViewController.m
//  i YunWei
//
//  Created by 郝威斌 on 15/5/8.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "NearTaskViewController.h"

@interface NearTaskViewController ()

@end

@implementation NearTaskViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigl:@"附近任务"];
    [self addNavigationLeftButton];
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
