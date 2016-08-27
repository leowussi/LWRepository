//
//  YZQualityIndexViewController.m
//  telecom
//
//  Created by 锋 on 16/6/20.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZQualityIndexViewController.h"
#import "YZRiskOperationListViewController.h"
#import "YZResourcesChangeViewController.h"

@interface YZQualityIndexViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    BOOL _needResourceChange;
    
}
@end

@implementation YZQualityIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationLeftButton];
    [self addNavigationRightButton];
    
    [self createTableView];
    [self loadData];
    
}

#pragma mark -- 加载数据
- (void)loadData
{
    NSArray *array = @[@"割接",@"隐患处理",@"应急演练",@"版本升级",@"网络优化"];
    NSInteger index = [array indexOfObject:_riskKind];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"riskOperation/GetRiskTargetInfo";
    paraDict[@"kind"] = [NSString stringWithFormat:@"%d",index + 1];
    httpPOST(paraDict, ^(id result) {
        _dataArray = [result objectForKey:@"list"];
        [_tableView reloadData];
    }, ^(id result) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[result objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });

}

#pragma mark -- 创建表视图
- (void)createTableView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"index"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"indx"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, kScreenWidth - 80, 28)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.tag = 11;
        [cell.contentView addSubview:titleLabel];
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 64, 10, 50, 24)];
        switchButton.tag = 12;
        [cell.contentView addSubview:switchButton];
    }
    UILabel *titleLabel = [cell.contentView viewWithTag:11];
    NSDictionary *dict = _dataArray[indexPath.row];
    titleLabel.text = [dict objectForKey:@"targetContent"];
    
    UISwitch *switchButton = [cell.contentView viewWithTag:12];
    if ([[dict objectForKey:@"defaultValue"] integerValue] == 1) {
        switchButton.on = YES;
    }else{
        switchButton.on = NO;
    }
    
    return cell;
}

#pragma mark - 返回按钮
- (void)addNavigationLeftButton
{
    self.navigationItem.title = @"质量业务指标";
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIImageView *imageView = [UnityLHClass initUIImageView:@"back_btn" rect:CGRectMake(0, 7,navImg.size.width/1,navImg.size.height/1)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,44,44);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:imageView];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)addNavigationRightButton
{
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton setBackgroundImage:[UIImage imageNamed:@"nav_check"] forState:UIControlStateNormal];
    [itemButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    itemButton.frame = CGRectMake(0, 0, 33, 33);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
}

#pragma mark -- 提交按钮
- (void)rightAction
{
    NSMutableArray *targetIdArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *targetValueArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < _dataArray.count; i++) {
        [targetIdArray addObject:[_dataArray[i] objectForKey:@"targetId"]];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UISwitch *switchButton = [cell.contentView viewWithTag:12];
        if (switchButton.on) {
            [targetValueArray addObject:@"1"];
        }else{
            [targetValueArray addObject:@"0"];
        }
        
        UILabel *label = [cell.contentView viewWithTag:11];
        if ([label.text isEqualToString:@"是否需进行资源变更？"] && switchButton.on) {
            _needResourceChange = YES;
        }
    }
    NSLog(@"%@",targetValueArray);
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"riskOperation/SubmitTarget";
    paraDict[@"riskId"] = _riskId;
    paraDict[@"targetId"] = [targetIdArray componentsJoinedByString:@","];
    paraDict[@"defaultValue"] = [targetValueArray componentsJoinedByString:@","];
    NSLog(@"%@",paraDict);
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = 11;
            [alertView show];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }, ^(id result) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[result objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];

    });


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11) {
        if (_needResourceChange) {
            UIAlertView *adjustAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否现在进行资源变更？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [adjustAlertView show];
            return;
        }
        

    }
    if (buttonIndex == 1) {
        UINavigationController *nav = self.navigationController;
        YZRiskOperationListViewController *viewController = self.navigationController.viewControllers[1];
        [viewController updateDataSource];
        [self.navigationController popToViewController:viewController animated:NO];
        YZResourcesChangeViewController *resourceChangeVC = [[YZResourcesChangeViewController alloc] init];
        [nav pushViewController:resourceChangeVC animated:YES];
    }else{
        [self leftAction];
    }
}

- (void)leftAction
{
    //更新风险操作列表的数据
    YZRiskOperationListViewController *viewController = self.navigationController.viewControllers[1];
    [viewController updateDataSource];

    [self.navigationController popToViewController:viewController animated:YES];
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
