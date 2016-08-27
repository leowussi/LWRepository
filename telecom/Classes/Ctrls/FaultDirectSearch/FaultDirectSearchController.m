//
//  FaultDirectSearchController.m
//  telecom
//
//  Created by liuyong on 15/10/22.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "FaultDirectSearchController.h"
#import "FaultInfoModel.h"
#import "FaultInfoCell.h"
#import "FaultTrackViewController.h"
#import "MJExtension.h"

@interface FaultDirectSearchController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,FaultInfoCellDelegate>
{
    UITableView *_faultListTableView;
    NSMutableArray *_faultListDataArray;
    
    NSString *_searchCondition;
}
@end

@implementation FaultDirectSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"故障直查";
    self.view.backgroundColor = RGBCOLOR(249, 249, 249);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _faultListDataArray = [NSMutableArray array];
    
    [self addNavigationLeftButton];
    
    [self setUpView];
}

-(void)setUpView
{
    UITextField *seaFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, 80, kScreenWidth-20, 28)];
    seaFiled.backgroundColor = [UIColor whiteColor];
    seaFiled.placeholder = @"请输入网故编号后六位";
    seaFiled.tag = 9990;
    seaFiled.font = [UIFont systemFontOfSize:13.0];
    seaFiled.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    seaFiled.layer.borderWidth = 0.6f;
    seaFiled.layer.cornerRadius = 14.0f;
    seaFiled.delegate = self;
    seaFiled.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:seaFiled];
    
    UIImage *btnImg = [UIImage imageNamed:@"2.9.png"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:btnImg forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(kScreenWidth-10-btnImg.size.width/2, 80, btnImg.size.width/2, btnImg.size.height/1.9)];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    UIImage *seaImg = [UIImage imageNamed:@"sea.png"];
    UIImageView *seaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, seaImg.size.width/2, seaImg.size.height/2)];
    seaImgView.image = seaImg;
    [searchBtn addSubview:seaImgView];
    
    UILabel *attentionInfo = [[UILabel alloc] initWithFrame:CGRectMake(seaFiled.fx, seaFiled.ey, seaFiled.fw, 30)];
    attentionInfo.text = @"注意：三日内的故障单可输入故障单编号后六位，如果想查历史的请输入完整的故障单编号。";
    attentionInfo.font = [UIFont systemFontOfSize:11.0f];
    attentionInfo.numberOfLines = 2;
    [self.view addSubview:attentionInfo];
    
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击示例：20160303029745" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.frame=RECT(0, attentionInfo.ey+5, kScreenWidth, 20);
    [self.view addSubview:btn];
    
    
    
    
    _faultListTableView = [[UITableView alloc] initWithFrame:RECT(seaFiled.fx,btn.ey+10, seaFiled.fw, APP_H-seaFiled.ey-10-28-5) style:UITableViewStylePlain];
    _faultListTableView.backgroundColor = [UIColor whiteColor];
    _faultListTableView.delegate = self;
    _faultListTableView.dataSource = self;
    [self.view addSubview:_faultListTableView];
    _faultListTableView.hidden = YES;
}
-(void)btnClick:(UIButton *)btn{
    [self loadDataWithCondition:@"20160303029745"];
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformScale(btn.transform, 0, 20);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [btn removeFromSuperview];
        });
        _faultListTableView.transform =CGAffineTransformTranslate(_faultListTableView.transform, 0, -20) ;
    }];
}
- (void)searchBtnClick
{
    _faultListTableView.hidden = NO;
    
    UITextField *searchTextField = (UITextField *)[self.view viewWithTag:9990];
    [searchTextField resignFirstResponder];
    if (![searchTextField.text isEqualToString:@""]) {
         _searchCondition = searchTextField.text;
    }else{
        showAlert(@"请输入网故编号后六位!");
        return;
    }
   
    [self loadDataWithCondition:_searchCondition];
}

- (void)loadDataWithCondition:(NSString *)condition
{   _faultListTableView.hidden = NO;
    if ((condition.length > 6 && condition.length < 14) || (condition.length > 14)) {
        showAlert(@"请输入网故编号后六位!");
        return;
    }
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = kSearchFaultOfLeader;
    paraDict[@"condition"] = condition;
    httpGET2(paraDict, ^(id result) {
        NSLog(@"%@",result);
        [_faultListDataArray removeAllObjects];
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            for (NSDictionary *dict in result[@"list"]) {
                FaultInfoModel *faultInfoModel = [[FaultInfoModel alloc] init];
                [faultInfoModel setValuesForKeysWithDictionary:dict];
                
                NSMutableArray *tempArr = [NSMutableArray array];
                faultInfoModel.transList = tempArr;
                
                for (NSDictionary *subDict in dict[@"transList"]) {
                    TranslistInfoModel *translistInfoModel = [[TranslistInfoModel alloc] init];
                    [translistInfoModel setValuesForKeysWithDictionary:subDict];
                    [tempArr addObject:translistInfoModel];
                }
                
                [_faultListDataArray addObject:faultInfoModel];
            }
            [_faultListTableView reloadData];
        }
    }, ^(id result) {
        [_faultListDataArray removeAllObjects];
        [_faultListTableView reloadData];
//        showAlert(result[@"error"]);
        return;
    });
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _faultListDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"reuse";
    FaultInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FaultInfoCell" owner:self options:nil] firstObject];
        cell.delegate = self;
    }
    FaultInfoModel *model = _faultListDataArray[indexPath.row];
    [cell configFaultInfoCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FaultTrackViewController *faultTrackCtrl = [[FaultTrackViewController alloc] init];
    FaultInfoModel *faultInfoModel = _faultListDataArray[indexPath.row];
    faultTrackCtrl.workNum = faultInfoModel.workNo;
    NSMutableDictionary *faultInfoDict = faultInfoModel.keyValues;
    faultTrackCtrl.workInfo = faultInfoDict;
    [self.navigationController pushViewController:faultTrackCtrl animated:YES];
}

- (void)showSharePersonInfoWith:(UITapGestureRecognizer *)ges
{
    NSIndexPath *indexPath = [_faultListTableView indexPathForRowAtPoint:[ges locationInView:_faultListTableView]];
    FaultInfoModel *model = _faultListDataArray[indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前共享人员"
                                                    message:model.sharedUser
                                                   delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    _faultListTableView.hidden = NO;
    
    if (![textField.text isEqualToString:@""]) {
        [self loadDataWithCondition:textField.text];
    }else{
        showAlert(@"请输入网故编号后六位!");
        return YES;
    }
    
    return YES;
}

#pragma mark - addNavigationLeftButton
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0,0,44,44);
    [leftButton setImage:[navImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
