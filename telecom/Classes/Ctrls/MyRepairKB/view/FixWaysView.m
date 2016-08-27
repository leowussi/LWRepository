//
//  FixWaysView.m
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "FixWaysView.h"
#import "FixWaysModel.h"

@interface FixWaysView ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UITableView *fixWaysTbView;

@property(nonatomic,strong)NSMutableArray *fixWaysArray;

@end

@implementation FixWaysView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.fixWaysArray = [NSMutableArray array];
        
        self.titleLabel = [MyUtil createLabel:RECT(8, 0, 165, 37) text:@"选择修复原因:" alignment:NSTextAlignmentLeft
                                    textColor:[UIColor blackColor]];
        [self addSubview:self.titleLabel];
        
        self.cancelBtn = [MyUtil createBtnFrame:RECT(APP_W-60, 0, 50, 37) bgImage:nil image:nil title:@"取消" target:self action:@selector(cancelAction)];
        [self addSubview:self.cancelBtn];
        
        self.lineView = [[UIView alloc] initWithFrame:RECT(0, 37, APP_W, 2)];
        self.lineView.backgroundColor = [UIColor purpleColor];
        [self addSubview:self.lineView];
        
        self.fixWaysTbView = [[UITableView alloc] initWithFrame:RECT(0, 39, APP_W, self.frame.size.height-39) style:UITableViewStylePlain];
        self.fixWaysTbView.delegate = self;
        self.fixWaysTbView.dataSource = self;
        [self addSubview:self.fixWaysTbView];
    }
    return self;
}

- (void)loadDataWithURL:(NSString *)urlString
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = urlString;
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            for (NSDictionary *dict in result[@"list"]) {
                FixWaysModel *model = [[FixWaysModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.fixWaysArray addObject:model];
            }
        }
        [self.fixWaysTbView reloadData];
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fixWaysArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"reuseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    FixWaysModel *model = self.fixWaysArray[indexPath.row];
    cell.textLabel.text  = model.way;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FixWaysModel *model = self.fixWaysArray[indexPath.row];
    if (self.delegate) {
        [self.delegate deliverFixWay:model.way];
    }
    
    [self cancelAction];
}

- (void)cancelAction
{
[UIView animateWithDuration:0.2f animations:^{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = APP_H;
    self.frame = tempFrame;
} completion:^(BOOL finished) {
    [self removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowing"];
}];
}

@end
