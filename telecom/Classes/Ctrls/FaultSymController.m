//
//  FaultSymController.m
//  telecom
//
//  Created by liuyong on 15/8/10.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "FaultSymController.h"
#import "WorkTypeAndFaultSymModel.h"


@interface FaultSymController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
}
@end

@implementation FaultSymController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"故障描述信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView.hidden = YES;
    
    _dataArray = [NSMutableArray array];
    
    [self addNavigationLeftButton];
    
    [self loadData];
}

- (void)leftAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData
{
    httpGET2(@{URL_TYPE : @"Fault/GetFaultSymptom",@"workTypeId" : self.workTypeId}, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            [_dataArray removeAllObjects];
            for (NSDictionary *dict in result[@"list"]) {
                FaultSymModel *model = [[FaultSymModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
            [self.faultSymTableView reloadData];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
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
    FaultSymModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.faultSymDes;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FaultSymModel *model = _dataArray[indexPath.row];
    if (self.delegate) {
        [self.delegate deliverFaultSymInfo:model.faultSymDes FaultSymInfoId:model.faultSymId];
    }
    [self leftAction];
}

@end
