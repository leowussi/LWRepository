//
//  YZRemindDetailViewController.m
//  telecom
//
//  Created by 锋 on 16/5/31.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZRemindDetailViewController.h"
#import "YZResourcesInfoDetailTableViewCell.h"
#import "CompAlertBox.h"

@interface YZRemindDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //底部的scrollview
    UIScrollView *_backgroundScrollView;
    CALayer *_backgroundLayer;
    UIView *_buttonView;
    UITableView *_tableView;
    
    NSMutableArray *_titleArray;
    
    //记录所选的提醒
    UIButton *_previousButton;
    
    AlertBox* _datePicker;
    
}
@end

@implementation YZRemindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"验收提醒";
    [self addNavigationLeftButton];
    [self loadLocalData];
    [self createBackgroundScrollView];
    [self createTableView];
    
}

-(void)leftAction
{
    [self cancelButtonClicked];
}

- (void)loadLocalData
{
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"配  合  任  务:",@"工  单  编  号:",@"工  程  名  称:",@"工  程  编  号:",@"发     起     人:",@"所  在  部  门:",@"发起人联系电话:",@"提  醒  方  式:", nil];
    
}

#pragma mark --- 底部的scrollView
- (void)createBackgroundScrollView
{
    _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    _backgroundLayer = [CALayer layer];
    _backgroundLayer.frame = CGRectMake(10, 10, kScreenWidth - 20, 444);
    _backgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;
    
    _backgroundLayer.shadowColor = [UIColor blackColor].CGColor;
    _backgroundLayer.shadowOffset = CGSizeMake(1, 1);
    _backgroundLayer.shadowRadius = 3;
    _backgroundLayer.shadowOpacity = .3f;
    [_backgroundScrollView.layer addSublayer:_backgroundLayer];
    _backgroundScrollView.contentSize = CGSizeMake(kScreenWidth, 590);
    [self.view addSubview:_backgroundScrollView];
    
    [self createBottomButtonWithFrame:CGRectMake(0, 460, kScreenWidth, 56)];
}

- (void)createBottomButtonWithFrame:(CGRect)frame
{
    _buttonView = [[UIView alloc] initWithFrame:frame];
    [_backgroundScrollView addSubview:_buttonView];
    
    UIButton *applicationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applicationButton.frame = CGRectMake(12, 6, (kScreenWidth - 36)/2, 40);
    applicationButton.backgroundColor = [UIColor colorWithRed:48/255.0 green:107/255.0 blue:180/255.0 alpha:1];
    [applicationButton setTitle:@"提  交" forState:UIControlStateNormal];
    [applicationButton addTarget:self action:@selector(applicationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    applicationButton.titleLabel.font = [UIFont systemFontOfSize:20];
    applicationButton.layer.cornerRadius = 4;
    [_buttonView addSubview:applicationButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(12 + (kScreenWidth - 36)/2 + 12, 6, (kScreenWidth - 36)/2, 40);
    cancelButton.backgroundColor = [UIColor colorWithRed:57/255.0 green:155/255.0 blue:47/255.0 alpha:1];
    [cancelButton setTitle:@"取  消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
    cancelButton.layer.cornerRadius = 4;
    [_buttonView addSubview:cancelButton];
    
    
}

//提交
- (void)applicationButtonClicked
{
    
    UIButton *startButton = [_tableView viewWithTag:40];
    if (startButton == nil) {
        [self showAlertWithTitle:@"提示" :@"请选择提醒方式" :@"OK" :nil];
    }
    if ([startButton.titleLabel.text isEqualToString:@"点击选择开始日期"]) {
        [self showAlertWithTitle:@"提示" :@"请选择提醒开始日期" :@"OK" :nil];
        return;
    }
    
    UIButton *endButton = [_tableView viewWithTag:40];
    if ([endButton.titleLabel.text isEqualToString:@"点击选择结束日期"]) {
        [self showAlertWithTitle:@"提示" :@"请选择提醒结束日期" :@"OK" :nil];
        return;
    }
    
    
    NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
    para1[URL_TYPE] = @"MyTask/WithWork/AddProjectCheckRemind";
    para1[@"checkId"] = _checkId;
    para1[@"remindStartTime"] = [startButton.titleLabel.text stringByAppendingString:@" 00:00:00"];
    para1[@"remindEndTime"] = [endButton.titleLabel.text stringByAppendingString:@" 00:00:00"];
    para1[@"remindCycle"] = [NSNumber numberWithInteger:_previousButton.tag - 30];
    httpPOST(para1, ^(id result) {
        NSLog(@"%@",result);
        if ([[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRemindList" object:self];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交提醒成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
    }, ^(id result) {
        
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self cancelButtonClicked];
}
//取消
- (void)cancelButtonClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAcceptanceList" object:self];
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 444) style:UITableViewStylePlain];
    //        _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layer.cornerRadius = 3;
    _tableView.layer.borderColor = COLOR(190, 190, 190).CGColor;
    _tableView.layer.borderWidth = .5f;
    _tableView.rowHeight = 40;
    _tableView.tableFooterView = [self createTableViewFooterView];
    [_backgroundScrollView addSubview:_tableView];
}

- (UIView *)createTableViewFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 100)];
    UIButton *dayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dayButton.frame = CGRectMake(20, 6, 120, 30);
    [dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dayButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [dayButton setTitle:@"每天提醒" forState:UIControlStateNormal];
    dayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    dayButton.contentEdgeInsets = UIEdgeInsetsMake(0,28, 0, 0);
    
    dayButton.tag = 30;
    [dayButton addTarget:self action:@selector(selectedButtonForRemindStyle:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:dayButton];
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.contents = (id)[UIImage imageNamed:@"select_none"].CGImage;
    imageLayer.frame = CGRectMake(0, 5, 20, 20);
    [dayButton.layer addSublayer:imageLayer];
    
    UIButton *weekButton = [UIButton buttonWithType:UIButtonTypeSystem];
    weekButton.frame = CGRectMake(140, 6, 120, 30);
    [weekButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    weekButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [weekButton setTitle:@"每周提醒" forState:UIControlStateNormal];
    weekButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    weekButton.contentEdgeInsets = UIEdgeInsetsMake(0,28, 0, 0);
    
    weekButton.tag = 31;
    [weekButton addTarget:self action:@selector(selectedButtonForRemindStyle:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:weekButton];
    
    CALayer *imageWeekLayer = [CALayer layer];
    imageWeekLayer.contents = (id)[UIImage imageNamed:@"select_none"].CGImage;
    imageWeekLayer.frame = CGRectMake(0, 5, 20, 20);
    [weekButton.layer addSublayer:imageWeekLayer];
    
    
    return footerView;
}

- (void)selectedButtonForRemindStyle:(UIButton *)sender
{
    if (_previousButton == sender) {
        return;
    }
    CALayer *layer = [sender.layer.sublayers lastObject];
    layer.contents = (id)[UIImage imageNamed:@"select"].CGImage;
    
    if (_previousButton != nil) {
        
        CALayer *previousLayer = [_previousButton.layer.sublayers lastObject];
        previousLayer.contents = (id)[UIImage imageNamed:@"select_none"].CGImage;
    }else{
        [self createDateButtonSuperview:sender.superview];
    }
    _previousButton = sender;
    
}

- (void)createDateButtonSuperview:(UIView *)footerView
{
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont systemFontOfSize:14];
    startButton.tag = 40;
    [startButton setTitle:@"点击选择开始日期" forState:UIControlStateNormal];
    startButton.frame = CGRectMake(20, 40, 200, 26);
    startButton.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    startButton.contentEdgeInsets = UIEdgeInsetsMake(0,8, 0, 0);
    startButton.layer.cornerRadius = 4;
    startButton.layer.borderColor = [UIColor grayColor].CGColor;
    startButton.layer.borderWidth = .5;
    [startButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:startButton];
    
    CALayer *accessoryLayer = [CALayer layer];
    accessoryLayer.frame = CGRectMake(startButton.frame.size.width - 23, 2, 23, 21);
    accessoryLayer.contents = (id)[UIImage imageNamed:@"week_right"].CGImage;
    accessoryLayer.transform = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
    [startButton.layer addSublayer:accessoryLayer];
    
    
    
    UIButton *endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    endButton.titleLabel.font = [UIFont systemFontOfSize:14];
    endButton.tag = 41;
    [endButton setTitle:@"点击选择结束日期" forState:UIControlStateNormal];
    endButton.frame = CGRectMake(20, 76, 200, 26);
    endButton.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    endButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    endButton.contentEdgeInsets = UIEdgeInsetsMake(0,8, 0, 0);
    endButton.layer.cornerRadius = 4;
    endButton.layer.borderColor = [UIColor grayColor].CGColor;
    endButton.layer.borderWidth = .5;
    [endButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:endButton];
    
    CALayer *accessoryEndLayer = [CALayer layer];
    accessoryEndLayer.frame = CGRectMake(endButton.frame.size.width - 23, 2, 23, 21);
    accessoryEndLayer.contents = (id)[UIImage imageNamed:@"week_right"].CGImage;
    accessoryEndLayer.transform = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
    [endButton.layer addSublayer:accessoryEndLayer];
}

- (void)chooseButtonClicked:(UIButton *)sender
{
    if (_datePicker == nil) {
        _datePicker = newDatePickerBox();
        [self.view addSubview:_datePicker];
    }
    UIDatePicker *datePicker = (UIDatePicker *)_datePicker.contentView;
    datePicker.minimumDate = [NSDate date];
    if (sender.tag == 40) {
        _datePicker.title = @"请选择开始日期";
    }else{
        _datePicker.title = @"请选择结束日期";
    }
    _datePicker.respBlock = ^(int index) {
        if (index == BTN_OK) {
            NSString* strDate = date2str(datePicker.date, DATE_FORMAT);
            [sender setTitle:strDate forState:UIControlStateNormal];
        }
    };
    [_datePicker show];
}

#pragma mark -- tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YZResourcesInfoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YZResourcesInfoDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.label_title.textColor = [UIColor blackColor];
        cell.label_title.frame = CGRectMake(7, 2, 110, 40);
        cell.label_detail.frame = CGRectMake(114, 4, kScreenWidth - 142, 36);
    }
    
    cell.label_title.text = _titleArray[indexPath.row];
    cell.label_detail.text = _dataArray[indexPath.row];
    return cell;
    
    
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
