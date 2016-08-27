//
//  ChooseCheckObjectView.m
//  telecom
//
//  Created by liuyong on 15/8/25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "ChooseCheckObjectView.h"
#import "CheckObjectModel.h"

@interface ChooseCheckObjectView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_optionTableView;
    NSMutableArray *_checkObjectArray;
}
@end

@implementation ChooseCheckObjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _checkObjectArray = [NSMutableArray array];
        
        _optionTableView = [[UITableView alloc] initWithFrame:RECT(0, 0, self.fw-20, self.fh) style:UITableViewStylePlain];
        _optionTableView.delegate = self;
        _optionTableView.dataSource = self;
        [self addSubview:_optionTableView];
        
    }
    return self;
}

- (void)loadDataWithURL:(NSString *)urlString workNo:(NSString *)workNo
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = urlString;
    paraDict[@"workNo"] = workNo;
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            [_checkObjectArray removeAllObjects];
            for (NSDictionary *dict in result[@"list"]) {
                CheckObjectModel *model = [[CheckObjectModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_checkObjectArray addObject:model];
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
    return _checkObjectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    CheckObjectModel *model = _checkObjectArray[indexPath.row];
    cell.textLabel.text = model.targetGroupName;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        CheckObjectModel *model = _checkObjectArray[indexPath.row];
        [self.delegate deliverCheckObjectChooseString:model.targetGroupName targetGroupId:model.targetGroupId];
    }
}

@end
