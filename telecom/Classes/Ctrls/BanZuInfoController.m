//
//  BanZuInfoController.m
//  telecom
//
//  Created by liuyong on 15/7/16.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BanZuInfoController.h"
#import "BanZuInfoModel.h"
@interface BanZuInfoController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
}
@end

@implementation BanZuInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"班组信息";
    _dataArray = [NSMutableArray array];

    _baseScrollView.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadData];
}

- (void)loadData
{
    httpGET2(@{URL_TYPE : @"MyTask/WithWork/GetTaskTeamInfo"}, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            for (NSDictionary *dict in result[@"list"]) {
                BanZuInfoModel *model = [[BanZuInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
            [self.banZuInfoTableView reloadData];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    BanZuInfoModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.teamName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BanZuInfoModel *model = _dataArray[indexPath.row];
    if (self.delegate) {
        [self.delegate deliverBanZuInfo:model.teamName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
