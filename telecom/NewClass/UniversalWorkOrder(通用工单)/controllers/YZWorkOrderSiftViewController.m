//
//  YZWorkOrderSiftViewController.m
//  telecom
//
//  Created by 锋 on 16/6/14.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZWorkOrderSiftViewController.h"
#import "YZConditionSiftView.h"
#import "CompAlertBox.h"
#import "IQKeyboardManager.h"

@interface YZWorkOrderSiftViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
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

@implementation YZWorkOrderSiftViewController

- (void)dealloc
{
    NSLog(@"---------------");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"筛选";
    [self addRightBarButtonItem];
    [self addNavigationLeftButton];
    if (_isFromPerson) {
        
        _titleArray = [[NSArray alloc] initWithObjects:@"状态", nil];
        NSMutableDictionary *conditionDict = (NSMutableDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"PersonSiftCondition"];
        
        if (conditionDict == nil) {
            _conditionDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        }else{
            _conditionDict = [[NSMutableDictionary alloc] initWithDictionary:conditionDict];
        }

    }else{
        _titleArray = [[NSArray alloc] initWithObjects:@"开始日期",@"结束日期",@"工单类型",@"部门",@"人员",@"状态", nil];
        NSMutableDictionary *conditionDict = (NSMutableDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"WorkOrderSiftCondition"];
        
        if (conditionDict == nil) {
            _conditionDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"选择",@"conditionList0",@"选择",@"conditionList1",@"选择",@"conditionList2",@"选择",@"conditionList3", nil];
        }else{
            _conditionDict = [[NSMutableDictionary alloc] initWithDictionary:conditionDict];
        }

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

- (void)checkItemClicked
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    if (![self compareStartDateWithEndDate]) {
        return;
    }
    
    if (_departmentDict) {
        NSArray *departmentArray = [[_conditionDict objectForKey:@"conditionList3"] componentsSeparatedByString:@"\n"];
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
    if (_isFromPerson) {
        [[NSUserDefaults standardUserDefaults] setObject:_conditionDict forKey:@"PersonSiftCondition"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:_conditionDict forKey:@"WorkOrderSiftCondition"];
    }
    _siftCompletionBlock();
    [self leftAction];
}

- (void)clearItemClicked
{
    if (!_isFromPerson) {
        _conditionDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"选择",@"conditionList0",@"选择",@"conditionList1",@"选择",@"conditionList2",@"选择",@"conditionList3",@"",@"conditionList4",@"",@"conditionList5", nil];
        [_tableView reloadData];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        for (UIButton *sender in cell.contentView.subviews) {
            if ([sender isKindOfClass:[UIButton class]]) {
                if (sender.selected) {
                    [self statusButtonClicked:sender];
                }
            }
        }

    }else {
        [_conditionDict removeAllObjects];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        for (UIButton *sender in cell.contentView.subviews) {
            if ([sender isKindOfClass:[UIButton class]]) {
                if (sender.selected) {
                    [self statusButtonClicked:sender];
                }
            }
        }

        
    }
}

#pragma mark -- 查询部门
- (void)queryDepartmentListWithCompletion:(void (^)(BOOL isSingle,NSMutableArray *array))block
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"commonBill/GetOrgList";
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
            NSArray *listArray = [result objectForKey:@"list"];
            NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
            if (_departmentDict == nil) {
                _departmentDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"全部", nil];
            }
            for (NSDictionary *dict in listArray) {
                NSString *departmentId = [dict objectForKey:@"REGION_ID"];
                NSString *departmen_name = [dict objectForKey:@"REGION_NM"];
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
    if (_isFromPerson) {
        UITableViewCell *cell = [self createCell];
        return cell;
    }
    UITableViewCell *cell = nil;
    if (indexPath.row == 2 || indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"type"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"type"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.numberOfLines = 0;
        }
    }else if (indexPath.row == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"person"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"person"];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth - 200, 9, 180, 26)];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.delegate = self;
            textField.tag = 56;
            [cell.contentView addSubview:textField];
        }
        UITextField *textField = [cell.contentView viewWithTag:56];
        textField.text = [_conditionDict objectForKey:[NSString stringWithFormat:@"conditionList%d",indexPath.row]];

    }else if (indexPath.row == 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"status"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
            
            [self createStatusButtonWithCell:cell];
            
        }
        UIButton * unCompletionButton = [cell.contentView viewWithTag:1];
        UIButton * completionButton = [cell.contentView viewWithTag:2];
        if ([[_conditionDict objectForKey:[NSString stringWithFormat:@"conditionList%d",indexPath.row]] isEqualToString:@"-1"]) {
            
            unCompletionButton.selected = YES;
            [self setButtonSelected:unCompletionButton];

        }else if ([[_conditionDict objectForKey:[NSString stringWithFormat:@"conditionList%d",indexPath.row]] isEqualToString:@"-2"]) {
            
            completionButton.selected = YES;
            [self setButtonSelected:completionButton];
            
        }else if ([[_conditionDict objectForKey:[NSString stringWithFormat:@"conditionList%d",indexPath.row]] isEqualToString:@"-3"]) {
            
            unCompletionButton.selected = YES;
            completionButton.selected = YES;
            [self setButtonSelected:completionButton];
            [self setButtonSelected:unCompletionButton];
            
        }
        
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.detailTextLabel.text = [_conditionDict objectForKey:[NSString stringWithFormat:@"conditionList%d",indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -- 创建人员去向的cell
- (UITableViewCell *)createCell
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"status"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createStatusButtonWithCell:cell];
        
    }
    UIButton * unCompletionButton = [cell.contentView viewWithTag:1];
    UIButton * completionButton = [cell.contentView viewWithTag:2];
    if ([[_conditionDict objectForKey:@"status"] isEqualToString:@"1"]) {
        
        unCompletionButton.selected = YES;
        [self setButtonSelected:unCompletionButton];
        
    }else if ([[_conditionDict objectForKey:@"status"] isEqualToString:@"2"]) {
        completionButton.selected = YES;
        [self setButtonSelected:completionButton];
    }
     cell.textLabel.text = @"状态";
    return cell;
}

- (void)createStatusButtonWithCell:(UITableViewCell *)cell
{
    UIButton *completionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completionButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [completionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    completionButton.tag = 2;
    completionButton.frame = CGRectMake(kScreenWidth/3, 7, 80, 30);
    [completionButton setTitle:@"已完成" forState:UIControlStateNormal];
    completionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    completionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 26, 0, 0);
    [completionButton addTarget:self action:@selector(statusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:completionButton];
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.contents = (id)[UIImage imageNamed:@"select_none"].CGImage;
    imageLayer.frame = CGRectMake(0, 5, 20, 20);
    [completionButton.layer addSublayer:imageLayer];

    UIButton *unCompletionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    unCompletionButton.tag = 1;
    unCompletionButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [unCompletionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    unCompletionButton.frame = CGRectMake(2 *kScreenWidth/3, 7, 80, 30);
    [unCompletionButton setTitle:@"未完成" forState:UIControlStateNormal];
    unCompletionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    unCompletionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 26, 0, 0);
    [unCompletionButton addTarget:self action:@selector(statusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:unCompletionButton];
    
    CALayer *unCompletionButtonLayer = [CALayer layer];
    unCompletionButtonLayer.contents = (id)[UIImage imageNamed:@"select_none"].CGImage;
    unCompletionButtonLayer.frame = CGRectMake(0, 5, 20, 20);
    [unCompletionButton.layer addSublayer:unCompletionButtonLayer];
}

#pragma mark -- 设置button的选中状态
- (void)setButtonSelected:(UIButton *)sender
{
    CALayer *subLayer = [sender.layer.sublayers lastObject];
    subLayer.contents = (id)[UIImage imageNamed:@"select"].CGImage;
}

- (void)statusButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
     CALayer *subLayer = [sender.layer.sublayers lastObject];
    UIButton * unCompletionButton = [_tableView viewWithTag:1];
    UIButton * completionButton = [_tableView viewWithTag:2];
    
       if (_isFromPerson) {
           if (sender.selected && sender.tag == 1) {
               CALayer *unLayer = [unCompletionButton.layer.sublayers lastObject];
               CALayer *layer = [completionButton.layer.sublayers lastObject];
               unLayer.contents = (id)[UIImage imageNamed:@"select"].CGImage;
               layer.contents = (id)[UIImage imageNamed:@"select_none"].CGImage;
               completionButton.selected = NO;
               
           }else if (sender.selected && sender.tag == 2) {
               CALayer *unLayer = [unCompletionButton.layer.sublayers lastObject];
               CALayer *layer = [completionButton.layer.sublayers lastObject];
               layer.contents = (id)[UIImage imageNamed:@"select"].CGImage;
               unLayer.contents = (id)[UIImage imageNamed:@"select_none"].CGImage;
               unCompletionButton.selected = NO;
           }else{
               subLayer.contents = (id)[UIImage imageNamed:@"select_none"].CGImage;

           }

        if (unCompletionButton.selected){
            
            [_conditionDict setObject:@"1" forKey:@"status"];
            
        }else if (completionButton.selected) {
            
            [_conditionDict setObject:@"2" forKey:@"status"];
            
        }else{
            [_conditionDict removeObjectForKey:@"status"];
        }
        return;
    }
    
    if (sender.selected) {
        subLayer.contents = (id)[UIImage imageNamed:@"select"].CGImage;
    }else{
        subLayer.contents = (id)[UIImage imageNamed:@"select_none"].CGImage;
    }
   
    
    if (unCompletionButton.selected && completionButton.selected) {
        [_conditionDict setObject:@"-3" forKey:@"conditionList5"];
    }else if (unCompletionButton.selected){
        [_conditionDict setObject:@"-1" forKey:@"conditionList5"];
    }else if (completionButton.selected) {
        [_conditionDict setObject:@"-2" forKey:@"conditionList5"];
    }else {
        [_conditionDict removeObjectForKey:@"conditionList5"];
    }
}

#pragma mark -- 选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isFromPerson) {
        return;
    }
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
                [condtionDict setObject:strDate forKey:[NSString stringWithFormat:@"conditionList%d",indexPath.row]];
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
                [self showConditionSiftViewWithDataArray:array indexPath:indexPath tableViewCell:cell isSingleSelected:NO];
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

        [conditionDict setObject:selectedString forKey:[NSString stringWithFormat:@"conditionList%d",indexPath.row]];
        [weakTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        
    };
    CGRect rect = _conditionSiftView.bounds;
    rect.size.height = height;
    _conditionSiftView.bounds = rect;
//    [UIView animateWithDuration:.2 animations:^{
//        
//    }];

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

#pragma mark -- 比较开始日期是否小于结束日期
- (BOOL)compareStartDateWithEndDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MM-dd";
    NSDate *startDate = [dateFormatter dateFromString:[_conditionDict objectForKey:@"conditionList0"]];
    NSDate *endDate = [dateFormatter dateFromString:[_conditionDict objectForKey:@"conditionList1"]];
    NSComparisonResult result = [startDate compare:endDate];
    if (result == NSOrderedDescending) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始日期请小于结束日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 || indexPath.row == 3) {
        NSArray *array = [[_conditionDict objectForKey:[NSString stringWithFormat:@"conditionList%d",indexPath.row]] componentsSeparatedByString:@"\n"];
        return (array.count + 1) * 22;

    }
    return 44;
}

#pragma mark -- textField代理
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect rect = _tableView.frame;
    rect.size.height -= 297;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25f];
    [UIView setAnimationCurve:7];
    
    _tableView.frame = rect;
    
    [UIView commitAnimations];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect rect = _tableView.frame;
    rect.size.height += 297;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25f];
    [UIView setAnimationCurve:7];
    
    _tableView.frame = rect;
    
    [UIView commitAnimations];
    
    [_conditionDict setObject:textField.text forKey:@"conditionList4"];
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
