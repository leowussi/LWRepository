//
//  EnergyUsingViewController.m
//  telecom
//
//  Created by liuyong on 15/12/1.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "EnergyUsingViewController.h"
#import "CustomDatePickerView.h"
#import "PullTableView.h"
#import "EnergyUsingModel.h"
#import "EnergyUsingCell.h"

@interface EnergyUsingViewController ()<UITextFieldDelegate,CustomDatePickerViewDelegate,UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
{
    CustomDatePickerView *_customDatePickerView;
    UIButton *_dateChooseBtn;
    BOOL _isShow;
    NSInteger _curPage;
    NSInteger _pageSize;
    NSString *_condition;
    NSString *_loadWays;
    NSString *_startDate;
    
    NSMutableArray *_dataArray;
    PullTableView *_energyUsingTableView;
}
@end

@implementation EnergyUsingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"能耗划小查询";
    self.view.backgroundColor = [UIColor whiteColor];
    _isShow = NO;
    _curPage = 1;
    _pageSize = 20;
    _startDate = date2str([NSDate date], @"YYYY.MM");
    _dataArray = [NSMutableArray array];
    _condition = @"";
    
    [self addNavigationLeftButton];
    
    [self setUpView];
    
    [self setUpTableView];
    
    [self loadDataWithoutStationNameOfCurPage:_curPage pageSize:_pageSize];
}

- (void)setUpView
{
    _dateChooseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _dateChooseBtn.frame = CGRectMake(10, 80, 50, 28);
    _dateChooseBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _dateChooseBtn.layer.cornerRadius = 1;
    _dateChooseBtn.layer.borderWidth = 0.5f;
    [_dateChooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _dateChooseBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    NSString *dateStr = date2str([NSDate date], @"YYYY-MM");
    [_dateChooseBtn setTitle:dateStr forState:UIControlStateNormal];
    [_dateChooseBtn addTarget:self action:@selector(chooseDateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dateChooseBtn];
    
    UIImage *btnImg = [UIImage imageNamed:@"search_btn_bg.png"];
    UITextField *seaFiled = [[UITextField alloc]initWithFrame:CGRectMake(_dateChooseBtn.ex+10, 80, APP_W-30-_dateChooseBtn.fw-btnImg.size.width/2, 28)];
    seaFiled.tag = 8000;
    seaFiled.backgroundColor = [UIColor whiteColor];
    seaFiled.placeholder = @"请输入站点名称";
    seaFiled.font = [UIFont systemFontOfSize:13.0];
    seaFiled.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    seaFiled.layer.borderWidth = 0.4f;
    seaFiled.borderStyle = UITextBorderStyleNone;
    seaFiled.delegate = self;
    seaFiled.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:seaFiled];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:btnImg forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(seaFiled.ex, seaFiled.fy,btnImg.size.width/2, seaFiled.fh)];
    [searchBtn setImage:btnImg forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
}

- (void)setUpTableView
{
    _energyUsingTableView = [[PullTableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_dateChooseBtn.frame)+5, APP_W-20, APP_H-CGRectGetMaxY(_dateChooseBtn.frame)+5) style:UITableViewStylePlain];
    _energyUsingTableView.delegate = self;
    _energyUsingTableView.dataSource = self;
    _energyUsingTableView.pullDelegate = self;
    [self.view addSubview:_energyUsingTableView];
    _energyUsingTableView.hidden = YES;
}

#pragma mark - loadData
- (void)loadDataWithoutStationNameOfCurPage:(NSInteger)curPage pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *paradict = [NSMutableDictionary dictionary];
    paradict[URL_TYPE] = kGetEnergyCount;
    paradict[@"statDate"] = _startDate;
    paradict[@"type"] = self.type;
    paradict[@"curPage"] = @(curPage);
    paradict[@"pageSize"] = @(pageSize);
    if ([_loadWays isEqualToString:@"clickToSearch"] || [_loadWays isEqualToString:@"refresh"]) {
        [_dataArray removeAllObjects];
    }
    
    httpPOST(paradict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            for (NSDictionary *dict in result[@"list"]) {
                EnergyUsingModel *model = [[EnergyUsingModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
        }
        _energyUsingTableView.hidden = NO;
        [_energyUsingTableView reloadData];
    }, ^(id result) {
        [_energyUsingTableView reloadData];
    });
}

#pragma mark - loadData
- (void)loadDataWithStationNameOfCurPage:(NSInteger)curPage pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *paradict = [NSMutableDictionary dictionary];
    paradict[URL_TYPE] = kGetEnergyCount;
    paradict[@"stationName"] = _condition;
    paradict[@"statDate"] = _startDate;
    paradict[@"type"] = self.type;
    paradict[@"curPage"] = @(curPage);
    paradict[@"pageSize"] = @(pageSize);
    if ([_loadWays isEqualToString:@"clickToSearch"] || [_loadWays isEqualToString:@"refresh"]) {
        [_dataArray removeAllObjects];
    }
    
    httpPOST(paradict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            for (NSDictionary *dict in result[@"list"]) {
                EnergyUsingModel *model = [[EnergyUsingModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
        }
        _energyUsingTableView.hidden = NO;
        [_energyUsingTableView reloadData];
    }, ^(id result) {
        [_energyUsingTableView reloadData];
    });
}

- (void)refreshData
{
    //    if (_condition == nil || [_condition isEqualToString:@""]) {
    //        showAlert(@"请输入搜索条件!");
    //        return;
    //    }
    //    NSMutableDictionary *paradict = [NSMutableDictionary dictionary];
    //    paradict[URL_TYPE] = kGetEnergyCount;
    //    paradict[@"stationName"] = _condition;
    //    paradict[@"statDate"] = _startDate;
    //    paradict[@"type"] = self.type;
    //    paradict[@"curPage"] = @(_curPage);
    //    paradict[@"pageSize"] = @(_pageSize);
    //
    //    [_dataArray removeAllObjects];
    //    httpGET2(paradict, ^(id result) {
    //        if ([result[@"result"] isEqualToString:@"0000000"]) {
    //            for (NSDictionary *dict in result[@"list"]) {
    //                EnergyUsingModel *model = [[EnergyUsingModel alloc] init];
    //                [model setValuesForKeysWithDictionary:dict];
    //                [_dataArray addObject:model];
    //            }
    //        }
    //        [_energyUsingTableView reloadData];
    //    }, ^(id result) {
    //        [_energyUsingTableView reloadData];
    //    });
    [self searchBtnClick];
    _energyUsingTableView.pullTableIsRefreshing = NO;
}

- (void)loadMoreDate
{
    //    if (_condition == nil || [_condition isEqualToString:@""]) {
    //        showAlert(@"请输入搜索条件!");
    //        return;
    //    }
    NSMutableDictionary *paradict = [NSMutableDictionary dictionary];
    paradict[URL_TYPE] = kGetEnergyCount;
    paradict[@"stationName"] = _condition;
    paradict[@"statDate"] = _startDate;
    paradict[@"type"] = self.type;
    paradict[@"curPage"] = @(_curPage);
    paradict[@"pageSize"] = @(_pageSize);
    
    httpGET2(paradict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            for (NSDictionary *dict in result[@"list"]) {
                EnergyUsingModel *model = [[EnergyUsingModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
        }
        [_energyUsingTableView reloadData];
    }, ^(id result) {
        [_energyUsingTableView reloadData];
    });
    
    _energyUsingTableView.pullTableIsLoadingMore = NO;
}

- (void)chooseDateAction
{
    if (_isShow == NO) {
        _customDatePickerView = [[CustomDatePickerView alloc] initWithFrame:CGRectMake(20, 150, 280, 247)];
        _customDatePickerView.delegate = self;
        [self.view addSubview:_customDatePickerView];
        _isShow = YES;
    }
}

#pragma mark - CustomDatePickerViewDelegate
- (void)cancleBtnClick
{
    [_customDatePickerView removeFromSuperview];
    _isShow = NO;
}

- (void)deliverDateWith:(NSString *)date
{
    _startDate = date;
    [_customDatePickerView removeFromSuperview];
    _isShow = NO;
    [_dateChooseBtn setTitle:date forState:UIControlStateNormal];
}

- (void)searchBtnClick
{
    _loadWays = @"clickToSearch";
    _curPage = 1;
    _energyUsingTableView.hidden = NO;
    UITextField *searchTextField = (UITextField *)[self.view viewWithTag:8000];
    _condition = searchTextField.text;
    [searchTextField resignFirstResponder];
    //    if (![searchTextField.text isEqualToString:@""]) {
    //        [self loadDataWithSearchCondition:searchTextField.text curPage:_curPage pageSize:_pageSize];
    [self loadDataWithStationNameOfCurPage:_curPage pageSize:_pageSize];
    //    }else{
    //        showAlert(@"请输入搜索条件!");
    //        return;
    //    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _loadWays = @"clickToSearch";
    _curPage = 1;
    _energyUsingTableView.hidden = NO;
    [textField resignFirstResponder];
    //    if (![textField.text isEqualToString:@""]) {
    _condition = textField.text;
    [self loadDataWithStationNameOfCurPage:_curPage pageSize:_pageSize];
    //    }else{
    //        showAlert(@"请输入搜索条件!");
    //        return YES;
    //    }
    return YES;
}

#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    _curPage++;
    [self performSelector:@selector(loadMoreDate) withObject:nil afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    _curPage = 1;
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:3.0f];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"reuse";
    EnergyUsingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EnergyUsingCell" owner:self options:nil] firstObject];
    }
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:229/255.0f green:249/255.0f blue:249/255.0f alpha:1.0f];
    }
    EnergyUsingModel *model = _dataArray[indexPath.row];
    [cell configWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}


#pragma mark - addNavigationLeftButton
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0,0,44,44);
    [leftButton setImage:[navImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
