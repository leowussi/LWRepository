//
//  YZResourcesChangeRevokeViewController.m
//  telecom
//
//  Created by 锋 on 16/7/21.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZResourcesChangeRevokeViewController.h"

@interface YZResourcesChangeRevokeViewController ()
{
    UITextView *_textView;
}
@end

@implementation YZResourcesChangeRevokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"撤销资源变更工单";
    [self addRightBarButtonItem];
    [self addNavigationLeftButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 89, 120, 22)];
    label.textColor = [UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1];
    label.text = @"撤    销    原    因 :";
    label.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:label];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(130, 84, kScreenWidth - 140, 80)];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.layer.cornerRadius = 4;
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.layer.borderWidth = .5;
    _textView.showsVerticalScrollIndicator = NO;

    [self.view addSubview:_textView];
}

#pragma mark -- 导航条按钮
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIImageView *imageView = [UnityLHClass initUIImageView:@"back_btn" rect:CGRectMake(0, 7,navImg.size.width/1,navImg.size.height/1)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,44,44);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:imageView];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)addRightBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"checkBtn"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark -- 导航条按钮被点击
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClicked
{
    if (_textView.text == nil || [_textView.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入撤销原因" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithCapacity:0];
    paraDict[URL_TYPE] = @"adjustRes/CancelBill";
    paraDict[@"id"] = _workOrderId;
    paraDict[@"cancelContent"] = _textView.text;
    
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        NSString *error = [result objectForKey:@"error"];
        if ([[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        }

    }, ^(id result) {
        NSLog(@"%@",result);
    });

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self leftAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
