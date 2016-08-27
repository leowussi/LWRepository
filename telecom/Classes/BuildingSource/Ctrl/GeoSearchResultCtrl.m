//
//  GeoSearchResultCtrl.m
//  telecom
//
//  Created by liuyong on 16/3/7.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "GeoSearchResultCtrl.h"

@interface GeoSearchResultCtrl ()<UITextFieldDelegate,BMKPoiSearchDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BMKPoiSearch* _poisearch;
    NSMutableArray *_dataArray;
    int _curPage;
}
@end

@implementation GeoSearchResultCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImage *searchImg = [UIImage imageNamed:@"search_bg.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, kScreenWidth-120, searchImg.size.height/3+5)];
    searchImgView.image = searchImg;
    searchImgView.userInteractionEnabled = YES;
    
    UITextField *searchField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-125, searchImg.size.height/3+5)];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.placeholder = @"搜索地址点";
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    searchField.textColor = [UIColor whiteColor];
    searchField.delegate = self;
    searchField.enablesReturnKeyAutomatically = YES;
    searchField.font = [UIFont systemFontOfSize:15.0];
    [searchImgView addSubview:searchField];
    
    self.navigationItem.titleView = searchImgView;
    
    [self addNavigationLeftButton];
    
    _poisearch = [[BMKPoiSearch alloc] init];
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击示例：国际客运中心" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.frame=RECT(0, 64, kScreenWidth, 20);
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
}

-(void)btnClick:(UIButton *)btn{
    [self starJianSuo:@"国际客运中心"];
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformScale(btn.transform, 0, 20);
        
        [btn removeFromSuperview];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    BMKPoiInfo *info = _dataArray[indexPath.row];
    cell.textLabel.text = info.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *info = _dataArray[indexPath.row];
    if (self.delegate) {
        [self.delegate deliverPoiInfo:info];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - searchAction
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self starJianSuo:textField.text];
    
    return YES;
}
-(void)starJianSuo:(NSString *)string{
    _curPage = 0;
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = _curPage;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= @"上海";
    citySearchOption.keyword = string;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    
    
    if(flag)
    {
        //        _nextPageButton.enabled = true;
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        //        _nextPageButton.enabled = false;
        NSLog(@"城市内检索发送失败");
    }
}
- (void)onClickNextPage
{
    _curPage++;
    //城市内检索，请求发送成功返回YES，请求发送失败返回NO
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = _curPage;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= @"上海";
    citySearchOption.keyword = @"";
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    
    if(flag)
    {
//        _nextPageButton.enabled = true;
        NSLog(@"城市内检索发送成功");
    }
    else
    {
//        _nextPageButton.enabled = false;
        NSLog(@"城市内检索发送失败");
    }
}

#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"poiInfoList-%@",result.poiInfoList);
    NSLog(@"poiAddressInfoList-%@",result.poiAddressInfoList);
    
    _dataArray = (NSMutableArray *)result.poiInfoList;
    
    [self.resultTableView reloadData];
    for (BMKPoiInfo *info in result.poiInfoList) {
        NSLog(@"info.address-%@,info.name-%@",info.address,info.name);
    }
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

- (void)viewWillAppear:(BOOL)animated
{
    _poisearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    _poisearch.delegate = nil;
}

- (void)dealloc {
    if (_poisearch != nil) {
        _poisearch = nil;
    }
}

@end
