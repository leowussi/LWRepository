//
//  DelaysController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "DelaysController.h"
#import "ZYFDelayApplyController.h"
#import "CRMHelper.h"
#import "HWNavigationController.h"
#import "ZYFHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFUrl.h"
#import "AddDelayController.h"

@interface DelaysController () <ZYFDelayApplyControllerDelegate>

@end

@implementation DelaysController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSystemScreenWidth, kSystemScreenHeight) style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.tableFooterView = [self createFooterView];
    [self setTitle:@"延期申请"];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDelay)];
    addItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDelayDataFromServer];

}

/**
 *  从服务器获取当前工单的logs
 */

-(void)getDelayDataFromServer
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSString *urlStr = kDelayApply;
//    NSString *urlString = [NSString stringWithFormat:@"%@B044310F-F81A-E511-8281-1CC1DE1DF924",urlStr];

    NSString *urlString = [NSString stringWithFormat:@"%@?id=%@",urlStr,self.saleList.Id];
    [ZYFHttpTool getWithURLCache:urlString params:nil success:^(id json) {
        self.delaysData = json;
        [self.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}


-(UIView*)createFooterView
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSystemScreenWidth, 100)];
    
    UIButton *delayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delayBtn setTitle:@"添加延期申请" forState:UIControlStateNormal];
    [delayBtn setBackgroundColor:[UIColor colorWithRed:23.0/255.0 green:109.0/255.0 blue:250.0/255.0 alpha:1.0]];
    delayBtn.center = footerView.center;
    delayBtn.bounds = CGRectMake(0, 0, 130, 35);
    delayBtn.layer.cornerRadius = 5.0;
    
    [delayBtn addTarget:self action:@selector(addDelay) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:delayBtn];
    return footerView;
}


#pragma mark -- 增加延期申请
-(void)addDelay
{
    AddDelayController *newDelay = [[AddDelayController alloc]init];
    newDelay.delegate = self;
    newDelay.saleList = self.saleList;
    HWNavigationController *nav =[[HWNavigationController alloc]initWithRootViewController:newDelay];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark -- ZYFDelayApplyControllerDelegate
-(void)delayApplyController:(ZYFDelayApplyController *)ctrl isFinished:(BOOL)isFinish
{
    //添加完成，更新当前的延期申请
    if (isFinish) {
        [self getDelayDataFromServer];
    }
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.delaysData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"delays";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        ZYFSaleList *sale = [self.delaysData objectAtIndex:indexPath.row];
        for (ZYFAttributes *attr in sale.attrArray) {
            if ([attr.myKey isEqualToString:@"new_name"]) {
                cell.textLabel.text = @"延期申请:";
                cell.detailTextLabel.text = attr.myValueString;
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //延期申请
    ZYFSaleList *sale = [self.delaysData objectAtIndex:indexPath.row];
    
    ZYFDelayApplyController *delayCtrl = [[ZYFDelayApplyController alloc]init];
    delayCtrl.saleList = sale;
    [self.navigationController pushViewController:delayCtrl animated:YES];
}

@end
