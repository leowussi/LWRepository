//
//  YZRiskOperationListViewController.m
//  telecom
//
//  Created by 锋 on 16/6/20.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZRiskOperationListViewController.h"
#import "YZRiskOpertionListTableViewCell.h"
#import "YZRiskOperationDetailViewController.h"

@interface YZRiskOperationListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    //搜索框
    UITextField *_seaFiled;
    
    NSMutableArray *_dataArray;
}
@end

@implementation YZRiskOperationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(235, 238, 243);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableView];
    [self setsSearchBarWithPlachTitle:@" 请输入风险操作工单编号"];
    [self addNavigationLeftButton];
    
    [self searchBtn];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 92, kScreenWidth, kScreenHeight - 92) style:UITableViewStyleGrouped];
    _tableView.rowHeight = 96;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZRiskOpertionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YZRiskOpertionListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    YZRiskOpertionList *list = _dataArray[indexPath.row];
    
    cell.label_time.text = [NSString stringWithFormat:@"%@~%@",list.applyStartTime,list.applyEndTime];
    cell.label_workOrderId.text = list.workOrderId;
    cell.label_profession.text = list.profession;
    cell.label_riskKind.text = list.riskKind;
    cell.label_title.text = list.title;
    if (list.height_title > 22) {
        cell.label_title.font = [UIFont systemFontOfSize:13];
    }else{
        cell.label_title.font = [UIFont systemFontOfSize:15];
    }
    
    
    //    [cell updateWorkOrderTitleHeight:list.height_title];
    cell.label_status.text = list.status;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZRiskOpertionList *list = _dataArray[indexPath.row];
    [list getDetailTextHeight];
    
    YZRiskOperationDetailViewController *riskOperationDetailVC = [[YZRiskOperationDetailViewController alloc] init];
    riskOperationDetailVC.dataArray = [NSArray arrayWithObjects:list.showDetailArray,list.showMoreArray, nil];
    riskOperationDetailVC.heightArray = [NSArray arrayWithObjects:list.detailHeightArray,list.moreHeightArray, nil];
    
    riskOperationDetailVC.riskId = list.riskId;
    riskOperationDetailVC.workNo = list.workNo;
    [self.navigationController pushViewController:riskOperationDetailVC animated:YES];
    
}

#pragma mark - 返回按钮
- (void)addNavigationLeftButton
{
    self.navigationItem.title = @"风险操作列表";
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIImageView *imageView = [UnityLHClass initUIImageView:@"back_btn" rect:CGRectMake(0, 7,navImg.size.width/1,navImg.size.height/1)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,44,44);
    //    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:imageView];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//搜索视图
- (void)setsSearchBarWithPlachTitle:(NSString *)str{
    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectZero];
    rightLable.text = @"      ";
    [rightLable setFont:[UIFont systemFontOfSize:13.0]];
    rightLable.alpha = 0.5;
    [rightLable sizeToFit];
    
    _seaFiled = [[UITextField alloc]initWithFrame:CGRectMake(32, 0, kScreenWidth-80, 28)];
    _seaFiled.backgroundColor = [UIColor whiteColor];
    _seaFiled.rightViewMode = UITextFieldViewModeAlways;
    _seaFiled.rightView = rightLable;
    _seaFiled.placeholder = str;
    _seaFiled.font = [UIFont systemFontOfSize:13.0];
    _seaFiled.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    _seaFiled.layer.borderWidth = 0.6f;
    _seaFiled.layer.cornerRadius = 14.0f;
    _seaFiled.delegate = self;
    _seaFiled.returnKeyType = UIReturnKeySearch;
    //    [self.view addSubview:seaFiled];
    
    UIImage *btnImg = [UIImage imageNamed:@"2.9.png"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:btnImg forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(kScreenWidth + 2 - btnImg.size.width, 0, btnImg.size.width/2, btnImg.size.height/1.9)];
    [searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:searchBtn];
    
    UIImage *seaImg = [UIImage imageNamed:@"sea.png"];
    UIImageView *seaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, seaImg.size.width/2, seaImg.size.height/2)];
    seaImgView.image = seaImg;
    [searchBtn addSubview:seaImgView];
    
    
    UIView *backview = [[UIView alloc]init];
    backview.frame = CGRectMake(0, 80, kScreenWidth, 49);
    backview.backgroundColor = RGBCOLOR(235, 238, 243);
    [backview addSubview:_seaFiled];
    [backview addSubview:searchBtn];
    [self.view addSubview:backview];
    
}
//搜索
- (void)searchBtn
{
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"riskOperation/GetRiskOperationList";
    paraDict[@"orderNo"] = _seaFiled.text;
    paraDict[@"type"] = @"2";
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if (_dataArray == nil) {
            _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }else{
            [_dataArray removeAllObjects];
        }
        NSArray *listArray = [result objectForKey:@"list"];
        if (listArray.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件的数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        }else {
            for (NSDictionary *dict in listArray) {
                YZRiskOpertionList *list = [[YZRiskOpertionList alloc] initWithParserWithDictionary:dict];
                [_dataArray addObject:list];
            }
        }
        [_tableView reloadData];
    }, ^(id result) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[result objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_dataArray removeAllObjects];
        [_tableView reloadData];
        
    });
}

#pragma mark -- textField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchBtn];
    return YES;
}

//更新数据
- (void)updateDataSource
{
    [self searchBtn];
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
