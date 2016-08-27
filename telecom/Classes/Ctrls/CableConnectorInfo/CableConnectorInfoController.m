//
//  CableConnectorInfoController.m
//  telecom
//
//  Created by liuyong on 15/11/11.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "CableConnectorInfoController.h"
#import "PullTableView.h"
#import "CableConnectorInfoModel.h"
#import "CableInfoCell.h"
#import "PanelViewController.h"
#import "YZResourcesChangeViewController.h"

@interface CableConnectorInfoController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
{
    NSMutableArray *_cableInfoArray;
    PullTableView *_cableInfoTableView;
    NSInteger _curPage;
    NSInteger _pageSize;
    NSString *_condition;
    
    NSString *_loadWays;
}
@end

@implementation CableConnectorInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"光连接设备";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _curPage = 1;
    _pageSize = 20;
    _cableInfoArray = [NSMutableArray array];
    
    [self addNavigationLeftButton];
    
    [self setUpView];
    
    if (self.cableName != nil) {
        [self loadDataWithSearchCondition:self.cableName curPage:1 pageSize:20];
        UITextField *searchTextField = (UITextField *)[self.view viewWithTag:9990];
        searchTextField.text = self.cableName;
    }
}


-(void)setUpView
{
    UITextField *seaFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, 80, kScreenWidth-20, 28)];
    seaFiled.backgroundColor = [UIColor whiteColor];
    seaFiled.placeholder = @"请输入光交/光分/ODF名称";
    seaFiled.tag = 9990;
    seaFiled.font = [UIFont systemFontOfSize:13.0];
    seaFiled.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    seaFiled.layer.borderWidth = 0.6f;
    seaFiled.layer.cornerRadius = 14.0f;
    seaFiled.delegate = self;
    seaFiled.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:seaFiled];
    
    UIImage *btnImg = [UIImage imageNamed:@"2.9.png"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:btnImg forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(kScreenWidth-10-btnImg.size.width/2, 80, btnImg.size.width/2, btnImg.size.height/1.9)];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    UIImage *seaImg = [UIImage imageNamed:@"sea.png"];
    UIImageView *seaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, seaImg.size.width/2, seaImg.size.height/2)];
    seaImgView.image = seaImg;
    [searchBtn addSubview:seaImgView];

    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击示例：GJ00389" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.frame=RECT(0, CGRectGetMaxY(searchBtn.frame)+5, kScreenWidth, 20);
    [self.view addSubview:btn];
    
    
    _cableInfoTableView = [[PullTableView alloc] initWithFrame:RECT(seaFiled.fx, btn.ey+10, seaFiled.fw, APP_H-seaFiled.ey-10) style:UITableViewStylePlain];
    _cableInfoTableView.backgroundColor = [UIColor whiteColor];
    _cableInfoTableView.delegate = self;
    _cableInfoTableView.dataSource = self;
    _cableInfoTableView.pullDelegate = self;
    [self.view addSubview:_cableInfoTableView];
    _cableInfoTableView.hidden = YES;
    
    
    
}
-(void)btnClick:(UIButton *)btn{
    _loadWays = @"clickToSearch";
    _cableInfoTableView.hidden = NO;
    [self loadDataWithSearchCondition:@"GJ00389" curPage:_curPage pageSize:_pageSize];

    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformScale(btn.transform, 0, 20);
        _cableInfoTableView.transform = CGAffineTransformTranslate(_cableInfoTableView.transform, 0, -20);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [btn removeFromSuperview];
        });
    }];
}
- (void)searchBtnClick
{
    _loadWays = @"clickToSearch";
    _cableInfoTableView.hidden = NO;
    UITextField *searchTextField = (UITextField *)[self.view viewWithTag:9990];
    _condition = searchTextField.text;
    [searchTextField resignFirstResponder];
    if (![searchTextField.text isEqualToString:@""]) {
        [self loadDataWithSearchCondition:searchTextField.text curPage:_curPage pageSize:_pageSize];
    }else{
        showAlert(@"请输入搜索条件!");
        return;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _loadWays = @"clickToSearch";
    _cableInfoTableView.hidden = NO;
    [textField resignFirstResponder];
    if (![textField.text isEqualToString:@""]) {
        _condition = textField.text;
        [self loadDataWithSearchCondition:textField.text curPage:_curPage pageSize:_pageSize];
    }else{
        showAlert(@"请输入搜索条件!");
        return YES;
    }
    return YES;
}

#pragma mark - loadData
- (void)loadDataWithSearchCondition:(NSString *)condition curPage:(NSInteger)curPage pageSize:(NSInteger)pageSize
{
    
    if (condition == nil || [condition isEqualToString:@""]) {
        return;
    }
    NSMutableDictionary *paradict = [NSMutableDictionary dictionary];
    paradict[URL_TYPE] = kGetCableByName;
    paradict[@"name"] = condition;
    paradict[@"curPage"] = @(curPage);
    paradict[@"pageSize"] = @(pageSize);
    if ([_loadWays isEqualToString:@"clickToSearch"] || [_loadWays isEqualToString:@"refresh"]) {
        [_cableInfoArray removeAllObjects];
    }
    
    httpPOST(paradict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            for (NSDictionary *dict in result[@"list"]) {
                CableConnectorInfoModel *model = [[CableConnectorInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_cableInfoArray addObject:model];
            }
        }
        _cableInfoTableView.hidden = NO;
        [_cableInfoTableView reloadData];
    }, ^(id result) {
        [_cableInfoTableView reloadData];
    });
}

- (void)refreshDate
{
    if (_condition == nil || [_condition isEqualToString:@""]) {
        showAlert(@"请输入搜索条件!");
        return;
    }
    NSMutableDictionary *paradict = [NSMutableDictionary dictionary];
    paradict[URL_TYPE] = kGetCableByName;
    paradict[@"name"] = _condition;
    paradict[@"curPage"] = @(_curPage);
    paradict[@"pageSize"] = @(_pageSize);
    
    [_cableInfoArray removeAllObjects];
    httpGET2(paradict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            for (NSDictionary *dict in result[@"list"]) {
                CableConnectorInfoModel *model = [[CableConnectorInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_cableInfoArray addObject:model];
            }
        }
        [_cableInfoTableView reloadData];
    }, ^(id result) {
        [_cableInfoTableView reloadData];
    });
    _cableInfoTableView.pullTableIsRefreshing = NO;
}

- (void)loadMoreDate
{
    if (_condition == nil || [_condition isEqualToString:@""]) {
        return;
    }
    NSMutableDictionary *paradict = [NSMutableDictionary dictionary];
    paradict[URL_TYPE] = kGetCableByName;
    paradict[@"name"] = _condition;
    paradict[@"curPage"] = @(_curPage);
    paradict[@"pageSize"] = @(_pageSize);
    
    httpGET2(paradict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            if ([result[@"list"] count] == 0) {
                _curPage--;
            }
            for (NSDictionary *dict in result[@"list"]) {
                CableConnectorInfoModel *model = [[CableConnectorInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_cableInfoArray addObject:model];
            }
        }
        [_cableInfoTableView reloadData];
        
    }, ^(id result) {
        _curPage--;
        [_cableInfoTableView reloadData];
    });
    _cableInfoTableView.pullTableIsLoadingMore = NO;
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
    [self performSelector:@selector(refreshDate) withObject:nil afterDelay:3.0f];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cableInfoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"reuse";
    CableInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CableInfoCell" owner:self options:nil] firstObject];
    }
    CableConnectorInfoModel *model = _cableInfoArray[indexPath.row];
    [cell configCellWith:model];
    cell.jiaoZhengButton.tag = indexPath.row;
    [cell.jiaoZhengButton addTarget:self action:@selector(jiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CableConnectorInfoModel *model = _cableInfoArray[indexPath.row];
    PanelViewController *panelViewCtrl = [[PanelViewController alloc] init];
    panelViewCtrl.rackId = [NSString stringWithFormat:@"%d",model.rackId];
    panelViewCtrl.rackName = model.rackName;
    [self.navigationController pushViewController:panelViewCtrl animated:YES];
}

#pragma mark -- 校正按钮被点击
- (void)jiaoZhengButtonClicked:(UIButton *)sender
{
    NSLog(@"校正按钮被点击");
    YZResourcesChangeViewController *resourcesChangeVC = [[YZResourcesChangeViewController alloc] init];
    CableConnectorInfoModel *model = _cableInfoArray[sender.tag];
    resourcesChangeVC.resources_sceneId = @"3";
    resourcesChangeVC.resources_type = @"3-1";
    resourcesChangeVC.resources_id = [NSString stringWithFormat:@"%d",model.rackId];
    [self.navigationController pushViewController:resourcesChangeVC animated:YES];
    
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
