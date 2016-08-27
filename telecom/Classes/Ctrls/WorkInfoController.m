//
//  WorkInfoController.m
//  telecom
//
//  Created by liuyong on 15/8/10.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "WorkInfoController.h"
#import "WorkTypeAndFaultSymModel.h"

@interface WorkInfoController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
}
@end

@implementation WorkInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择工种信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView.hidden = YES;
    _dataArray = [NSMutableArray array];
    
    [self addNavigationLeftButton];
    
    [self loadData];
}

- (void)loadData
{
    if ([self.nuId isEqualToString:@""]) return;
    
    httpGET2(@{URL_TYPE : @"Fault/GetKbWorkType" ,@"nuId" : self.nuId}, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]){
            [_dataArray removeAllObjects];
            for (NSDictionary *dict in result[@"list"]) {
                WorkTypeAndFaultSymModel *model = [[WorkTypeAndFaultSymModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
            [self.InfoTableView reloadData];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    
}

- (void)leftAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
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
    WorkTypeAndFaultSymModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.workTypeName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkTypeAndFaultSymModel *model = _dataArray[indexPath.row];
    if (self.delegate) {
        [self.delegate deliverWorkInfo:model.workTypeName workInfoId:model.workTypeId];
    }
    [self leftAction];
}

@end
