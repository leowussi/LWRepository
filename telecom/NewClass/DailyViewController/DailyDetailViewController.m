//
//  DailyDetailViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/6/18.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "DailyDetailViewController.h"

@interface DailyDetailViewController ()

@end

@implementation DailyDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavLeftButton:@"message"];
    [self addLeftSearchBar];
    [self initView];
}

-(void)initView
{
    UIImage *backImg = [UIImage imageNamed:@"正在建设中底.png"];
    UIImageView *backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, backImg.size.width/2, backImg.size.height/2)];
    backImgView.image = backImg;
    backImgView.userInteractionEnabled = YES;
    [self.view addSubview:backImgView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(kScreenWidth/2-40, 200, 80, 25)];
    backBtn.backgroundColor = [UIColor orangeColor];
    backBtn.layer.masksToBounds = YES;
    backBtn.layer.cornerRadius = 10;
    [backBtn setTitle:@"返回上一步" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [backImgView addSubview:backBtn];
}

-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
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
