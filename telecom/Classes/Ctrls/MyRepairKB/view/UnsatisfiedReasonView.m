//
//  UnsatisfiedReasonView.m
//  telecom
//
//  Created by liuyong on 15/8/25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "UnsatisfiedReasonView.h"
#import "UnsatisfiedReasonModel.h"

@interface UnsatisfiedReasonView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_optionTableView;
    NSMutableArray *_unsatisfiedReasonArray;
}
@end

@implementation UnsatisfiedReasonView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _unsatisfiedReasonArray = [NSMutableArray array];
        
        _optionTableView = [[UITableView alloc] initWithFrame:RECT(0, 0, self.fw-20, self.fh) style:UITableViewStylePlain];
        _optionTableView.delegate = self;
        _optionTableView.dataSource = self;
        [self addSubview:_optionTableView];
        
    }
    return self;
}

- (void)loadDataWithURL:(NSString *)urlString
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = urlString;
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            [_unsatisfiedReasonArray removeAllObjects];
            for (NSDictionary *dict in result[@"list"]) {
                UnsatisfiedReasonModel *model = [[UnsatisfiedReasonModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_unsatisfiedReasonArray addObject:model];
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
    return _unsatisfiedReasonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    UnsatisfiedReasonModel *model = _unsatisfiedReasonArray[indexPath.row];
    cell.textLabel.text = model.reasonDes;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        UnsatisfiedReasonModel *model = _unsatisfiedReasonArray[indexPath.row];
        [self.delegate deliverUnsatisfiedReasonChooseString:model.reasonDes];
    }
}
@end
