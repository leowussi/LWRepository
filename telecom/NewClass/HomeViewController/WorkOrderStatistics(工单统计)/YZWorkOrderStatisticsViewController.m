//
//  YZWorkOrderStatisticsViewController.m
//  telecom
//
//  Created by 锋 on 16/7/29.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZWorkOrderStatisticsViewController.h"
#import "YZStatisticsSiftViewController.h"

@interface YZWorkOrderStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    //搜索框
    UITextField *_seaFiled;
    
    NSMutableArray *_dataArray;

}
@end

@implementation YZWorkOrderStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _baseScrollView.backgroundColor = RGBCOLOR(232, 236, 245);
    [self setsSearchBarWithPlachTitle:@" 请输入工单编号"];
    [self addBarButtonItem];
    [self createTableView];
    [self searchBtn];

}

- (void)addBarButtonItem
{
    self.navigationItem.title = @"工单统计";
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(0, 0, 29, 29);
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightBarbuttonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBarbuttonItemClicked
{
    YZStatisticsSiftViewController *siftVC = [[YZStatisticsSiftViewController alloc] init];
    siftVC.siftCompletionBlock = ^{
        [self searchBtn];
    };
    [self.navigationController pushViewController:siftVC animated:YES];
}


- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 122, kScreenWidth - 24, kScreenHeight - 136) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor;
    _tableView.layer.borderWidth = .5;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textColor = [UIColor colorWithRed:46/255.0 green:141/255.0 blue:222/255.0 alpha:1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

//搜索视图
- (void)setsSearchBarWithPlachTitle:(NSString *)str{
    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectZero];
    rightLable.text = @"      ";
    [rightLable setFont:[UIFont systemFontOfSize:13.0]];
    rightLable.alpha = 0.5;
    [rightLable sizeToFit];
    
    _seaFiled = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 80, 28)];
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
    [searchBtn setFrame:CGRectMake(kScreenWidth-30-btnImg.size.width, 0, btnImg.size.width/2, btnImg.size.height/1.9)];
    [searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:searchBtn];
    
    UIImage *seaImg = [UIImage imageNamed:@"sea.png"];
    UIImageView *seaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, seaImg.size.width/2, seaImg.size.height/2)];
    seaImgView.image = seaImg;
    [searchBtn addSubview:seaImgView];
    
    
    UIView *backview = [[UIView alloc]init];
    backview.frame = CGRectMake(32, 80, kScreenWidth, 28);
    [backview addSubview:_seaFiled];
    [backview addSubview:searchBtn];
    [self.view addSubview:backview];
    
}
#pragma mark -- textField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBtn];
    return NO;
}
//搜索
- (void)searchBtn
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    
    NSDictionary *conditionDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"StatisticsSiftCondition"];
    
    paraDict[URL_TYPE] = @"commonBill/QueryCommBillFormNums";
    if ([conditionDict objectForKey:@"0"] && ![[conditionDict objectForKey:@"0"] isEqualToString:@"选择"]) {
        paraDict[@"startTime"] = [NSString stringWithFormat:@"%@ 00:00:00",[conditionDict objectForKey:@"0"]];
    }else {
        NSString *firstDay = getMonthFirstDay([NSDate date]);
        paraDict[@"startTime"] = [NSString stringWithFormat:@"%@ 00:00:00",firstDay];

    }
    
    if ([conditionDict objectForKey:@"1"] && ![[conditionDict objectForKey:@"0"] isEqualToString:@"选择"]) {
        paraDict[@"endTime"] = [NSString stringWithFormat:@"%@ 00:00:00",[conditionDict objectForKey:@"1"]];
    }else {
        NSString *lastDay = getMonthLastDay([NSDate date]);
        paraDict[@"endTime"] = [NSString stringWithFormat:@"%@ 23:59:59",lastDay];

    }
    //暂时不提供输入工单标号搜索
//    paraDict[@"billId"] = _seaFiled.text;
    
    NSArray *array = @[@"全部",@"故障单",@"业务开通单",@"风险操作工单",@"作业计划",@"指挥任务单",@"随工单",@"资源变更工单",@"请求支撑单"];
    if ([conditionDict objectForKey:@"2"] != nil && ![[conditionDict objectForKey:@"2"] isEqualToString:@"选择"]) {
//        NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:0];
        NSString *workOrderName = [conditionDict objectForKey:@"2"];
        NSInteger index = [array indexOfObject:workOrderName];
        paraDict[@"billType"] = [NSString stringWithFormat:@"%d",index];

        /*多选操作
        NSArray *strArray = [[conditionDict objectForKey:@"2"] componentsSeparatedByString:@"\n"];
        for (NSString *obj in strArray) {
            NSInteger index = [array indexOfObject:obj];
            [indexArray addObject:[NSString stringWithFormat:@"%d",index]];
        }
        paraDict[@"billType"] = [indexArray componentsJoinedByString:@","];
        */
    }else {
        paraDict[@"billType"] = @"0";
    }
    
    NSString *orgId = [conditionDict objectForKey:@"orgId"];

    if (orgId == nil || [orgId isEqualToString:@""]) {
        orgId = @"0";
    }
    paraDict[@"orgId"] = orgId;
    
   
    NSLog(@"%@",paraDict);
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        NSDictionary *detail = [result objectForKey:@"detail"];
        if ([[result objectForKey:@"result"] isEqualToString:@"0000000"] && detail.count == 0) {
            [self showAlertWithTitle:@"提示" :@"没有符合条件的数据" :@"确定" :nil];
            return ;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        if (_dataArray == nil) {
            _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        }else{
            [_dataArray removeAllObjects];
        }
        if ([detail objectForKey:@"faultNums"]) {
            NSString *faultNums = [NSString stringWithFormat:@"故障单(%@)张",[detail objectForKey:@"faultNums"]];
            [_dataArray addObject:faultNums];
        }
        if ([detail objectForKey:@"serviceFulfillNums"]) {
            NSString *serviceFulfillNums = [NSString stringWithFormat:@"业务开通单(%@)张",[detail objectForKey:@"serviceFulfillNums"]];
            [_dataArray addObject:serviceFulfillNums];
            
        }
        if ([detail objectForKey:@"riskOperatorNums"]) {
            NSString *riskOperatorNums = [NSString stringWithFormat:@"风险操作工单(%@)张",[detail objectForKey:@"riskOperatorNums"]];
            [_dataArray addObject:riskOperatorNums];
        }
        
        if ([detail objectForKey:@"workPlanNums"]) {
            NSString *workPlanNums = [NSString stringWithFormat:@"作业计划(%@)张",[detail objectForKey:@"workPlanNums"]];
            [_dataArray addObject:workPlanNums];
        }
        if ([detail objectForKey:@"commandTaskNums"]) {
            NSString *commandTaskNums = [NSString stringWithFormat:@"指挥任务单(%@)张",[detail objectForKey:@"commandTaskNums"]];
            [_dataArray addObject:commandTaskNums];
        }
        
        if ([detail objectForKey:@"workFollowNums"]) {
            NSString *workFollowNums = [NSString stringWithFormat:@"随工单(%@)张",[detail objectForKey:@"workFollowNums"]];
            [_dataArray addObject:workFollowNums];
        }
        
        if ([detail objectForKey:@"adjustResNums"]) {
            NSString *adjustResNums = [NSString stringWithFormat:@"资源变更工单(%@)张",[detail objectForKey:@"adjustResNums"]];
            [_dataArray addObject:adjustResNums];
        }
        if ([detail objectForKey:@"supportBillNums"]) {
            NSString *supportBillNums = [NSString stringWithFormat:@"请求支撑单(%@)张",[detail objectForKey:@"supportBillNums"]];
            [_dataArray addObject:supportBillNums];
        }
        
        
        [_tableView reloadData];
    }, ^(id result) {
        NSLog(@"%@",result);
    });
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
