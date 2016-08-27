//
//  YZStatisticsSiftViewController.m
//  telecom
//
//  Created by 锋 on 16/7/29.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZStatisticsSiftViewController.h"
#import "YZConditionSiftView.h"
#import "CompAlertBox.h"
#import "IQKeyboardManager.h"

@interface YZStatisticsSiftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSArray *_titleArray;
    
    AlertBox* _datePicker;
    //保存筛选的结果
    NSMutableDictionary *_conditionDict;
    //筛选视图
    YZConditionSiftView *_conditionSiftView;
    NSMutableDictionary *_chooseDict;
    
    
    NSMutableDictionary *_departmentDict;
}
@end

@implementation YZStatisticsSiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"筛选";
    [self addRightBarButtonItem];
    [self addNavigationLeftButton];
    
    _titleArray = [[NSArray alloc] initWithObjects:@"开始日期",@"结束日期",@"工单类型",@"部门", nil];
    NSMutableDictionary *conditionDict = (NSMutableDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"StatisticsSiftCondition"];
    
    if (conditionDict == nil) {
        _conditionDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"选择",@"0",@"选择",@"1",@"选择",@"2",@"选择",@"3", nil];
    }else{
        _conditionDict = [[NSMutableDictionary alloc] initWithDictionary:conditionDict];
    }
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - 返回按钮
- (void)addNavigationLeftButton
{
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


#pragma mark -- 导航条右侧按钮
- (void)addRightBarButtonItem
{
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkButton.frame = CGRectMake(0, 0, 32, 32);
    [checkButton setBackgroundImage:[UIImage imageNamed:@"nav_check"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc] initWithCustomView:checkButton];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(0, 0, 32, 32);
    [clearButton setBackgroundImage:[UIImage imageNamed:@"nav_clear"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    
    self.navigationItem.rightBarButtonItems = @[clearItem,checkItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkItemClicked
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    if (![self compareStartDateWithEndDate]) {
        return;
    }
    NSLog(@"%@",_conditionDict);
    if (_departmentDict) {
        NSArray *departmentArray = [[_conditionDict objectForKey:@"3"] componentsSeparatedByString:@"\n"];
        NSMutableArray *departmentIdArray = [NSMutableArray arrayWithCapacity:0];
        for (NSString *name in departmentArray) {
            NSString *obj = [_departmentDict objectForKey:name];
            if (obj != nil) {
                [departmentIdArray addObject:obj];
            }
            
        }
        
        NSString *orgId = [departmentIdArray componentsJoinedByString:@","];
        [_conditionDict setObject:orgId forKey:@"orgId"];
    }
    
    
    NSLog(@"%@",_conditionDict);
    
    [[NSUserDefaults standardUserDefaults] setObject:_conditionDict forKey:@"StatisticsSiftCondition"];
    
    _siftCompletionBlock();
    [self leftAction];
}

- (void)clearItemClicked
{
    
    [_conditionDict removeAllObjects];
    for (int i = 0; i < 4; i++) {
        [_conditionDict setObject:@"选择" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    [_tableView reloadData];

}

#pragma mark -- 比较开始日期是否小于结束日期
- (BOOL)compareStartDateWithEndDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MM-dd";
    NSDate *startDate = [dateFormatter dateFromString:[_conditionDict objectForKey:@"0"]];
    NSDate *endDate = [dateFormatter dateFromString:[_conditionDict objectForKey:@"1"]];
    NSComparisonResult result = [startDate compare:endDate];
    if (result == NSOrderedDescending) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始日期请小于结束日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark -- 查询部门
- (void)queryDepartmentListWithCompletion:(void (^)(BOOL isSingle,NSMutableArray *array))block
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"commonBill/GetOrgListByPrivilege";
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
            NSArray *listArray = [result objectForKey:@"list"];
            NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
            if (_departmentDict == nil) {
                _departmentDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"全部", nil];
            }
            for (NSDictionary *dict in listArray) {
                NSString *departmentId = [dict objectForKey:@"id"];
                NSString *departmen_name = [dict objectForKey:@"name"];
                [mutArray addObject:departmen_name];
                [_departmentDict setObject:departmentId forKey:departmen_name];
            }
            
            [_chooseDict setObject:mutArray forKey:@"3"];
            if (mutArray.count > 1) {
                block(NO,mutArray);
            }else{
                block(YES,mutArray);
            }
        }
    }, ^(id result) {
        NSLog(@"%@",result);
    });
    
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.detailTextLabel.text = [_conditionDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 || indexPath.row == 3) {
        NSArray *array = [[_conditionDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] componentsSeparatedByString:@"\n"];
        return (array.count + 1) * 22;
        
    }
    return 44;
}

#pragma mark -- 选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_conditionSiftView.superview != nil) {
        return;
    }
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (indexPath.row < 2) {
        if (_datePicker == nil) {
            _datePicker = newDatePickerBox();
            UIDatePicker *datePicker = (UIDatePicker *)_datePicker.contentView;
            datePicker.maximumDate = nil;
            datePicker.minimumDate = nil;
            [self.view addSubview:_datePicker];
        }
        _datePicker.title = [NSString stringWithFormat:@"请选择%@",_titleArray[indexPath.row]];
        [_datePicker show];
        __weak UIDatePicker *datePicker = (UIDatePicker *)_datePicker.contentView;
        __weak NSMutableDictionary *condtionDict = _conditionDict;
        _datePicker.respBlock = ^(int index) {
            if (index == BTN_OK) {
                NSString* strDate = date2str(datePicker.date, DATE_FORMAT);
                cell.detailTextLabel.text = strDate;
                [condtionDict setObject:strDate forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            }
        };
    }else if (indexPath.row == 2 || indexPath.row == 3) {
        if (_conditionSiftView == nil) {
            _conditionSiftView = [[YZConditionSiftView alloc] initWithFrame:CGRectZero tableViewFrame:CGRectZero dataArray:nil title:nil];
            _chooseDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSMutableArray arrayWithObjects:@"故障单",@"业务开通单",@"风险操作工单",@"作业计划",@"指挥任务单",@"随工单",@"资源变更工单",@"请求支撑单", nil],@"2", nil];
        }
        
        NSMutableArray *array = [_chooseDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        if (array == nil) {
            [self queryDepartmentListWithCompletion:^(BOOL isSingle, NSMutableArray *departmentArray) {
                [self showConditionSiftViewWithDataArray:departmentArray indexPath:indexPath tableViewCell:cell isSingleSelected:isSingle];
            }];
        }else{
            if (array.count > 1) {
                if (indexPath.row == 2) {
                    [self showConditionSiftViewWithDataArray:array indexPath:indexPath tableViewCell:cell isSingleSelected:YES];
                }else {
                    [self showConditionSiftViewWithDataArray:array indexPath:indexPath tableViewCell:cell isSingleSelected:NO];
                }
                
            }else{
                
                [self showConditionSiftViewWithDataArray:array indexPath:indexPath tableViewCell:cell isSingleSelected:YES];
            }
            
        }
    }
}

- (void)showConditionSiftViewWithDataArray:(NSMutableArray *)array indexPath:(NSIndexPath *)indexPath tableViewCell:(UITableViewCell *)cell isSingleSelected:(BOOL)isSingle
{
    CGFloat height = (array.count + 1)* 28 + 66 > kScreenHeight - 130 ? kScreenHeight - 130 :  (array.count + 1)* 28 + 66;
    _conditionSiftView.bounds = CGRectMake(0, 0, kScreenWidth - 40, cell.frame.size.height);
    _conditionSiftView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    _conditionSiftView.isSingleSelect = isSingle;
    _conditionSiftView.tableView.frame = CGRectMake(0, 0, _conditionSiftView.frame.size.width, height);
    _conditionSiftView.title_desc = _titleArray[indexPath.row];
    _conditionSiftView.selectedIndexArray = [self getSelectedIndexArrayWithSuperArray:array subString:cell.detailTextLabel.text];
    _conditionSiftView.dataArray = array;
    
    
    [self.view addSubview:_conditionSiftView];
    
    __weak UITableView *weakTableView = _tableView;
    __weak NSMutableDictionary *conditionDict = _conditionDict;
    _conditionSiftView.completionBlock = ^(NSString *selectedString){
        
        [conditionDict setObject:selectedString forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        [weakTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        
    };
    CGRect rect = _conditionSiftView.bounds;
    rect.size.height = height;
    _conditionSiftView.bounds = rect;
  
    
}


//获取选中的索引数组
- (NSMutableArray *)getSelectedIndexArrayWithSuperArray:(NSArray *)superArray subString:(NSString *)selectedString
{
    NSMutableArray *selctedaArray = [NSMutableArray arrayWithCapacity:0];
    if ([selectedString isEqualToString:@"全部"]) {
        for (int i = 0; i < superArray.count + 1; i++) {
            [selctedaArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        return selctedaArray;
    }
    NSArray *array = [selectedString componentsSeparatedByString:@"\n"];
    
    for (NSString *text in array) {
        if ([superArray containsObject:text]) {
            NSUInteger index = [superArray indexOfObject:text];
            [selctedaArray addObject:[NSString stringWithFormat:@"%u",index]];
            
        }
    }
    return selctedaArray;
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
