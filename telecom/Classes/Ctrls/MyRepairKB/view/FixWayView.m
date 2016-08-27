//
//  FixWayView.m
//  telecom
//
//  Created by liuyong on 15/8/18.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "FixWayView.h"
#import "FixWaysModel.h"

@interface FixWayView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_optionTableView;
    NSMutableArray *_fixWayArray;
}
@end

@implementation FixWayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _fixWayArray = [NSMutableArray array];
        
        _optionTableView = [[UITableView alloc] initWithFrame:RECT(0, 0, self.fw-20, self.fh) style:UITableViewStylePlain];
        _optionTableView.delegate = self;
        _optionTableView.dataSource = self;
        [self addSubview:_optionTableView];
        
    }
    return self;
}

- (void)loadFixWaysDataWithURL:(NSString *)urlString
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = urlString;
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            [_fixWayArray removeAllObjects];
            for (NSDictionary *dict in result[@"list"]) {
                FixWaysModel *model = [[FixWaysModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_fixWayArray addObject:model];
            }
        }
        [_optionTableView reloadData];
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fixWayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *reuseId = @"reuse";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        }
        FixWaysModel *model = _fixWayArray[indexPath.row];
        cell.textLabel.text = model.way;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        FixWaysModel *model = _fixWayArray[indexPath.row];
        [self.delegate deliverFixWay:model.way];
    }
}
@end
