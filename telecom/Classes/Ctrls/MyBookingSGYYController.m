//
//  MyBookingSGYYController.m
//  telecom
//
//  Created by liuyong on 15/7/13.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyBookingSGYYController.h"
#import "MyBookingEdit.h"
#import "MyBookingSgyyDetail.h"
#define CARD_H      130
#import "StandardizeViewController.h"

@interface MyBookingSGYYController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    NSMutableArray *dataArr;
    NSString *strName;
}
@end

@implementation MyBookingSGYYController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"施工预约清单";
    [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    
    NOTIF_ADD(BOOKING_UPDATE_SGRW, onXcsgUpdate:);
    NOTIF_ADD(BOOKING_UPDATE_SGYY, onSgyyUpdate:);
    
    m_data = [[NSMutableArray alloc] init];
//    m_table = [[UITableView alloc] initWithFrame:RECT(0, 64, APP_W, APP_H-64)
//                                           style:UITableViewStylePlain];
//    m_table.backgroundColor = [UIColor whiteColor];
//    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    m_table.bounces = YES;
//    m_table.rowHeight = CARD_H;
//    m_table.delegate = self;
//    m_table.dataSource = self;
//    m_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:m_table];
    [self initView];
    [self loadData];
    
    
    //增加标准化手册按钮
    UIImage* Icon = [UIImage imageNamed:@"wenhao.png"];
    UIButton* commitBtn3 = [[UIButton alloc] initWithFrame:RECT(0, 0,30, 30)];
    [commitBtn3 setImage:[Icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    commitBtn3.titleLabel.font = FontB(Font3);
    [commitBtn3 addTarget:self action:@selector(standardize:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:commitBtn3];
    self.navigationItem.rightBarButtonItem = item3;
}

//增加标准化手册
- (void)standardize:(UIButton *)btn
{
    StandardizeViewController *ctrl = [[StandardizeViewController alloc] init];
       NSString *urlStr = [[NSString stringWithFormat:@"http://%@/doc-app/doc/p/search.do?search.do?key=&and=工程现场配合",ADDR_IP] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    ctrl.request = request;
    [self.navigationController pushViewController:ctrl animated:YES];
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


- (void)loadData
{
    NSDictionary* params = nil;
    
    params = @{URL_TYPE:NW_TaskAppointmentListForAdmin};
    
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
        if (m_data.count > 0) {
            [m_data removeAllObjects];
            [m_table reloadData];
        }
    });
}



#pragma mark == 搜索
-(void)searchBtn
{
    if (strName == nil || strName.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"请输入任务内容、局站" :@"确定" :nil];
    }else{
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"MyTask/WithWork/TaskAppointmentListForAdmin";
        paraDict[@"siteName"] = strName;
                
        
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
        });
        
    }
    
}


- (void)onXcsgUpdate:(NSNotification*)notification
{
    [self loadData];
}

- (void)onSgyyUpdate:(NSNotification*)notification
{
    [self loadData];
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    NSDictionary* dataRow = m_data[indexPath.row];
    
    MyBookingSgyyDetail* vc = [[MyBookingSgyyDetail alloc] init];
    vc.appointmentId = dataRow[@"appointmentId"];
    //        vc.listVC = getViewController(self);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    cell = [self getCellForSGYY:indexPath];
    
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
        UILabel *labelNumber= newLabel(cell, @[@54, RECT_OBJ(10, lbreason.fy, APP_W-30, Font3), COLOR(83, 83, 83), Font(Font3), @""]);
        labelNumber.textAlignment = NSTextAlignmentRight;
        
        UILabel *labelCompany =  newLabel(cell, @[@55, RECT_OBJ(10, labelNumber.ey+7, APP_W-30, Font3), COLOR(83, 83, 83), Font(Font3), @""]);
        UILabel *labeltelePhone =  newLabel(cell, @[@56, RECT_OBJ(10, labelNumber.ey+7, APP_W-30, Font3), COLOR(83, 83, 83), Font(Font3), @""]);
        labeltelePhone.textAlignment = NSTextAlignmentRight;
    }
    
    NSArray* typeNames = @[@"", @"远程开门", @"现场随工", @"系统割接", @"故障任务"];
    
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

- (UITableViewCell *)getCellForSGYY:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"appointmentId"]];
    UITableViewCell* cell=[m_table dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:str];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel* lbname = newLabel(cell, @[@50, RECT_OBJ(10, 10, APP_W-30, Font1), RGB(0x000000), FontB(Font1), @""]);
        UILabel* lbnum = newLabel(cell, @[@51, RECT_OBJ(10, lbname.ey+7, APP_W-40, Font3), RGB(0x4f4f4f), Font(Font3), @""]);
        newLabel(cell, @[@52, RECT_OBJ(10, lbname.ey+7, APP_W-50, Font3), RGB(0x4f4f4f), Font(Font3), @""]).textAlignment = NSTextAlignmentRight;
        UILabel* lbtime = newLabel(cell, @[@53, RECT_OBJ(10, lbnum.ey+7, APP_W-30, Font3), RGB(0x4f4f4f), Font(Font3), @""]);
       UILabel *labelNumber =  newLabel(cell, @[@54, RECT_OBJ(10, lbtime.ey+7, APP_W-30, Font3), RGB(0x4f4f4f), Font(Font3), @""]);
        
        UILabel *labelCompany =  newLabel(cell, @[@55, RECT_OBJ(10, labelNumber.ey+7, APP_W-30, Font3), COLOR(83, 83, 83), Font(Font3), @""]);
        UILabel *labeltelePhone =  newLabel(cell, @[@56, RECT_OBJ(10, labelNumber.ey+7, APP_W-30, Font3), COLOR(83, 83, 83), Font(Font3), @""]);
        labeltelePhone.textAlignment = NSTextAlignmentRight;
    }
    
    NSString *strSiteName = [NSString stringWithFormat:@"%@ %@",dataRow[@"siteName"],dataRow[@"taskAddress"]];
    
    NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:strSiteName];
    NSRange redRange1 = NSMakeRange(0, [[noteStr1 string] rangeOfString:@" "].location);
    [noteStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] range:redRange1];
    

    tagViewEx(cell, 50, UILabel).text = NoNullStr(dataRow[@"projectName"]);
    tagViewEx(cell, 51, UILabel).text = NoNullStr(dataRow[@"appointmentId"]);
    tagViewEx(cell, 52, UILabel).text = NoNullStr(dataRow[@"regionName"]);
    tagViewEx(cell, 53, UILabel).text = NoNullStr(dataRow[@"taskTime"]);
    tagViewEx(cell, 54, UILabel).attributedText = noteStr1;
    


    NSString *text = [NSString stringWithFormat:@"%@%@",NoNullStr(dataRow[@"taskConstructors"]),NoNullStr(dataRow[@"telphone"])];
    tagViewEx(cell, 55, UILabel).text = NoNullStr(dataRow[@"company"]);
    tagViewEx(cell, 56, UILabel).text = text;
    
    return cell;
}

- (void)apsToList
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self loadData];
}

- (void)apsToDetail:(NSString*)detailId
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self performSelector:@selector(toShowKMDetail:) withObject:detailId afterDelay:1];
}


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


@end
