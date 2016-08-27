//
//  HangUpReasonView.m
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "HangUpReasonView.h"
#import "HangUpReasonModel.h"

@interface HangUpReasonView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UITableView *hangUpReasonTbView;

@property(nonatomic,strong)NSMutableArray *hangUpReasonArray;
@end

@implementation HangUpReasonView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.hangUpReasonArray = [NSMutableArray array];
        
        self.titleLabel = [MyUtil createLabel:RECT(8, 0, 165, 37) text:@"请选择挂起原因:" alignment:NSTextAlignmentLeft
                                    textColor:[UIColor blackColor]];
        [self addSubview:self.titleLabel];
        
        self.cancelBtn  = [MyUtil createBtnFrame:RECT(APP_W-60, 0, 50, 37) bgImage:nil image:nil title:@"取消" target:self action:@selector(cancelAction)];
        [self addSubview:self.cancelBtn];
        
        self.lineView = [[UIView alloc] initWithFrame:RECT(0, 37, APP_W, 2)];
        self.lineView.backgroundColor = [UIColor purpleColor];
        [self addSubview:self.lineView];
        
        self.hangUpReasonTbView = [[UITableView alloc] initWithFrame:RECT(0, 39, APP_W, self.frame.size.height-39) style:UITableViewStylePlain];
        self.hangUpReasonTbView.dataSource  = self;
        self.hangUpReasonTbView.delegate  = self;
        [self addSubview:self.hangUpReasonTbView];
    }
    return self;
}

- (void)loadDateWithURL:(NSString *)urlString
{
    httpGET2(@{URL_TYPE : urlString}, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            for (NSDictionary *dict in result[@"list"]) {
                HangUpReasonModel *model = [[HangUpReasonModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.hangUpReasonArray addObject:model];
            }
        }
        [self.hangUpReasonTbView reloadData];
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hangUpReasonArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"resue";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    HangUpReasonModel *model = self.hangUpReasonArray[indexPath.row];
    cell.textLabel.text = model.reason;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HangUpReasonModel *model = self.hangUpReasonArray[indexPath.row];
    if (self.delegate) {
        [self.delegate deliverHangUpReason:model.reason];
    }
    
    [self cancelAction];
}

- (void)cancelAction
{
    [UIView animateWithDuration:0.2f animations:^{
        CGRect tempFrame = self.frame;
        tempFrame.origin.y = APP_H;
        self.frame =  tempFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowing"];
    }];
}
@end
