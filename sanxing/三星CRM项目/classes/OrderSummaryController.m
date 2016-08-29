//
//  OrderSummaryController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/20.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "OrderSummaryController.h"
#import "LogsFooterView.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFUrl.h"
#import "ZYFHttpTool.h"
#import "CRMHelper.h"

@interface OrderSummaryController ()

@property (nonatomic,weak) LogsFooterView *summaryView;

@end

@implementation OrderSummaryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"派工总结";

    //可编辑的时候才显示保存按钮
    if (self.editable) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(assignSummary)];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LogsFooterView *summaryView = [[LogsFooterView alloc]init];
    summaryView.textView.text = self.summaryText;
    
    summaryView.textView.editable = self.editable;
    
    summaryView.frame = CGRectMake(0, 74.0, kSystemScreenWidth, kSystemScreenHeight * 0.5);
    [self.view addSubview:summaryView];
    
    self.summaryView = summaryView;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//派工总结保存
-(void)assignSummary
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    //保存返回之前不允许多次点击
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Id"] = self.saleList.Id;
    params[@"LogicalName"] = self.saleList.LogicalName;
    params[@"new_order_summary"] = self.summaryView.textView.text;
    
    NSString *urlString = kWorkLogAssignStatusSave;
    [ZYFHttpTool postWithURL:urlString params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *msg = dictionary[@"Msg"];
        
        if ([self.delegate respondsToSelector:@selector(orderSummaryController:changeText:)]) {
            [self.delegate orderSummaryController:self changeText:self.summaryView.textView.text];
        }
        
        [MBProgressHUD showSuccess:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;

        NSString *errorString = [NSString stringWithFormat:@"%@",error];
//        [self.navigationController popViewControllerAnimated:YES];
    }];
}




@end
