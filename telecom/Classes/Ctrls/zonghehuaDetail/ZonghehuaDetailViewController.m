//
//  ZonghehuaDetailViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/9/18.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "ZonghehuaDetailViewController.h"
#import "ZhDetailTableViewCell.h"

#import "HWBProgressHUD.h"
#import "AlertBox.h"
#import "CompAlertBox.h"
#import "ZhPthotoViewController.h"

#import "DatePickerCustomView.h"

#define ROW_H   44
#define TITLE_W (APP_W-45-60-30)
#define IS_TYPE(n)  ([dataRow[@"writeCode"] rangeOfString:n].location != NSNotFound)
#define TAG_STAND_BTN  15539
#define TAG_FILES_BTN  15538

@interface ZonghehuaDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,DatePickerCustomViewDelegate>
{
    UITableView *myTableView;
    NSURL *imageDataUrl;
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    NSMutableArray *dataArr;
    NSMutableArray *destinateArray;
    NSMutableDictionary *destinateSubDict;
    
    
    UIView *backview;
    UIView *pickview;
    UIView *dateView;
    UIDatePicker *datePicker;
    NSString *dateStr;
    NSString *dateStr1;
    NSString *dateStr2;
    
    NSString *dateTag;
    
    NSString *dateString1;
    NSString *dateString2;
    NSString *dateString3;
    
    NSMutableDictionary *dic1;
    NSMutableDictionary *dic2;
    NSMutableDictionary *selectDic;
    NSMutableDictionary *selectDic1;
    NSMutableDictionary *textFieldDic;
    NSMutableDictionary *dateDic;
    NSMutableDictionary *dateDic1;
    NSMutableDictionary *dateDic2;
    NSMutableDictionary *upDic;
    NSMutableArray *upArr;
    
    BOOL _isDatePickerViewShowing;
    DatePickerCustomView *_datePickerView;
}
@end

@implementation ZonghehuaDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationLeftButton];
    [self addNavigationRightButton:@"123.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.strTitle;
    
    _isDatePickerViewShowing = NO;
    imgArr = [[NSMutableArray alloc]initWithCapacity:10];
    imageDataUrlArr = [[NSMutableArray alloc]initWithCapacity:10];
    dataArr = [[NSMutableArray alloc]initWithCapacity:10];
    upArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    dic1 = [[NSMutableDictionary alloc]initWithCapacity:20];
    dic2 = [[NSMutableDictionary alloc]initWithCapacity:20];
    upDic = [[NSMutableDictionary alloc]initWithCapacity:20];
    selectDic = [[NSMutableDictionary alloc]initWithCapacity:20];
    selectDic1 = [[NSMutableDictionary alloc]initWithCapacity:20];
    textFieldDic = [[NSMutableDictionary alloc]initWithCapacity:20];
    dateDic = [[NSMutableDictionary alloc]initWithCapacity:20];
    dateDic1 = [[NSMutableDictionary alloc]initWithCapacity:20];
    dateDic2 = [[NSMutableDictionary alloc]initWithCapacity:20];
    
    
    [self initView];
    NSLog(@"%@",self.strTaskId);
    [self getData];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    dateString1 = [formatter1 stringFromDate:[NSDate date]];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter2 setDateFormat:@"HH:mm"];
    dateString2 = [formatter2 stringFromDate:[NSDate date]];
    
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter3 setDateFormat:@"HH:mm:ss"];
    dateString3 = [formatter3 stringFromDate:[NSDate date]];
}


#pragma mark == 周期工作综合化编辑
-(void)getData
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"MyTask/EditCycleTotalizationList";
    paraDict[@"taskId"] = self.strTaskId;
    
    
    httpGET2(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            dataArr = [result objectForKey:@"list"];
            for (NSMutableDictionary *tempDic in dataArr) {
                tempDic[@"extended"] = @1;
            }
            
            
            destinateArray = [[NSMutableArray alloc] initWithCapacity:dataArr.count];
            
            for (int i=0; i<dataArr.count; i++) {
                NSDictionary *sourceDict = (NSDictionary *)dataArr[i];
                NSArray *sourceInnerArray = (NSArray *)[sourceDict objectForKey:@"propertyList"];
                
                NSMutableDictionary *destinateDict = [NSMutableDictionary dictionary];
                NSMutableArray *destinateInnerArray = [NSMutableArray arrayWithCapacity:sourceInnerArray.count];
                destinateDict[@"isRecall"] = @"1";
                destinateDict[@"taskInfo"] = destinateInnerArray;
                [destinateArray addObject:destinateDict];
                
                for (int j=0; j<sourceInnerArray.count; j++) {
                    NSDictionary *sourceSubDict = (NSDictionary *)sourceInnerArray[j];
                    
                    destinateSubDict = [NSMutableDictionary dictionary];
                    destinateSubDict[@"selectBtn1Status"] = @"0";
                    destinateSubDict[@"selectBtn2Status"] = @"0";
                    destinateSubDict[@"writeName"] = sourceSubDict[@"writeName"];
                    destinateSubDict[@"groupCode"] = sourceSubDict[@"groupCode"];
                    destinateSubDict[@"taskStatus"] = sourceSubDict[@"taskStatus"];
                    destinateSubDict[@"taskId"] = sourceSubDict[@"taskId"];
                    [destinateInnerArray addObject:destinateSubDict];
                }
            }
            [myTableView reloadData];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}


#pragma mark == 周期工作综合化编辑完成
-(void)rightAction
{
    NSMutableDictionary *upDict = [NSMutableDictionary dictionary];
    upDict[@"isRecall"] = @"1";
    
    for (NSDictionary *dict in destinateArray) {
        NSMutableArray *upArray = [NSMutableArray array];
        for (NSDictionary *subDict in dict[@"taskInfo"]) {
            if ([subDict[@"groupCode"] isEqualToString:@"3"]) {
                if (subDict[@"default"] != nil && ![subDict[@"default"] isEqualToString:@""]) {
                    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
                    tempDict[@"taskId"] = subDict[@"taskId"];
                    tempDict[@"content"] = subDict[@"default"];
                    [upArray addObject:tempDict];
                }else{
                    if (subDict[@"year_month_day"] != nil && ![subDict[@"year_month_day"] isEqualToString:@""]) {
                        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
                        tempDict[@"taskId"] = subDict[@"taskId"];
                        tempDict[@"content"] = subDict[@"year_month_day"];
                        if (subDict[@"hour_minute"] != nil && ![subDict[@"hour_minute"] isEqualToString:@""]) {
                            tempDict[@"content"] = [NSString stringWithFormat:@"%@ %@",subDict[@"year_month_day"],subDict[@"hour_minute"]];
                        }
                        
                        if (subDict[@"hour_minute_second"] != nil && ![subDict[@"hour_minute_second"] isEqualToString:@""]) {
                            tempDict[@"content"] = [NSString stringWithFormat:@"%@ %@",subDict[@"year_month_day"],subDict[@"hour_minute_second"]];
                        }
                        [upArray addObject:tempDict];
                    }
                }
            }else{
                if (subDict[@"content"] != nil && ![subDict[@"content"] isEqualToString:@""]) {
                    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
                    tempDict[@"taskId"] = subDict[@"taskId"];
                    tempDict[@"content"] = subDict[@"content"];
                    [upArray addObject:tempDict];
                }
            }
        }
        upDict[@"taskInfo"] = upArray;
    }
    
    NSLog(@"upDict--%@",upDict);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/MyTask/FinshCycleTotalizationTask.json?operationTime=%@&accessToken=%@",ADDR_IP,ADDR_DIR,opreatinTime,accessToken];
    
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    //发送请求
    [manager POST:requestUrl parameters:upDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"result"]isEqualToString:@"0000000"]) {
            NSString *workTime = responseObject[@"detail"][@"workTime"];
            NSString *finishSituation = responseObject[@"detail"][@"finishSituation"];
            NSString *experienceValue = responseObject[@"detail"][@"experienceValue"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标准化测评结果" message:[NSString stringWithFormat:@"%@\n%@\n%@。",workTime,finishSituation,experienceValue] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else{
            showAlert([responseObject objectForKey:@"error"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
}

-(void)initView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 64, kScreenWidth-20, kScreenHeight-64)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight-64) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.showsVerticalScrollIndicator = NO;
    [myTableView setContentInset:UIEdgeInsetsMake(0, 0, 180, 0)];
    //    [self setExtraCellLineHidden:myTableView];
    [bgView addSubview:myTableView];
    
    backview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    backview.backgroundColor = [UIColor grayColor];
    backview.alpha = 0.6;
    backview.hidden = YES;
    [self.view addSubview:backview];
    
    pickview = [[UIView alloc]initWithFrame:CGRectMake(10, 150, kScreenWidth-20, 300)];
    pickview.backgroundColor = [UIColor clearColor];
    [pickview setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-0)];
    pickview.hidden = YES;
    [self.view addSubview:pickview];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark == UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataArr[section] objectForKey:@"propertyList"] count];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 36)];
    bgView.backgroundColor = RGBCOLOR(236, 236, 236);
    
    UIView* line1 = [[UIView alloc] initWithFrame:RECT(0, 0, tableView.fw, 0.5)];
    line1.backgroundColor = COLOR(200, 199, 204);
    [bgView addSubview:line1];
    
    UIView* line2 = [[UIView alloc] initWithFrame:RECT(0, bgView.fh, tableView.fw, 0.5)];
    line2.backgroundColor = COLOR(200, 199, 204);
    [bgView addSubview:line2];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width-60, 36)];
    titleLabel.text = [dataArr[section] objectForKey:@"workProperty"];
    [bgView addSubview:titleLabel];
    
    UIButton *fadeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    fadeBtn.frame = CGRectMake(titleLabel.ex+2, titleLabel.fy, tableView.bounds.size.width-2-titleLabel.fw, 36);
    fadeBtn.tag = 1000 + section;
    NSString* imgName = ([dataArr[section][@"extended"] intValue] == 1 ? @"arr_down.png" : @"arr_up.png");
    [fadeBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [fadeBtn addTarget:self action:@selector(tableViewFadeAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:fadeBtn];
    
    return bgView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([dataArr[indexPath.section][@"extended"] intValue] != 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return cell;
    }
    
    static NSString *zongheCell = @"zongheCell";
    ZhDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zongheCell];
    if (!cell) {
        cell = [[ZhDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zongheCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //    1表示文本
    //    2表示数值
    //    3包含时间（精确到天）、时间（精确到秒）、时间（精确到分）
    //    4包含是/否、天线/室分、正常/不正常
    //    5包含PCI、场强
    //    6表示照片
    
    NSDictionary *taskDict = (NSDictionary *)[dataArr[indexPath.section] objectForKey:@"propertyList"][indexPath.row];
    
    NSString *strTitle = [taskDict objectForKey:@"taskContent"];
    CGSize with = [self labelHight:strTitle];
    cell.titleLabel.frame = CGRectMake(10, 10, kScreenWidth-40, with.height);
    cell.titleLabel.text = [taskDict objectForKey:@"taskContent"];
    
    
    cell.contentLable.frame = CGRectMake(10, 10+with.height, kScreenWidth-20, 20);
    
    NSString *strContent = [NSString stringWithFormat:@"%@%@",[taskDict objectForKey:@"unitNum"],[taskDict objectForKey:@"unit"]];
    cell.contentLable.text = [NSString stringWithFormat:@"%@  %@",[taskDict objectForKey:@"taskTime"],strContent];
    
    cell.statusLable.frame = CGRectMake(kScreenWidth-100, 10+with.height, 80, 20);
    
    cell.myTextField.frame = CGRectMake(10, 40+with.height, kScreenWidth-40, 20);
    cell.myTextField.delegate = self;
    cell.myTextField.tag = indexPath.row;
    
#pragma mark - groupCode:1 表示文本
    if ([[taskDict objectForKey:@"groupCode"] isEqualToString:@"1"]) {
        cell.myTextField.hidden = NO;
        cell.myTextField.placeholder = [taskDict objectForKey:@"alertMessage"];
        
        cell.remarkLabel.hidden = NO;
        cell.remarkLabel.frame = CGRectMake(10, 40+with.height+22, kScreenWidth-40, 20);
        cell.remarkLabel.text = taskDict[@"remarkMessage"];
        cell.remarkLabel.adjustsFontSizeToFitWidth = YES;
    }
#pragma mark - groupCode:2 表示数值
    else if ([[taskDict objectForKey:@"groupCode"]isEqualToString:@"2"]) {
        cell.myTextField.hidden = NO;
        cell.myTextField.placeholder = [taskDict objectForKey:@"alertMessage"];
        cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        cell.remarkLabel.hidden = NO;
        cell.remarkLabel.frame = CGRectMake(10, 40+with.height+22, kScreenWidth-40, 20);
        cell.remarkLabel.text = taskDict[@"remarkMessage"];
        cell.remarkLabel.adjustsFontSizeToFitWidth = YES;
    }
#pragma mark - groupCode:5 包含PCI、场强
    else if ([[taskDict objectForKey:@"groupCode"]isEqualToString:@"5"]) {
        cell.myTextField.hidden = NO;
        cell.myTextField.placeholder = [taskDict objectForKey:@"alertMessage"];
        cell.myTextField.keyboardType = UIKeyboardTypeASCIICapable;
        
        cell.remarkLabel.hidden = NO;
        cell.remarkLabel.frame = CGRectMake(10, 40+with.height+22, kScreenWidth-40, 20);
        cell.remarkLabel.text = taskDict[@"remarkMessage"];
        cell.remarkLabel.adjustsFontSizeToFitWidth = YES;
    }else{
        cell.myTextField.hidden = YES;
        cell.remarkLabel.hidden = YES;
    }
    
    cell.dateBtn.frame = CGRectMake(10, 40+with.height, 80,20);
    cell.dateBtn.tag = 33333;
    [cell.dateBtn addTarget:self action:@selector(dataPick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.dateBtn1.frame = CGRectMake(100, 40+with.height, 80,20);
    cell.dateBtn1.tag = 44444;
    [cell.dateBtn1 addTarget:self action:@selector(dataPick1:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.dateBtn2.frame = CGRectMake(100, 40+with.height, 80,20);
    cell.dateBtn2.tag = 55555;
    [cell.dateBtn2 addTarget:self action:@selector(dataPick2:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *strDate = [dateDic objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    NSString *strDate1 = [dateDic1 objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    NSString *strDate2 = [dateDic2 objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    
    if ([strDate isEqual:@""] || strDate == nil) {
        
    }else{
        [cell.dateBtn setTitle:strDate forState:UIControlStateNormal];
    }
    
    if ([strDate1 isEqual:@""] || strDate1 == nil) {
        
    }else{
        [cell.dateBtn1 setTitle:strDate1 forState:UIControlStateNormal];
    }
    
    if ([strDate2 isEqual:@""] || strDate2 == nil) {
        
    }else{
        [cell.dateBtn2 setTitle:strDate2 forState:UIControlStateNormal];
    }
    
#pragma mark - groupCode:3 包含时间（精确到天）、时间（精确到秒）、时间（精确到分）
    destinateSubDict = [destinateArray[indexPath.section] objectForKey:@"taskInfo"][indexPath.row];
    if ([[taskDict objectForKey:@"groupCode"]isEqualToString:@"3"]){
        if ([[[dataArr[indexPath.section] objectForKey:@"propertyList"][indexPath.row] objectForKey:@"writeCode"]isEqualToString:@"2"]){
            cell.dateBtn.hidden = NO;
            cell.dateBtn1.hidden = YES;
            cell.dateBtn2.hidden = YES;
            destinateSubDict[@"default"] = cell.dateBtn.titleLabel.text;
            
        }else if ([[taskDict objectForKey:@"writeCode"]isEqualToString:@"3"]){
            cell.dateBtn.hidden = NO;
            cell.dateBtn1.hidden = NO;
            cell.dateBtn2.hidden = YES;
            destinateSubDict[@"default"] = [NSString stringWithFormat:@"%@ %@",cell.dateBtn.titleLabel.text,cell.dateBtn1.titleLabel.text];
            
        }else if ([[taskDict objectForKey:@"writeCode"]isEqualToString:@"4"]){
            cell.dateBtn.hidden = NO;
            cell.dateBtn1.hidden = YES;
            cell.dateBtn2.hidden = NO;
            destinateSubDict[@"default"] = [NSString stringWithFormat:@"%@ %@",cell.dateBtn.titleLabel.text,cell.dateBtn2.titleLabel.text];
        }
        
    }else{
        
        cell.dateBtn.hidden = YES;
        cell.dateBtn1.hidden = YES;
        cell.dateBtn2.hidden = YES;
        
    }
    
#pragma mark - 选择按钮
    UIImage *selectBtnImg = [UIImage imageNamed:@"rb_checked.png"];
    UIImage *selectBtnImg1 = [UIImage imageNamed:@"rb_normal.png"];
    
    cell.selectBtn.frame = CGRectMake(15, 40+with.height, selectBtnImg.size.width/1.2, selectBtnImg.size.height/1.2);
    cell.selectBtn1.frame = CGRectMake(135, 40+with.height, selectBtnImg1.size.width/1.2, selectBtnImg1.size.height/1.2);
    
    cell.selectLable.frame = CGRectMake(20+selectBtnImg.size.width/1.2, 38+with.height, 80, 20);
    cell.selectLable1.frame = CGRectMake(140+selectBtnImg.size.width/1.2, 38+with.height, 80, 20);
    
    
    cell.selectBtn.tag = 11111;//正常
    cell.selectBtn1.tag = 22222;//不正常
    
    
    [cell.selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.selectBtn1 addTarget:self action:@selector(selectBtn1:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *destinateInnerArray = (NSArray *)[destinateArray[indexPath.section] objectForKey:@"taskInfo"];
    
    NSString *selectBtn1 = [destinateInnerArray[indexPath.row] objectForKey:@"selectBtn1Status"];
    NSString *selectBtn2 = [destinateInnerArray[indexPath.row] objectForKey:@"selectBtn2Status"];
    
    if ([selectBtn1 isEqualToString:@"0"]) {
        [cell.selectBtn setImage:selectBtnImg1 forState:UIControlStateNormal];
    }else{
        [cell.selectBtn setImage:selectBtnImg forState:UIControlStateNormal];
    }
    
    if ([selectBtn2 isEqualToString:@"0"]) {
        [cell.selectBtn1 setImage:selectBtnImg1 forState:UIControlStateNormal];
    }else{
        [cell.selectBtn1 setImage:selectBtnImg forState:UIControlStateNormal];
    }
    
#pragma mark - groupCode:4 包含是/否、天线/室分、正常/不正常
    if ([[taskDict objectForKey:@"groupCode"]isEqualToString:@"4"]){
        
        cell.selectBtn.hidden = NO;
        cell.selectBtn1.hidden = NO;
        cell.selectLable.hidden = NO;
        cell.selectLable1.hidden = NO;
        
        NSString *str = [taskDict objectForKey:@"writeName"];
        NSArray *arr = [str componentsSeparatedByString:@"/"];
        cell.selectLable.text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:0]];
        cell.selectLable1.text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
    }else{
        cell.selectBtn1.hidden = YES;
        cell.selectBtn.hidden = YES;
        cell.selectLable.hidden = YES;
        cell.selectLable1.hidden = YES;
    }
    
    
    cell.upPhotoBtn.frame = CGRectMake(10, 40+with.height, 80,20);
    cell.upPhotoBtn.tag = indexPath.row +10000;
    [cell.upPhotoBtn addTarget:self action:@selector(upImgBtn:) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark - groupCode:6 表示照片
    if ([[taskDict objectForKey:@"groupCode"]isEqualToString:@"6"]){
        cell.upPhotoBtn.hidden = NO;
    }else{
        cell.upPhotoBtn.hidden = YES;
    }
    
    
    
    //   taskStatus:0：未完成  1：已完成 3: 执行中
    
    if ([[[taskDict objectForKey:@"taskStatus"] description] isEqualToString:@"0"]) {
        
        cell.statusLable.text = @"未完成";
        cell.statusLable.textColor = RGBCOLOR(255, 194, 0);
        
    }else if ([[[taskDict objectForKey:@"taskStatus"] description] isEqualToString:@"3"]) {
        
        cell.statusLable.text = @"执行中";
        cell.statusLable.textColor = RGBCOLOR(0, 246, 93);
        
    }else if ([[[taskDict objectForKey:@"taskStatus"] description] isEqualToString:@"1"]) {
        
        cell.statusLable.text = @"完成";
        cell.statusLable.textColor = RGBCOLOR(179, 179, 179);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHight = 40;
    if ([dataArr[indexPath.section][@"extended"] intValue] != 1) {
        rowHight = 0;
    }else{
        NSString *remarkStr = [[dataArr[indexPath.section] objectForKey:@"propertyList"][indexPath.row] objectForKey:@"remarkMessage"];
        if (remarkStr != nil && ![remarkStr isEqualToString:@""]) {
//            CGRect remarkBounds = [remarkStr boundingRectWithSize:CGSizeMake(tableView.bounds.size.width-5, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil];
            
            NSString *strTitle = [[dataArr[indexPath.section] objectForKey:@"propertyList"][indexPath.row] objectForKey:@"taskContent"];
            CGRect bounds = [strTitle boundingRectWithSize:CGSizeMake(tableView.bounds.size.width-5, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            
            rowHight = 80+bounds.size.height+20;
        }else{
        
        NSString *strTitle = [[dataArr[indexPath.section] objectForKey:@"propertyList"][indexPath.row] objectForKey:@"taskContent"];
        CGRect bounds = [strTitle boundingRectWithSize:CGSizeMake(tableView.bounds.size.width-5, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
        rowHight = 80+bounds.size.height;
            
        }
    }
    return rowHight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 折叠操作
- (void)tableViewFadeAction:(UIButton *)fadeActionBtn
{
    NSInteger section = fadeActionBtn.tag-1000;
    NSInteger status = [dataArr[section][@"extended"] intValue];
    status = (status==1 ? 0 : 1);
    dataArr[section][@"extended"] = @(status);
    [myTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark == 选择按钮
-(void)selectBtn:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    UITableViewCell* cell = (UITableViewCell*)getParentView(sender.superview, [UITableViewCell class]);
    NSIndexPath* indexPath = [myTableView indexPathForCell:cell];
    destinateSubDict = [destinateArray[indexPath.section] objectForKey:@"taskInfo"][indexPath.row];
    
    if ([destinateSubDict[@"selectBtn2Status"] isEqualToString:@"1"]) {
        destinateSubDict[@"selectBtn2Status"] = @"0";
    }
    
    if ([destinateSubDict[@"selectBtn1Status"] isEqualToString:@"0"]) {
        destinateSubDict[@"selectBtn1Status"] = @"1";
        if (tag == 11111) {
            NSString *writeName = destinateSubDict[@"writeName"];
            NSArray *arr = [writeName componentsSeparatedByString:@"/"];
            destinateSubDict[@"content"] = [NSString stringWithFormat:@"%@",[arr objectAtIndex:0]];
        }
    }else{
        destinateSubDict[@"selectBtn1Status"] = @"0";
        destinateSubDict[@"content"] = @"";
    }
    
    NSLog(@"destinateArray--%@",destinateArray);
    [myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


-(void)selectBtn1:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    UITableViewCell* cell = (UITableViewCell*)getParentView(sender.superview, [UITableViewCell class]);
    NSIndexPath* indexPath = [myTableView indexPathForCell:cell];
    destinateSubDict = [destinateArray[indexPath.section] objectForKey:@"taskInfo"][indexPath.row];
    
    if ([destinateSubDict[@"selectBtn1Status"] isEqualToString:@"1"]) {
        destinateSubDict[@"selectBtn1Status"] = @"0";
    }
    
    if ([destinateSubDict[@"selectBtn2Status"] isEqualToString:@"0"]) {
        destinateSubDict[@"selectBtn2Status"] = @"1";
        if (tag == 22222) {
            NSString *writeName = destinateSubDict[@"writeName"];
            NSArray *arr = [writeName componentsSeparatedByString:@"/"];
            destinateSubDict[@"content"] = [NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
        }
    }else{
        destinateSubDict[@"selectBtn2Status"] = @"0";
        destinateSubDict[@"content"] = @"";
    }
    
    NSLog(@"destinateArray--%@",destinateArray);
    [myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark == 选择日期
-(void)dataPick:(UIButton *)sender
{
    if (_isDatePickerViewShowing == NO) {
        UITableViewCell* cell = (UITableViewCell*)getParentView(sender.superview, [UITableViewCell class]);
        NSIndexPath* indexPath = [myTableView indexPathForCell:cell];
        
        destinateSubDict = [destinateArray[indexPath.section] objectForKey:@"taskInfo"][indexPath.row];
        _datePickerView = [[DatePickerCustomView alloc] initWithFrame:CGRectMake(0, 0, 320, 251) type:@"year_month_day" indexPath:indexPath btnTag:sender.tag];
        _datePickerView.center = self.view.center;
        _datePickerView.delegate = self;
        [self.view addSubview:_datePickerView];
        [self.view bringSubviewToFront:_datePickerView];
        _isDatePickerViewShowing = YES;
    }else{
        _isDatePickerViewShowing = NO;
    }
}

-(void)dataPick1:(UIButton *)sender
{
    if (_isDatePickerViewShowing == NO) {
        UITableViewCell* cell = (UITableViewCell*)getParentView(sender.superview, [UITableViewCell class]);
        NSIndexPath* indexPath = [myTableView indexPathForCell:cell];
        
        destinateSubDict = [destinateArray[indexPath.section] objectForKey:@"taskInfo"][indexPath.row];
        _datePickerView = [[DatePickerCustomView alloc] initWithFrame:CGRectMake(0, 0, 320, 251) type:@"hour_minute" indexPath:indexPath btnTag:sender.tag];
        _datePickerView.center = self.view.center;
        _datePickerView.delegate = self;
        [self.view addSubview:_datePickerView];
        [self.view bringSubviewToFront:_datePickerView];
        _isDatePickerViewShowing = YES;
    }else{
        _isDatePickerViewShowing = NO;
    }
}

-(void)dataPick2:(UIButton *)sender
{
    if (_isDatePickerViewShowing == NO) {
        UITableViewCell* cell = (UITableViewCell*)getParentView(sender.superview, [UITableViewCell class]);
        NSIndexPath* indexPath = [myTableView indexPathForCell:cell];
        
        destinateSubDict = [destinateArray[indexPath.section] objectForKey:@"taskInfo"][indexPath.row];
        _datePickerView = [[DatePickerCustomView alloc] initWithFrame:CGRectMake(0, 0, 320, 251) type:@"hour_minute_second" indexPath:indexPath btnTag:sender.tag];
        _datePickerView.center = self.view.center;
        _datePickerView.delegate = self;
        [self.view addSubview:_datePickerView];
        [self.view bringSubviewToFront:_datePickerView];
        _isDatePickerViewShowing = YES;
    }else{
        _isDatePickerViewShowing = NO;
    }
}

- (void)deliverDatePickerResult:(NSString *)dateString indexPath:(NSIndexPath *)indexPath btn:(NSInteger)btnTag
{
    UITableViewCell *cell = [myTableView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)[cell viewWithTag:btnTag];
    [btn setTitle:dateString forState:UIControlStateNormal];
    
    destinateSubDict = [destinateArray[indexPath.section] objectForKey:@"taskInfo"][indexPath.row];
    destinateSubDict[@"default"] = @"";

    if (btnTag == 33333) {
        destinateSubDict[@"year_month_day"] = dateString;
    }
    
    if (btnTag == 44444) {
        destinateSubDict[@"hour_minute"] = dateString;
    }
    
    if (btnTag == 55555) {
        destinateSubDict[@"hour_minute_second"] = dateString;
    }
    
    [_datePickerView removeFromSuperview];
    _isDatePickerViewShowing = NO;
}

- (void)cancle
{
    [_datePickerView removeFromSuperview];
    _isDatePickerViewShowing = NO;
}

///////////////////////////////////////////////
#pragma mark == UITextField
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell* cell = (UITableViewCell*)getParentView(textField.superview, [UITableViewCell class]);
    NSIndexPath* indexPath = [myTableView indexPathForCell:cell];
    
    NSLog(@"%d",textField.tag);
    NSDictionary *taskDict = (NSDictionary *)[dataArr[indexPath.section] objectForKey:@"propertyList"][indexPath.row];
    NSString *strTitle = taskDict[@"taskContent"];
    CGSize with = [self labelHight:strTitle];
    
    float heiht = textField.tag*(70+with.height);
    
    if (heiht > 0) {
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y -=150;
        frame.size.height +=150;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    UITableViewCell* cell = (UITableViewCell*)getParentView(textField.superview, [UITableViewCell class]);
    NSIndexPath* indexPath = [myTableView indexPathForCell:cell];
    
    destinateSubDict = [destinateArray[indexPath.section] objectForKey:@"taskInfo"][indexPath.row];
    NSString *textContent = textField.text;
    
    destinateSubDict[@"content"] = textContent;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark == 转换json
-(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark == 计算高度
- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGSize constraint = CGSizeMake(180, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}


#pragma mark == 选取相片
- (void)upImgBtn:(UIButton *)sender
{
    UITableViewCell* cell = (UITableViewCell*)getParentView(sender.superview, [UITableViewCell class]);
    NSIndexPath* indexPath = [myTableView indexPathForCell:cell];
    NSString *taskId = [[dataArr[indexPath.section] objectForKey:@"propertyList"][indexPath.row] objectForKey:@"taskId"];
    
    ZhPthotoViewController *zhVC = [[ZhPthotoViewController alloc]init];
    zhVC.delegate = self;
    zhVC.strTaskID = taskId;
    zhVC.indexPath = indexPath;
    [self.navigationController pushViewController:zhVC animated:YES];
}

- (void)screenVC:(NSString *)str indexPath:(NSIndexPath *)indexPath
{
    destinateSubDict = [destinateArray[indexPath.section] objectForKey:@"taskInfo"][indexPath.row];
    destinateSubDict[@"content"] = @"照片";
    NSLog(@"%@",destinateArray);
}

@end
