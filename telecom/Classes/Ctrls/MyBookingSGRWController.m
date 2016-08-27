//
//  MyBookingSGRWController.m
//  telecom
//
//  Created by liuyong on 15/7/13.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyBookingSGRWController.h"
#import "MyBookingEdit.h"
#import "MyBookingXcsgDetail.h"

#define CARD_H      130

@interface MyBookingSGRWController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    UIView *_chooseInfoView;
    BOOL _isHiden;
    NSMutableArray *dataArr;
    NSString *strName;
}
@end

@implementation MyBookingSGRWController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
    [self loadDataWithFilterFlag:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"随工任务清单";
    _isHiden = YES;
    [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    
    NOTIF_ADD(BOOKING_UPDATE_SGRW, onXcsgUpdate:);
    NOTIF_ADD(BOOKING_UPDATE_SGYY, onSgyyUpdate:);
    
    m_data = [[NSMutableArray alloc] init];
    
    [self setUpRightNavButton];
    
//    [self setUpTableView];
    [self initView];
    
    [self createChooseInfoBtn];

//    [self loadDataWithFilterFlag:nil];
    
    
}


-(void)initView
{
    
    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectZero];
    rightLable.text = @"      ";
    [rightLable setFont:[UIFont systemFontOfSize:13.0]];
    rightLable.alpha = 0.5;
    [rightLable sizeToFit];
    
    UITextField *seaFiled = [[UITextField alloc]initWithFrame:CGRectMake(30, 80, kScreenWidth-80, 28)];
    seaFiled.backgroundColor = [UIColor whiteColor];
    seaFiled.rightViewMode = UITextFieldViewModeAlways;
    seaFiled.rightView = rightLable;
    seaFiled.placeholder = @" 请输入站点名称...";
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
    [searchBtn setFrame:CGRectMake(kScreenWidth-30-btnImg.size.width/2, 80, btnImg.size.width/2, btnImg.size.height/1.9)];
    [searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    UIImage *seaImg = [UIImage imageNamed:@"sea.png"];
    UIImageView *seaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, seaImg.size.width/2, seaImg.size.height/2)];
    seaImgView.image = seaImg;
    [searchBtn addSubview:seaImgView];
    
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 120, kScreenWidth, kScreenHeight-120)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
    
    m_table = [[UITableView alloc] initWithFrame:RECT(0, 0, kScreenWidth, kScreenHeight-120)
                                           style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = CARD_H;
    m_table.delegate = self;
    m_table.dataSource = self;
    m_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [backview addSubview:m_table];
    
}


- (void)setUpTableView
{
    m_table = [[UITableView alloc] initWithFrame:RECT(0, 64, APP_W, APP_H-64)
                                           style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = CARD_H;
    m_table.delegate = self;
    m_table.dataSource = self;
    m_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:m_table];
}


#pragma mark == 搜索
-(void)searchBtn
{
    if (strName == nil || strName.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"请输入任务内容、局站" :@"确定" :nil];
    }else{
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"MyTask/WithWork/OpenDoorListForAdmin";
        paraDict[@"siteName"] = strName;
        paraDict[@"startDate"] = date2str([NSDate date], DATE_FORMAT);
        
        httpGET2(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"])
            {
                [m_data removeAllObjects];
                m_data = [result objectForKey:@"list"];
                m_table.hidden = NO;
                [m_table reloadData];
                
            }else{
                m_table.hidden = YES;
            }
            
        }, ^(id result) {
            NSLog(@"%@",result);
            showAlert([result objectForKey:@"error"]);
        });
        
    }
    
}



#pragma mark - 选择项
- (void)createChooseInfoBtn
{
    _chooseInfoView = [[UIView alloc] initWithFrame:CGRectMake(APP_W, STATUS_H+NAV_H, 120, 150)];
    _chooseInfoView.backgroundColor = COLOR(239, 239, 239);
    _chooseInfoView.layer.borderWidth = 1;
    _chooseInfoView.layer.borderColor = COLOR(239, 239, 239).CGColor;
    [self.view addSubview:_chooseInfoView];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"待执行" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 120, 30);
    [btn1 addTarget:self action:@selector(alreadyDraw:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 9000;
    [_chooseInfoView addSubview:btn1];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 120, 1)];
    lineView1.backgroundColor = [UIColor grayColor];
    lineView1.alpha = 0.5;
    [_chooseInfoView addSubview:lineView1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"开始执行" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.frame = CGRectMake(0, 30, 120, 30);
    [btn2 addTarget:self action:@selector(notDraw:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 9001;
    [_chooseInfoView addSubview:btn2];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 120, 1)];
    lineView2.backgroundColor = [UIColor grayColor];
    lineView2.alpha = 0.5;
    [_chooseInfoView addSubview:lineView2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn3 setTitle:@"执行中" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.frame = CGRectMake(0, 60, 120, 30);
    [btn3 addTarget:self action:@selector(notDraw1:) forControlEvents:UIControlEventTouchUpInside];
    btn3.tag = 9003;
    [_chooseInfoView addSubview:btn3];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 89, 120, 1)];
    lineView3.backgroundColor = [UIColor grayColor];
    lineView3.alpha = 0.5;
    [_chooseInfoView addSubview:lineView3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn4 setTitle:@"已完成" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn4.frame = CGRectMake(0, 90, 120, 30);
    [btn4 addTarget:self action:@selector(notDraw2:) forControlEvents:UIControlEventTouchUpInside];
    btn4.tag = 9004;
    [_chooseInfoView addSubview:btn4];
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 119, 120, 1)];
    lineView4.backgroundColor = [UIColor grayColor];
    lineView4.alpha = 0.5;
    [_chooseInfoView addSubview:lineView4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn5 setTitle:@"已取消" forState:UIControlStateNormal];
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn5.frame = CGRectMake(0, 120, 120, 30);
    [btn5 addTarget:self action:@selector(notDraw3:) forControlEvents:UIControlEventTouchUpInside];
    btn5.tag = 9005;
    [_chooseInfoView addSubview:btn5];
    
    UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 149, 120, 1)];
    lineView5.backgroundColor = [UIColor grayColor];
    lineView5.alpha = 0.5;
    [_chooseInfoView addSubview:lineView5];
    
}
-(void)notDraw1:(UIButton *)btn{
    DLog(@"%ld",(long)btn.tag);
    if (btn.tag == 9003) {
        self.title = @"执行中工单";
        [self loadDataWithFilterFlag:@"4"];
        
        //收回选项卡
        UIView *superView = btn.superview;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect tempFrame = superView.frame;
            tempFrame.origin.x = APP_W;
            superView.frame = tempFrame;
            _isHiden = YES;
        }];
    }
}

-(void)notDraw3:(UIButton *)btn{
    DLog(@"%ld",(long)btn.tag);
    if (btn.tag == 9005) {
        self.title = @"已取消工单";
        [self loadDataWithFilterFlag:@"2"];
        
        //收回选项卡
        UIView *superView = btn.superview;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect tempFrame = superView.frame;
            tempFrame.origin.x = APP_W;
            superView.frame = tempFrame;
            _isHiden = YES;
        }];
    }
}
-(void)notDraw2:(UIButton *)btn{
    DLog(@"%ld",(long)btn.tag);
    if (btn.tag == 9004) {
        self.title = @"已完成工单";
        [self loadDataWithFilterFlag:@"1"];
        
        //收回选项卡
        UIView *superView = btn.superview;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect tempFrame = superView.frame;
            tempFrame.origin.x = APP_W;
            superView.frame = tempFrame;
            _isHiden = YES;
        }];
    }
}

#pragma mark - setUpRightNavButton
- (void)setUpRightNavButton
{
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"nav_filter@2x.png"];
    checkBtn.frame = RECT(APP_W-40, 7, 30, 30);
    [checkBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(ShowChooseInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)ShowChooseInfo:(UIButton *)senderBtn
{
    if (_isHiden == YES) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect tempFrame = _chooseInfoView.frame;
            tempFrame.origin.x = APP_W - 120;
            _chooseInfoView.frame = tempFrame;
        }];
        _isHiden = NO;
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            CGRect tempFrame = _chooseInfoView.frame;
            tempFrame.origin.x = APP_W;
            _chooseInfoView.frame = tempFrame;
        }];
        _isHiden = YES;
    }
}

- (void)alreadyDraw:(UIButton *)btn
{
    if (btn.tag == 9000) {
        self.title = @"待执行工单";
//        [m_data removeAllObjects];
        [self loadDataWithFilterFlag:@"0"];
        
        //收回选项卡
        UIView *superView = btn.superview;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect tempFrame = superView.frame;
            tempFrame.origin.x = APP_W;
            superView.frame = tempFrame;
            _isHiden = YES;
        }];
    }
}

- (void)notDraw:(UIButton *)btn
{
    if (btn.tag == 9001) {
        self.title = @"开始执行工单";
//        [m_data removeAllObjects];
        [self loadDataWithFilterFlag:@"3"];
        
        //收回选项卡
        UIView *superView = btn.superview;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect tempFrame = superView.frame;
            tempFrame.origin.x = APP_W;
            superView.frame = tempFrame;
            _isHiden = YES;
        }];
    }
}

- (void)loadDataWithFilterFlag:(NSString *)filterFlag
{
    NSDictionary* params = nil;
    if (filterFlag != nil) {
        params = @{URL_TYPE:NW_OpenDoorListForAdmin, @"startDate":date2str([NSDate date], DATE_FORMAT),@"filterFlag":filterFlag};
    }else{
    params = @{URL_TYPE:NW_OpenDoorListForAdmin, @"startDate":date2str([NSDate date], DATE_FORMAT)};
    }
    
    httpGET2(params, ^(id result) {
        NSLog(@"%@",result);
        [m_data removeAllObjects];
        NSArray* resList = result[@"list"];
        m_table.hidden = (resList.count == 0);
        if (resList.count > 0) {
            [m_data addObjectsFromArray:resList];
        }
        [m_table reloadData];
    }, ^(id result) {
        [self showAlertWithTitle:@"提示" :[result objectForKey:@"error"] :@"确定" :nil];
        m_table.hidden = YES;
//        if (m_data.count > 0) {
//            [m_data removeAllObjects];
//            [m_table reloadData];
//        }
    });
}

- (void)onXcsgUpdate:(NSNotification*)notification
{
    [self loadDataWithFilterFlag:nil];
}

- (void)onSgyyUpdate:(NSNotification*)notification
{
    [self loadDataWithFilterFlag:nil];
}


- (void)toShowKMDetail:(NSString*)detailId
{
    MyBookingEdit* vc = [[MyBookingEdit alloc] init];
    vc.appointmentId = detailId;
    vc.respBlock = ^(id resp) {
        mainThread(loadData, nil);
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toShowSGDetail:(NSString*)detailId
{
    MyBookingXcsgDetail* vc = [[MyBookingXcsgDetail alloc] init];
    vc.taskId = detailId;
//    vc.listVC = getViewController(self);
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    if (m_data.count == 0) {
//        [self showAlertWithTitle:@"提示" :@"没有符合条件的数据" :@"确定" :nil];
    }else{
        NSDictionary* dataRow = m_data[indexPath.row];
        
        if ([dataRow[@"typeId"] intValue] == 1) {
            [self toShowKMDetail:dataRow[@"appointmentId"]];
        } else if ([dataRow[@"typeId"] intValue] == 2) {
            [self toShowSGDetail:dataRow[@"appointmentId"]];
        }
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    cell = [self getCellForSGRW:indexPath];
    
    return cell;
}

- (UITableViewCell *)getCellForSGRW:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"appointmentId"]];
    UITableViewCell* cell=[m_table dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:str];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel* lbdate = newLabel(cell, @[@50, RECT_OBJ(10, 10, APP_W-30, Font3), COLOR(236, 132, 41), FontB(Font3), @""]);
        UILabel* lbtype = newLabel(cell, @[@51, RECT_OBJ(10, lbdate.ey+7, APP_W-30, Font1), COLOR(236, 132, 41), FontB(Font1), @""]);
        UILabel* lbtitle = newLabel(cell, @[@52, RECT_OBJ(10, lbtype.ey+7, APP_W-30, Font1), [UIColor blackColor], FontB(Font1), @""]);
        UILabel* lbreason = newLabel(cell, @[@53, RECT_OBJ(10, lbtitle.ey+7, APP_W-30, Font3), COLOR(83, 83, 83), Font(Font3), @""]);
        UILabel *labelNumber =  newLabel(cell, @[@54, RECT_OBJ(10, lbreason.fy, APP_W-30, Font3), COLOR(83, 83, 83), Font(Font3), @""]);
        labelNumber.textAlignment = NSTextAlignmentRight;
        
        UILabel *labelCompany =  newLabel(cell, @[@55, RECT_OBJ(10, labelNumber.ey+7, APP_W-30, Font3), COLOR(83, 83, 83), Font(Font3), @""]);
        UILabel *labeltelePhone =  newLabel(cell, @[@56, RECT_OBJ(10, labelNumber.ey+7, APP_W-30, Font3), COLOR(83, 83, 83), Font(Font3), @""]);
        labeltelePhone.textAlignment = NSTextAlignmentRight;
        
    }
    
    NSArray* typeNames = @[@"", @"远程开门", @"现场随工", @"系统割接", @"故障任务"];
    DLog(@"%@",dataRow);
    ((UILabel*)[cell viewWithTag:50]).text = dataRow[@"taskTime"];
    NSString* typeName = typeNames[[dataRow[@"typeId"] intValue]];
    ((UILabel*)[cell viewWithTag:51]).text = typeName;
    ((UILabel*)[cell viewWithTag:52]).text = dataRow[@"roomName"];
    ((UILabel*)[cell viewWithTag:53]).text = dataRow[@"reason"];
    
    
    NSString* person = format(@"%@%@", NoNullStr(dataRow[@"constructor"]), NoNullStr(dataRow[@"mobile"]));
    ((UILabel*)[cell viewWithTag:54]).text = person;
    ((UILabel*)[cell viewWithTag:55]).text = dataRow[@"company"];
    ((UILabel*)[cell viewWithTag:56]).text = [NSString stringWithFormat:@"%@%@",dataRow[@"taskConstructors"],dataRow[@"telphone"]];
    
    return cell;
}

//- (UITableViewCell *)getCellForSGYY:(NSIndexPath *)indexPath
//{
//    NSMutableDictionary* dataRow = m_data[indexPath.row];
//    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"appointmentId"]];
//    UITableViewCell* cell=[m_table dequeueReusableCellWithIdentifier:str];
//    if (cell==nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                      reuseIdentifier:str];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        
//        UILabel* lbname = newLabel(cell, @[@50, RECT_OBJ(10, 10, APP_W-30, Font1), RGB(0x000000), FontB(Font1), @""]);
//        UILabel* lbnum = newLabel(cell, @[@51, RECT_OBJ(10, lbname.ey+7, APP_W-40, Font3), RGB(0x4f4f4f), Font(Font3), @""]);
//        newLabel(cell, @[@52, RECT_OBJ(10, lbname.ey+7, APP_W-50, Font3), RGB(0x4f4f4f), Font(Font3), @""]).textAlignment = NSTextAlignmentRight;
//        UILabel* lbtime = newLabel(cell, @[@53, RECT_OBJ(10, lbnum.ey+7, APP_W-30, Font3), RGB(0x4f4f4f), Font(Font3), @""]);
//        newLabel(cell, @[@54, RECT_OBJ(10, lbtime.ey+7, APP_W-30, Font3), RGB(0x4f4f4f), Font(Font3), @""]);
//    }
//    
//    tagViewEx(cell, 50, UILabel).text = NoNullStr(dataRow[@"projectName"]);
//    tagViewEx(cell, 51, UILabel).text = NoNullStr(dataRow[@"appointmentId"]);
//    tagViewEx(cell, 52, UILabel).text = NoNullStr(dataRow[@"regionName"]);
//    tagViewEx(cell, 53, UILabel).text = NoNullStr(dataRow[@"taskTime"]);
//    tagViewEx(cell, 54, UILabel).text = NoNullStr(dataRow[@"taskAddress"]);
//    
//    return cell;
//}

- (void)apsToList
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self loadDataWithFilterFlag:nil];
}

- (void)apsToDetail:(NSString*)detailId
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self performSelector:@selector(toShowKMDetail:) withObject:detailId afterDelay:1];
}

#pragma mark == UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    strName = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    strName = textField.text;
    [textField resignFirstResponder];
    textField.text = @"";
    [self searchBtn];
    return YES;
}
#warning    查看内存情况（Liuqiang）
-(void)dealloc{
    DLog(@"%@",@"0111");
    
}


@end
