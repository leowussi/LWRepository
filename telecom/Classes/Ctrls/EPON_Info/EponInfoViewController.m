//
//  EponInfoViewController.m
//  telecom
//
//  Created by liuyong on 15/10/19.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "EponInfoViewController.h"
#import "ListButton.h"

#import "EponInfoModelOLT.h"
#import "EponInfoModelOBD.h"
#import "EponInfoModelONU.h"
#import "BottomListModel.h"
#import "UpperListModel.h"

#import "EponInfoCellOLT.h"
#import "EponInfoCellOBD.h"
#import "EponInfoCellONU.h"

#import "LinkingSetsInfoView.h"
#import "CableConnectorInfoController.h"


@interface EponInfoViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,EponInfoCellOBDDelegate,EponInfoCellOLTDelegate,EponInfoCellONUDelegate,LinkingSetsInfoViewDelegate>
{
    NSMutableArray *_eponInfo;
    
    UITableView *_eponInfoTV;
    NSString *_equipKind;
    NSString *_equipCode;
    BOOL _isKindViewHidden;
    NSString *_searchStr;
    BOOL _isBottomSetsViewHidden;
    BOOL _isUpperSetsViewHidden;
    UIButton *selectbtn;
    LinkingSetsInfoView *_linkSetsView;
}
@end

@implementation EponInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"EPON信息查询";
    self.view.backgroundColor = RGBCOLOR(249, 249, 249);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _eponInfo = [NSMutableArray array];
    _isKindViewHidden = YES;
    _isBottomSetsViewHidden = YES;
    _isUpperSetsViewHidden = YES;
    
    _equipKind = @"1";
    
    [self addNavigationLeftButton];
    
    [self setUpSearchBar];
    
    [self setUpTV];
}

- (void)setUpTV
{
    _eponInfoTV = [[UITableView alloc] initWithFrame:RECT(10, 143, APP_W-20, APP_H-98) style:UITableViewStylePlain];
    _eponInfoTV.delegate = self;
    _eponInfoTV.dataSource = self;
    _eponInfoTV.allowsSelection = NO;
    [self.view addSubview:_eponInfoTV];
}

- (void)setUpSearchBar
{
    ListButton *listBtn = [[ListButton alloc] initWithFrame:RECT(10, 80, 52, 28)];
    listBtn.tag = 9000;
    [listBtn setTitle:@"  OLT" forState:UIControlStateNormal];
    listBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [listBtn setImage:[UIImage imageNamed:@"arr_down.png"] forState:UIControlStateNormal];
    listBtn.imageView.backgroundColor = [UIColor grayColor];
    [listBtn addTarget:self action:@selector(selectKind) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listBtn];
    
    UIImage *btnImg = [UIImage imageNamed:@"search_btn_bg.png"];
    
    UITextField *seaFiled = [[UITextField alloc]initWithFrame:CGRectMake(listBtn.ex+10, 80, APP_W-30-listBtn.fw-btnImg.size.width/2, 28)];
    seaFiled.tag = 8000;
    seaFiled.backgroundColor = [UIColor whiteColor];
    seaFiled.placeholder = @"请输入OLT/OBD/ONU设备编码";
    seaFiled.font = [UIFont systemFontOfSize:13.0];
    seaFiled.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    seaFiled.layer.borderWidth = 0.4f;
    seaFiled.borderStyle = UITextBorderStyleNone;
    seaFiled.delegate = self;
    seaFiled.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:seaFiled];
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:btnImg forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(seaFiled.ex, seaFiled.fy,btnImg.size.width/2, seaFiled.fh)];
    [searchBtn setImage:btnImg forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    
    selectbtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [selectbtn setTitle:@"点击示例：C220" forState:UIControlStateNormal];
    [selectbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    selectbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [selectbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    selectbtn.frame=RECT(0, CGRectGetMaxY(searchBtn.frame)+5, kScreenWidth, 20);
    [self.view addSubview:selectbtn];
}

-(void)btnClick:(UIButton *)Btn{
    if ([_equipKind isEqualToString:@"1"]) {
        _searchStr=@"C220";
    }
    [self searchEponInfoWithEquipCode:_searchStr equipKind:_equipKind flag:@"1"];
    
    [UIView animateWithDuration:0.25 animations:^{
        selectbtn.transform = CGAffineTransformScale(selectbtn.transform, 0, 20);

        _eponInfoTV.transform =CGAffineTransformTranslate(_eponInfoTV.transform, 0, -20) ;
    }];
}

- (void)selectKind
{
    NSArray *kindArray = @[@"OLT",@"OBD",@"ONU"];
    
    if (_isKindViewHidden) {
        
        UIView *kindView = [[UIView alloc] initWithFrame:RECT(10, 108+1.5, 50, 75)];
        kindView.layer.cornerRadius = 2.0f;
        kindView.layer.borderWidth = 0.5f;
        kindView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
        kindView.tag = 11111;
        [self.view addSubview:kindView];
        
        for (int i=0; i<kindArray.count; i++) {
            UIButton *entrancesBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            entrancesBtn.frame = CGRectMake(0, 24*i, 50, 24);
            [entrancesBtn setTitle:kindArray[i] forState:UIControlStateNormal];
            [entrancesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [entrancesBtn addTarget:self action:@selector(chooseKindAction:) forControlEvents:UIControlEventTouchUpInside];
            entrancesBtn.tag = 7000+i;
            [kindView addSubview:entrancesBtn];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 24+(25*i), 50, 1)];
            lineView.backgroundColor = [UIColor grayColor];
            [kindView addSubview:lineView];
//            if (i==0) {
//                [self chooseKindAction:entrancesBtn];
//            }
            _isKindViewHidden = NO;
        }
    }else{
        UIView *kindView = [self.view viewWithTag:11111];
        [kindView removeFromSuperview];
        kindView = nil;
        _isKindViewHidden = YES;
    }
}

- (void)chooseKindAction:(UIButton *)btn
{
    _eponInfoTV.transform = CGAffineTransformIdentity;
    selectbtn.transform = CGAffineTransformIdentity;
    ListButton *listBtn = (ListButton *)[self.view viewWithTag:9000];
    [listBtn setTitle:[NSString stringWithFormat:@"  %@",btn.titleLabel.text] forState:UIControlStateNormal];
    NSInteger index = btn.tag-7000;
    if (index == 0) {
        _equipKind = @"1";
        [selectbtn setTitle:@"点击示例：C220" forState:UIControlStateNormal];
        _searchStr = @"C220";
    }else if (index == 1){
        _equipKind = @"2";
        [selectbtn setTitle:@"点击示例:00389" forState:UIControlStateNormal];
        _searchStr = @"00389";
    }else if(index == 2){
        _equipKind = @"3";
        [selectbtn setTitle:@"点击示例：000738" forState:UIControlStateNormal];
        _searchStr = @"000738";
    }
    UIView *kindView = [self.view viewWithTag:11111];
    [kindView removeFromSuperview];
    kindView = nil;
    _isKindViewHidden = YES;
}

- (void)searchAction
{
    self.flag = @"1";
    UITextField *textField = (UITextField *)[self.view viewWithTag:8000];
    [textField resignFirstResponder];
    _equipCode = textField.text;
    
    [self searchEponInfoWithEquipCode:_equipCode equipKind:_equipKind flag:self.flag];
}

#pragma mark - searchAction
- (void)searchEponInfoWithEquipCode:(NSString *)equipCode equipKind:(NSString *)equipKind flag:(NSString *)flag
{
    
    if ([equipKind isEqualToString:@"1"]) {
        if (equipCode.length<4) {
            showAlert(@"请输入至少四位数字或英文字符!");
            return;
        }
    }
    
    if ([equipKind isEqualToString:@"2"]) {
        if (equipCode.length<5) {
            showAlert(@"请输入至少五位数字或英文字符!");
            return;
        }
    }
    
    if ([equipKind isEqualToString:@"3"]) {
        if (equipCode.length<6) {
            showAlert(@"请输入至少六位数字或英文字符!");
            return;
        }
    }
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = kSearchEponInfo;
    paraDict[@"kind"] = equipKind;
    paraDict[@"equipCode"] = equipCode;
    if (flag != nil) {
        paraDict[@"fromFlag"] = flag;
    }
    httpGET2(paraDict, ^(id result) {
        [_eponInfo removeAllObjects];
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            //OLT：1   OBD：2  ONU：3
            
            NSString *kind = [result[@"list"] firstObject][@"kind"];
            NSString *searchResult = [result[@"list"] firstObject][@"searchResult"];
            if ([searchResult isEqualToString:@"1"]) {
                [self showAlertMessage];
            }
            if ([kind  isEqualToString: @"1"]) {
                _equipKind = kind;
                for (NSDictionary *dict in result[@"list"]) {
                    EponInfoModelOLT *eponModel = [[EponInfoModelOLT alloc] init];
                    [eponModel setValuesForKeysWithDictionary:dict];
                    
                    NSMutableArray *bottonSetArr = [NSMutableArray array];
                    eponModel.bottomList = bottonSetArr;
                    
                    for (NSDictionary *subDict in dict[@"bottomList"]) {
                        BottomListModel *bottomSetModel = [[BottomListModel alloc] init];
                        [bottomSetModel setValuesForKeysWithDictionary:subDict];
                        [bottonSetArr addObject:bottomSetModel];
                    }
                    [_eponInfo addObject:eponModel];
                }
                [_eponInfoTV reloadData];
            }else if ([kind  isEqualToString: @"2"]){
                _equipKind = kind;
                for (NSDictionary *dict in result[@"list"]) {
                    EponInfoModelOBD *eponModel = [[EponInfoModelOBD alloc] init];
                    [eponModel setValuesForKeysWithDictionary:dict];
                    
                    NSMutableArray *bottonSetArr = [NSMutableArray array];
                    eponModel.bottomList = bottonSetArr;
                    
                    for (NSDictionary *subDict in dict[@"bottomList"]) {
                        BottomListModel *bottomSetModel = [[BottomListModel alloc] init];
                        [bottomSetModel setValuesForKeysWithDictionary:subDict];
                        [bottonSetArr addObject:bottomSetModel];
                    }
                    [_eponInfo addObject:eponModel];
                }
                [_eponInfoTV reloadData];
            }else if ([kind  isEqualToString: @"3"]){
                _equipKind = kind;
                for (NSDictionary *dict in result[@"list"]) {
                    EponInfoModelONU *eponModel = [[EponInfoModelONU alloc] init];
                    [eponModel setValuesForKeysWithDictionary:dict];
                    
                    NSMutableArray *bottonSetArr = [NSMutableArray array];
                    eponModel.bottomList = bottonSetArr;
                    
                    for (NSDictionary *subDict in dict[@"bottomList"]) {
                        BottomListModel *bottomSetModel = [[BottomListModel alloc] init];
                        [bottomSetModel setValuesForKeysWithDictionary:subDict];
                        [bottonSetArr addObject:bottomSetModel];
                    }
                    [_eponInfo addObject:eponModel];
                }
                [_eponInfoTV reloadData];
            }
        }
    }, ^(id result) {
        [_eponInfo removeAllObjects];
        [_eponInfoTV reloadData];
        showAlert(result[@"error"]);
    });
}

#pragma mark - 数据过多的提示
- (void)showAlertMessage
{
    __block UILabel *message = [[UILabel alloc] initWithFrame:RECT(_eponInfoTV.fx, _eponInfoTV.ey, _eponInfoTV.fw, 35)];
    message.text = @"当前数据较多,只显示前20条";
    message.font = [UIFont systemFontOfSize:14.0f];
    message.textAlignment = NSTextAlignmentCenter;
    message.alpha = 0.8;
    message.backgroundColor = [UIColor blackColor];
    message.textColor = [UIColor whiteColor];
    [self.view addSubview:message];
    
    [UIView animateWithDuration:0.5f animations:^{
        [message setFy:message.fy-message.fh];
    } completion:^(BOOL finished) {
        sleep(3.0f);
        [UIView animateWithDuration:0.5f animations:^{
            [message setFy:message.fy+message.fh];
            [message removeFromSuperview];
            message = nil;
        }];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_equipKind  isEqualToString: @"1"]) {
        return 224;
    }else if ([_equipKind  isEqualToString: @"2"]){
        return 339;
    }else if ([_equipKind  isEqualToString: @"3"]){
        return 262;
    }else{
        return 300;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _eponInfo.count > 20 ? 20 : _eponInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_equipKind  isEqualToString: @"1"]) {
        static NSString *reuseId = @"reuseOLT";
        EponInfoCellOLT *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EponInfoCellOLT" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        EponInfoModelOLT *eponModel = _eponInfo[indexPath.row];
        [cell configOLTCell:eponModel];
        return cell;
    }else if ([_equipKind  isEqualToString: @"2"]){
        static NSString *reuseId = @"reuseOBD";
        EponInfoCellOBD *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = (EponInfoCellOBD *)[[[NSBundle mainBundle] loadNibNamed:@"EponInfoCellOBD" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        EponInfoModelOBD *eponModel = _eponInfo[indexPath.row];
        [cell configOBDCell:eponModel];
        return cell;
    }else if ([_equipKind  isEqualToString: @"3"]){
        static NSString *reuseId = @"reuseOUN";
        EponInfoCellONU *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EponInfoCellONU" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        EponInfoModelONU *eponModel = _eponInfo[indexPath.row];
        [cell configONUCell:eponModel];
        return cell;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - EponInfoCellDelegate
- (void)hRefToShowOBDPanelOf:(NSString *)cableName
{
    CableConnectorInfoController *cableInfoCtrl = [[CableConnectorInfoController alloc] init];
    cableInfoCtrl.cableName = cableName;
    [self.navigationController pushViewController:cableInfoCtrl animated:YES];
}


- (void)showUpperSetsInfoOfGes:(UITapGestureRecognizer *)ges
{
    CGPoint point = [ges locationInView:_eponInfoTV];
    NSIndexPath *indexPath = [_eponInfoTV indexPathForRowAtPoint:point];
    NSLog(@"%@",indexPath);
    if ([_equipKind  isEqualToString: @"1"]){
        EponInfoModelOLT *eponModel = _eponInfo[indexPath.row];
        NSMutableArray *tempInfoArray = [NSMutableArray array];
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        tempDict[@"upEquipKind"] = eponModel.upEquipKind;
        tempDict[@"upEquipCode"] = eponModel.upEquipCode;
        UpperListModel *model = [[UpperListModel alloc] init];
        [model setValuesForKeysWithDictionary:tempDict];
        [tempInfoArray addObject:eponModel];
        
        if (_isUpperSetsViewHidden == YES) {
            
            if (_isBottomSetsViewHidden == NO) {
                [UIView animateWithDuration:0.3f animations:^{
                    [_linkSetsView setFx:_linkSetsView.fx+200];
                    [_linkSetsView removeFromSuperview];
                    _linkSetsView = nil;
                }];
                _isBottomSetsViewHidden = YES;
            }
            _linkSetsView = [[LinkingSetsInfoView alloc] initWithFrame:RECT(-200, _eponInfoTV.fy, 200, _eponInfoTV.fh)];
            _linkSetsView.backgroundColor = [UIColor whiteColor];
            _linkSetsView.delegate = self;
            _linkSetsView.willShowView = @"UPPER";
            [self.view addSubview:_linkSetsView];
            UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToDisappearLeft:)];
            swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
            [_linkSetsView addGestureRecognizer:swipeGes];
            
            [_linkSetsView setUpSetsInfoTableViewWith:tempInfoArray];
            
            [UIView animateWithDuration:0.3f animations:^{
                [_linkSetsView setFx:_linkSetsView.fx+200];
            }];
            _isUpperSetsViewHidden = NO;
        }else{
            _isUpperSetsViewHidden = NO;
        }
    }else if ([_equipKind  isEqualToString: @"2"]){
        EponInfoModelOBD *eponModel = _eponInfo[indexPath.row];
        NSMutableArray *tempInfoArray = [NSMutableArray array];
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        tempDict[@"upEquipKind"] = eponModel.upEquipKind;
        tempDict[@"upEquipCode"] = eponModel.upEquipCode;
        UpperListModel *model = [[UpperListModel alloc] init];
        [model setValuesForKeysWithDictionary:tempDict];
        [tempInfoArray addObject:eponModel];
        
        if (_isUpperSetsViewHidden == YES) {
            
            if (_isBottomSetsViewHidden == NO) {
                [UIView animateWithDuration:0.3f animations:^{
                    [_linkSetsView setFx:_linkSetsView.fx+200];
                    [_linkSetsView removeFromSuperview];
                    _linkSetsView = nil;
                }];
                _isBottomSetsViewHidden = YES;
            }
            
            _linkSetsView = [[LinkingSetsInfoView alloc] initWithFrame:RECT(-200, _eponInfoTV.fy, 200, _eponInfoTV.fh)];
            _linkSetsView.delegate = self;
            _linkSetsView.willShowView = @"UPPER";
            _linkSetsView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_linkSetsView];
            UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToDisappearLeft:)];
            swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
            [_linkSetsView addGestureRecognizer:swipeGes];
            
            [_linkSetsView setUpSetsInfoTableViewWith:tempInfoArray];
            [UIView animateWithDuration:0.3f animations:^{
                [_linkSetsView setFx:_linkSetsView.fx+200];
            }];
            _isUpperSetsViewHidden = NO;
        }else{
            _isUpperSetsViewHidden = NO;
        }
    }else if ([_equipKind  isEqualToString: @"3"]){
        EponInfoModelONU *eponModel = _eponInfo[indexPath.row];
        NSMutableArray *tempInfoArray = [NSMutableArray array];
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        tempDict[@"upEquipKind"] = eponModel.upEquipKind;
        tempDict[@"upEquipCode"] = eponModel.upEquipCode;
        UpperListModel *model = [[UpperListModel alloc] init];
        [model setValuesForKeysWithDictionary:tempDict];
        [tempInfoArray addObject:eponModel];
        if (_isUpperSetsViewHidden == YES) {
            
            if (_isBottomSetsViewHidden == NO) {
                [UIView animateWithDuration:0.3f animations:^{
                    [_linkSetsView setFx:_linkSetsView.fx+200];
                    [_linkSetsView removeFromSuperview];
                    _linkSetsView = nil;
                }];
                _isBottomSetsViewHidden = YES;
            }
            _linkSetsView = [[LinkingSetsInfoView alloc] initWithFrame:RECT(-200, _eponInfoTV.fy, 200, _eponInfoTV.fh)];
            _linkSetsView.delegate = self;
            _linkSetsView.willShowView = @"UPPER";
            _linkSetsView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_linkSetsView];
            UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToDisappearLeft:)];
            swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
            [_linkSetsView addGestureRecognizer:swipeGes];
            
            [_linkSetsView setUpSetsInfoTableViewWith:tempInfoArray];
            [UIView animateWithDuration:0.3f animations:^{
                [_linkSetsView setFx:_linkSetsView.fx+200];
            }];
            _isUpperSetsViewHidden = NO;
        }else{
            _isUpperSetsViewHidden = NO;
        }
    }
}

- (void)swipeToDisappearLeft:(UISwipeGestureRecognizer *)ges
{
    LinkingSetsInfoView *view = (LinkingSetsInfoView *)ges.view;
    if (_isUpperSetsViewHidden == NO) {
        [view setFx:view.fx-200];
        [view removeFromSuperview];
        view  = nil;
        _isUpperSetsViewHidden = YES;
    }
}

- (void)showBottomSetsInfoOfGes:(UITapGestureRecognizer *)ges
{
    CGPoint point = [ges locationInView:_eponInfoTV];
    NSIndexPath *indexPath = [_eponInfoTV indexPathForRowAtPoint:point];
    NSLog(@"%@",indexPath);
    if ([_equipKind  isEqualToString: @"1"]){
        EponInfoModelOLT *eponModel = _eponInfo[indexPath.row];
        NSArray *bottomSetsInfo = eponModel.bottomList;
        
        if (_isBottomSetsViewHidden == YES) {
            if (_isUpperSetsViewHidden == NO) {
                [UIView animateWithDuration:0.3f animations:^{
                    [_linkSetsView setFx:_linkSetsView.fx+200];
                    [_linkSetsView removeFromSuperview];
                    _linkSetsView = nil;
                }];
                _isUpperSetsViewHidden = YES;
            }
            _linkSetsView = [[LinkingSetsInfoView alloc] initWithFrame:RECT(APP_W, _eponInfoTV.fy, 200, _eponInfoTV.fh)];
            _linkSetsView.backgroundColor = [UIColor whiteColor];
            _linkSetsView.willShowView = @"BOTTOM";
            _linkSetsView.delegate = self;
            [self.view addSubview:_linkSetsView];
            [_linkSetsView addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToDisappearRight:)]];
            [_linkSetsView setUpSetsInfoTableViewWith:bottomSetsInfo];
            [UIView animateWithDuration:0.3f animations:^{
                [_linkSetsView setFx:_linkSetsView.fx-200];
            }];
            _isBottomSetsViewHidden = NO;
        }else{
            _isBottomSetsViewHidden = NO;
        }
        
    }else if ([_equipKind  isEqualToString: @"2"]){
        EponInfoModelOBD *eponModel = _eponInfo[indexPath.row];
        NSArray *bottomSetsInfo = eponModel.bottomList;
        
        if (_isBottomSetsViewHidden == YES) {
            if (_isUpperSetsViewHidden == NO) {
                [UIView animateWithDuration:0.3f animations:^{
                    [_linkSetsView setFx:_linkSetsView.fx+200];
                    [_linkSetsView removeFromSuperview];
                    _linkSetsView = nil;
                }];
                _isUpperSetsViewHidden = YES;
            }
            _linkSetsView = [[LinkingSetsInfoView alloc] initWithFrame:RECT(APP_W, _eponInfoTV.fy, 200, _eponInfoTV.fh)];
            _linkSetsView.backgroundColor = [UIColor whiteColor];
            _linkSetsView.willShowView = @"BOTTOM";
            _linkSetsView.delegate = self;
            [self.view addSubview:_linkSetsView];
            [_linkSetsView addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToDisappearRight:)]];
            [_linkSetsView setUpSetsInfoTableViewWith:bottomSetsInfo];
            [UIView animateWithDuration:0.3f animations:^{
                [_linkSetsView setFx:_linkSetsView.fx-200];
            }];
            _isBottomSetsViewHidden = NO;
        }else{
            _isBottomSetsViewHidden = NO;
        }
    }else if ([_equipKind  isEqualToString: @"3"]){
        EponInfoModelONU *eponModel = _eponInfo[indexPath.row];
        NSArray *bottomSetsInfo = eponModel.bottomList;
        
        if (_isBottomSetsViewHidden == YES) {
            if (_isUpperSetsViewHidden == NO) {
                [UIView animateWithDuration:0.3f animations:^{
                    [_linkSetsView setFx:_linkSetsView.fx+200];
                    [_linkSetsView removeFromSuperview];
                    _linkSetsView = nil;
                }];
                _isUpperSetsViewHidden = YES;
            }
            _linkSetsView = [[LinkingSetsInfoView alloc] initWithFrame:RECT(APP_W, _eponInfoTV.fy, 200, _eponInfoTV.fh)];
            _linkSetsView.backgroundColor = [UIColor whiteColor];
            _linkSetsView.willShowView = @"BOTTOM";
            _linkSetsView.delegate = self;
            [self.view addSubview:_linkSetsView];
            [_linkSetsView addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToDisappearRight:)]];
            [_linkSetsView setUpSetsInfoTableViewWith:bottomSetsInfo];
            [UIView animateWithDuration:0.3f animations:^{
                [_linkSetsView setFx:_linkSetsView.fx-200];
            }];
            _isBottomSetsViewHidden = NO;
        }else{
            _isBottomSetsViewHidden = NO;
        }
    }
}

- (void)swipeToDisappearRight:(UISwipeGestureRecognizer *)ges
{
    LinkingSetsInfoView *view = (LinkingSetsInfoView *)ges.view;
    if (_isBottomSetsViewHidden == NO) {
        [view setFx:view.fx+200];
        [view removeFromSuperview];
        view  = nil;
        _isBottomSetsViewHidden = YES;
    }
}

#pragma mark - LinkingSetsInfoViewDelegate
- (void)upperSetInfoWithEquipCode:(NSString *)EquipCode EquipKind:(NSString *)EquipKind
{
    if (_isUpperSetsViewHidden == NO) {
        [_linkSetsView setFx:_linkSetsView.fx-200];
        [_linkSetsView removeFromSuperview];
        _linkSetsView  = nil;
        _isUpperSetsViewHidden = YES;
    }
    
    self.flag = @"2";
    [self searchEponInfoWithEquipCode:EquipCode equipKind:EquipKind flag:self.flag];
}

- (void)bottomSetInfoWithEquipCode:(NSString *)EquipCode EquipKind:(NSString *)EquipKind
{
    if (_isBottomSetsViewHidden == NO) {
        [_linkSetsView setFx:_linkSetsView.fx+200];
        [_linkSetsView removeFromSuperview];
        _linkSetsView  = nil;
        _isBottomSetsViewHidden = YES;
    }
    
    self.flag = @"2";
    [self searchEponInfoWithEquipCode:EquipCode equipKind:EquipKind flag:self.flag];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.flag = @"1";
    [textField resignFirstResponder];
    [self searchEponInfoWithEquipCode:textField.text equipKind:_equipKind flag:self.flag];
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
