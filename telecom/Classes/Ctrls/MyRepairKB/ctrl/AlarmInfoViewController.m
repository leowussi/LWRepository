//
//  AlarmInfoViewController.m
//  telecom
//
//  Created by liuyong on 9/14/15.
//  Copyright (c) 2015 ZhongYun. All rights reserved.
//

#import "AlarmInfoViewController.h"
#import "AlarmInfoModel.h"

@interface AlarmInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
}
@end

@implementation AlarmInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.type isEqualToString:@"关联资源"] ? @"关联资源" : @"网管告警";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addNavigationLeftButton];
    _dataArray  = [NSMutableArray array];
    
    [self.type isEqualToString:@"关联资源"] ?
    [self loadDataWithRequire:kGetFaultDeviceList] : [self loadDataWithRequire:kGetFaultAlarmList];
}

- (void)loadDataWithRequire:(NSString *)require
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = require;
    paraDict[@"faultNo"] = self.orderNo;
    httpGET2(paraDict, ^(id result) {
        
        [_dataArray removeAllObjects];
        
        for (NSDictionary *dict in result[@"list"]) {
            AlarmInfoModel *model = [[AlarmInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [_dataArray addObject:model];
            [self.infoTableView reloadData];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    AlarmInfoModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.content;
    return cell;
}


@end
