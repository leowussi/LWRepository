//
//  FixReasonViewController.m
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "FixReasonViewController.h"
#import "FixReasonModel.h"

@interface FixReasonViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *_selectBtn;
    NSInteger _selectNumber;
}
@property(nonatomic,strong)NSMutableArray *fixReasonArray;
@property(nonatomic,strong)NSMutableArray *wholeFixReasonArray;
@property(nonatomic,strong)UITableView *fixReasonTbView;
@end

@implementation FixReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修复原因";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fixReasonArray = [NSMutableArray array];
    self.wholeFixReasonArray = [NSMutableArray array];
    
    [self setUpRightBarButton];
    
//    [self setUpChooseTabBtn];
    
    [self setUpTbView];
    
    [self loadData];
}

#pragma mark - 右侧按钮
- (void)setUpRightBarButton
{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightBtn.frame = CGRectMake(APP_W-40, 7, 30, 30);
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_check@2x"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

- (void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)onNavBackTouched:(id)sender
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//        nil;
//    }];
//}

//- (void)setUpChooseTabBtn
//{
//    NSArray *tabBtnTitle = @[@"可选修复原因",@"全部修复原因"];
//    CGFloat width = APP_W / tabBtnTitle.count;
//    for (int i=0; i<tabBtnTitle.count; i++) {
//        UIButton *tabBtn = [MyUtil createBtnFrame:RECT(width *i, NAV_H+STATUS_H, width, 30) bgImage:nil image:nil title:tabBtnTitle[i] target:self action:@selector(selectFixReason:)];
//        [tabBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
//        [tabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [tabBtn setBackgroundColor:[UIColor grayColor]];
//        tabBtn.tag = 7777+i;
//        [self.view addSubview:tabBtn];
//    }
//    
//    UIButton *firstSelectBtn = (UIButton *)[self.view viewWithTag:7777];
//    [self selectFixReason:firstSelectBtn];
//}

- (void)loadData
{
    NSMutableDictionary *paraDict  = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = kGetVoiceResultList;
    paraDict[@"content"] = @"";//self.spec
    paraDict[@"functionId"] = self.functionId;
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            for (NSDictionary *dict in result[@"list"]) {
                FixReasonModel *model = [[FixReasonModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.wholeFixReasonArray addObject:model];
            }
        }
        [self.fixReasonTbView reloadData];
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

//- (void)selectFixReason:(UIButton *)btn
//{
//    [self.fixReasonArray removeAllObjects];
//    [self.wholeFixReasonArray removeAllObjects];
//    
//    _selectBtn.selected = NO;
//    btn.selected = YES;
//    _selectBtn = btn;
//    
//    NSInteger index = btn.tag - 7777;
//    _selectNumber = index;
//    
//    
//    if (_selectNumber == 0) {
//        NSMutableDictionary *paraDict  = [NSMutableDictionary dictionary];
//        paraDict[URL_TYPE] = kGetVoiceResultList;
//        paraDict[@"functionId"] = self.functionId;
//        paraDict[@"content"] = [self.voiceContent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        httpGET2(paraDict, ^(id result) {
//                       if ([result[@"result"] isEqualToString:@"0000000"]) {
//                           for (NSDictionary *dict in result[@"list"]) {
//                               FixReasonModel *model = [[FixReasonModel alloc] init];
//                               [model setValuesForKeysWithDictionary:dict];
//                               [self.fixReasonArray addObject:model];
//                           }
//                       }
//                       [self.fixReasonTbView reloadData];
//                   }, ^(id result) {
//                       showAlert(result[@"error"]);
//                   });
//    }
//    
//    if (_selectNumber == 1) {
////        NSMutableDictionary *paraDict  = [NSMutableDictionary dictionary];
////        paraDict[URL_TYPE] = kGetVoiceResultList;
////        paraDict[@"content"] = self.spec;
////        paraDict[@"functionId"] = self.functionId;
////        httpGET2(paraDict, ^(id result) {
////                       if ([result[@"result"] isEqualToString:@"0000000"]) {
////                           for (NSDictionary *dict in result[@"list"]) {
////                               FixReasonModel *model = [[FixReasonModel alloc] init];
////                               [model setValuesForKeysWithDictionary:dict];
////                               [self.wholeFixReasonArray addObject:model];
////                           }
////                       }
////                       [self.fixReasonTbView reloadData];
////                   }, ^(id result) {
////                       showAlert(result[@"error"]);
////                   });
//
//    }
//}

- (void)setUpTbView
{
    self.fixReasonTbView = [[UITableView alloc] initWithFrame:RECT(0, NAV_H+STATUS_H, APP_W, APP_H-NAV_H-30) style:UITableViewStylePlain];
    self.fixReasonTbView.dataSource = self;
    self.fixReasonTbView.delegate = self;
    [self.view addSubview:self.fixReasonTbView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_selectNumber == 0) {
//        return self.fixReasonArray.count;
//    }
//    
//    if (_selectNumber == 1) {
//        return self.wholeFixReasonArray.count;
//    }
//    return 0;
    
    return self.wholeFixReasonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_selectNumber == 0) {
//        static NSString *reuse = @"reuseCellOne";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
//        }
//        FixReasonModel *model = self.fixReasonArray[indexPath.row];
//        cell.textLabel.text  = model.resultContent;
//        cell.textLabel.adjustsFontSizeToFitWidth = YES;
//        return cell;
//    }else if (_selectNumber == 1){
        static NSString *reuse = @"reuseCellTwo";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        FixReasonModel *model = self.wholeFixReasonArray[indexPath.row];
        cell.textLabel.text  = model.resultContent;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        return cell;
//    }else{
//        return nil;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_selectNumber == 0) {
//        FixReasonModel *model = _fixReasonArray[indexPath.row];
//        if (self.delegate) {
//            [self.delegate deliverFixReason:model.resultContent];
//        }
//    }else if (_selectNumber == 1){
        FixReasonModel *model = _wholeFixReasonArray[indexPath.row];
        if (self.delegate) {
            [self.delegate deliverFixReason:model.resultContent];
        }
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
