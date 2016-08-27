//
//  ZiChanShaiXuanViewController.m
//  telecom
//
//  Created by Sundear on 16/4/13.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "ZiChanShaiXuanViewController.h"
#import "IQKeyboardManager.h"

#import "MBProgressHUD+MJ.h"
@interface ZiChanShaiXuanViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSMutableDictionary *_dataDict;
    NSArray *_titleArray;
}
@end

@implementation ZiChanShaiXuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查询条件";
    [self createNavigationItems];
    [self loadLocalData];
    [self createTableView];
}

#pragma mark -- 创建导航条item
- (void)createNavigationItems
{
    UIImage* clearIcon = [UIImage imageNamed:@"nav_clear.png"];
    UIButton* clearBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-clearIcon.size.width), (NAV_H-clearIcon.size.height)/2,clearIcon.size.width, clearIcon.size.height)];
    [clearBtn setBackgroundImage:clearIcon forState:0];
    [clearBtn addTarget:self action:@selector(onClearBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem1 = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    UIButton* checkBtn = [[UIButton alloc] initWithFrame:clearBtn.frame];
    checkBtn.fx = clearBtn.fx - 10 - checkIcon.size.width;
    [checkBtn setBackgroundImage:checkIcon forState:0];
    [checkBtn addTarget:self action:@selector(onCheckBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem2 = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItems = @[barBtnItem1,barBtnItem2];
}

//清除
- (void)onClearBtnTouched
{
    [_dataDict removeAllObjects];
    [_tableView reloadData];
}

//提交
- (void)onCheckBtnTouched
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setObject:_dataDict forKey:@"SearchAssetSummary"];
    _block();
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 创建tableView
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark --- table代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(120, 8, kScreenWidth - 130, 28)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:textField];
        
    }
    
    cell.textLabel.text = _titleArray[indexPath.row];

    for (UITextField *textField in cell.contentView.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.tag = indexPath.row;
            textField.text = [_dataDict objectForKey:[NSString stringWithFormat:@"asset%d",indexPath.row]];
            break;
        }
    }
    
    return cell;
}

#pragma mark -- 加载本地数据创建数据源
- (void)loadLocalData
{
    _titleArray = [NSArray arrayWithObjects:@"资产描述",@"实物ID",@"地址",@"备注",@"类项目节",@"规格型号", nil];
    NSMutableDictionary *dataDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchAssetSummary"];
    if (dataDict == nil) {
        _dataDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }else {
        _dataDict = [[NSMutableDictionary alloc] initWithDictionary:dataDict];
    }
    
}

#pragma mark -- textField代理
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:7];
    
    CGRect rect = _tableView.frame;
    rect.size.height -= 297;
    _tableView.frame = rect;
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:7];
    
    CGRect rect = _tableView.frame;
    rect.size.height += 297;
    _tableView.frame = rect;
    [UIView commitAnimations];
    
    [_dataDict setObject:textField.text forKey:[NSString stringWithFormat:@"asset%d",textField.tag]];
}

@end
