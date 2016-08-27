//
//  OptionView.m
//  telecom
//
//  Created by liuyong on 15/8/3.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "OptionView.h"

#import "FixReasonModel.h"
#import "FixReasonCell.h"

@interface OptionView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_fixReasonOrWay;
    
    UIView *_iconView;
    
    UITableView *_optionTableView;
    
    NSMutableArray *_fixReasonArray;
    
}
@end

@implementation OptionView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        
        _fixReasonArray = [NSMutableArray array];
        
        if (title != nil) {
            _iconView = [[UIView alloc] initWithFrame:RECT(self.fx, 0, 5, 20)];
            _iconView.backgroundColor = RGBCOLOR(132, 214, 22);
            [self addSubview:_iconView];
            
            _titleLabel = [[UILabel alloc] initWithFrame:RECT(_iconView.ex+3, 0, self.fw-16, 20)];
            _titleLabel.text = [NSString stringWithFormat:@"  %@",title];
            _titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [_titleLabel setBackgroundColor:RGBCOLOR(235, 235, 235)];
            [self addSubview:_titleLabel];
            
            _optionTableView = [[UITableView alloc] initWithFrame:RECT(20, _titleLabel.ey, self.fw-20, self.fh-20) style:UITableViewStylePlain];
            _optionTableView.delegate = self;
            _optionTableView.dataSource = self;
            [self addSubview:_optionTableView];
        }
    }
    return self;
}

- (void)loadFixReasonsDataWithURL:(NSString *)url parameter:(NSString *)para functionId:(NSString *)functionId
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = url;
    paraDict[@"content"] = para;//self.spec
    paraDict[@"functionId"] = functionId;
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            [_fixReasonArray removeAllObjects];
            for (NSDictionary *dict in result[@"list"]) {
                FixReasonModel *model = [[FixReasonModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_fixReasonArray addObject:model];
            }
        }
        [_optionTableView reloadData];
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 43;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return _fixReasonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *reuseId = @"reuse";
        FixReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FixReasonCell" owner:self options:nil] firstObject];
        }
        FixReasonModel *model = _fixReasonArray[indexPath.row];
        [cell configWithModel:model];
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.delegate)  {
        FixReasonModel *model = _fixReasonArray[indexPath.row];
        [self.delegate deliverFixReason:model.resultContent];
    }
}

@end
