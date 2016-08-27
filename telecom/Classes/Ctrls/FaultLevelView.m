//
//  FaultLevelView.m
//  telecom
//
//  Created by liuyong on 15/12/3.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "FaultLevelView.h"
#import "FaultLevelModel.h"

@interface FaultLevelView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_faultLevelTableView;
    NSMutableArray *_faultLevelArray;
}
@end

@implementation FaultLevelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _faultLevelArray = [NSMutableArray array];
        
        _faultLevelTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _faultLevelTableView.delegate = self;
        _faultLevelTableView.dataSource = self;
        [self addSubview:_faultLevelTableView];
    }
    return self;
}

- (void)loadDataWithURL:(NSString *)urlStr
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = urlStr;
    [_faultLevelArray removeAllObjects];
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            for (NSDictionary *dict in result[@"list"]) {
                FaultLevelModel *model = [[FaultLevelModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_faultLevelArray addObject:model];
            }
            [_faultLevelTableView reloadData];
        }
    }, ^(id result) {
        showLoading(result[@"error"]);
        [_faultLevelTableView reloadData];
    });
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"请选择故障等级";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
       return _faultLevelArray.count;
    }
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    FaultLevelModel *model = _faultLevelArray[indexPath.row];
    cell.textLabel.text = model.faultLevel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FaultLevelModel *model = _faultLevelArray[indexPath.row];
    if (self.delegate) {
        [self.delegate deliverFaultLevel:model.faultLevel faultLevelId:model.faultLevelId];
    }
}

@end
