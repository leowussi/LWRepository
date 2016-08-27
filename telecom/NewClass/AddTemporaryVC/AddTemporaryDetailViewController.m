//
//  AddTemporaryDetailViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/7/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AddTemporaryDetailViewController.h"
#import "UIViewExt.h"
#import "TemporaryGroup.h"
#import "TemporaryHeadView.h"

@interface AddTemporaryDetailViewController ()<UITextViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextView *taskTextView;
    UITextField *checkFiled;
    UILabel *placeholderLabel;
    UITableView *myTableView;
    NSMutableArray *array;
    NSDictionary *data;
    NSArray *sectionArr;
    
    UIButton *_selectedBtn;
    
    NSString *strAddress;
    
    BOOL isOpen;//第0区是否展开
    BOOL isOpen1;//第1区是否展开
    BOOL isOpen2;//第2区是否展开
    NSArray *sectionArray;//第0区数组
    NSArray *sectionArray1;//第1区数组
    NSArray *sectionArray2;//第2区数组
    
    NSString *strRegionDate;
    NSString *strRegionAddress;
    NSString *strRegionId;
    NSString *strRegionName;
    NSString *strTaskContent;
}

@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;
@property (nonatomic, strong) NSDictionary *tabDic;
@property (nonatomic,retain)NSIndexPath *selectIndex;

@end

@implementation AddTemporaryDetailViewController
@synthesize selectIndex,contents,leftArray,rightArray,tabDic;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
    UIColor *color = [UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = color;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationLeftButton];
    [self addNavigationRightButton:@"123.png"];
    self.title = @"新增临时任务";
    // Do any additional setup after loading the view.
    _baseScrollView.backgroundColor = RGBCOLOR(250, 250, 250);
    
    array = [[NSMutableArray alloc]initWithCapacity:10];
    
    [self initView];
    
}


-(void)initView
{
    UIImage *img1 = [UIImage imageNamed:@"新增自定义任务-手动输入-任务完成时间.png"];
    UIImage *img2 = [UIImage imageNamed:@"新增自定义任务-手动输入-任务内容.png"];
    UIImage *img3 = [UIImage imageNamed:@"新增自定义任务-手动输入-任务地点.png"];
    
    NSArray *imgArr = @[img1,img2,img3];
    NSArray *titleArr = @[@"任务完成时间",@"任务内容",@"任务地点"];
    
    for (int i = 0; i < imgArr.count; i++) {
        UIImageView *leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80-64+50*i, img1.size.width/1.7, img1.size.height/1.7)];
        leftImgView.image = [imgArr objectAtIndex:i];
        [_baseScrollView addSubview:leftImgView];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15+img1.size.width/1.7, 77+50*i-64, 100, 20)];
        titleLab.text = [titleArr objectAtIndex:i];
        titleLab.font = [UIFont systemFontOfSize:13.0];
        [_baseScrollView addSubview:titleLab];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(120,80-64+50*i+5,kScreenWidth-140,1)];
        lineView.backgroundColor = RGBCOLOR(228, 228, 228);
        [_baseScrollView addSubview:lineView];

        
        if (i == 1) {
            [leftImgView setFrame:CGRectMake(10, 80+100*i-64, img1.size.width/1.7, img1.size.height/1.7)];
            [titleLab setFrame:CGRectMake(15+img1.size.width/1.7, 77+50*i+50-64, 100, 20)];
            [lineView setFrame:CGRectMake(100,80+100*i-64+6,kScreenWidth-120, 1)];
        }
        
        if (i == 2) {
            [leftImgView setFrame:CGRectMake(10, 120+80*i-64, img3.size.width/1.7, img3.size.height/1.7)];
            [titleLab setFrame:CGRectMake(15+img1.size.width/1.7, 77+80*i+40-64, 100, 20)];
            [lineView setFrame:CGRectMake(100,120+80*i-64+5,kScreenWidth-120, 1)];
        }
    }
    
    ////////////////////////////////第一块///////////////////////////////////////
    //名字数组
//    NSMutableArray *nameArr = [[NSMutableArray alloc] initWithObjects:@"今日",@"昨日",@"7/7",@"7/6",@"7/5",@"7/4",@"7/3",@"7/2",@"7/1",@"6/30",nil];
    
    NSMutableArray *nameArr = [[NSMutableArray alloc] initWithObjects:@"今日",@"昨日",[self getDate:2],[self getDate:3],[self getDate:4],[self getDate:5],[self getDate:6],[self getDate:7],[self getDate:8],[self getDate:9],nil];
    
    float buttonWidth = 0.0;
    float buttonTop = 100.0-64;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 135-64, kScreenWidth-20, 1)];
    lineView.backgroundColor = RGBCOLOR(243, 244, 245);
    [_baseScrollView addSubview:lineView];
    
    for (int i = 0; i< nameArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        button.frame = CGRectMake(10 +buttonWidth, buttonTop, 70, 30);
        CGRect frame = [nameArr[i] boundingRectWithSize:CGSizeMake(1000, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]} context:nil];
        button.titleLabel.textColor = [UIColor grayColor];
        button.width = frame.size.width +22;
        buttonWidth += button.width +8;
        
        if (buttonWidth > self.view.width - 10) {
            button.left = 10;
            button.top = buttonTop +25 +15;
            buttonTop = button.top;
            buttonWidth = button.width +8;
        }
        
        button.titleEdgeInsets = (UIEdgeInsets){0,0,0,0};
        NSAttributedString *titltString = [[NSAttributedString alloc] initWithString:nameArr[i] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}];
        [button setAttributedTitle:titltString forState:UIControlStateNormal];
        
        if ([[[self.dic objectForKey:@"planEndDate"] description]isEqualToString:[self getYYYYDate:i]]) {
            
            [button setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
            strRegionDate = [self getYYYYDate:i];
        }else{
            
            button.backgroundColor = [UIColor clearColor];
        }
        
        [button addTarget:self action:@selector(buttonAciton:) forControlEvents:UIControlEventTouchUpInside];
        [_baseScrollView addSubview:button];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(5 +buttonWidth, buttonTop, 1, 30)];
        lineView1.backgroundColor = RGBCOLOR(237, 237, 237);
        if (i == 4) {
            lineView1.hidden = YES;
        }
        [_baseScrollView addSubview:lineView1];
        
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////第二块///////////////////////////////////////
    
    taskTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 210-64, kScreenWidth-40, 60)];
    taskTextView.font = [UIFont systemFontOfSize:13.0];
    taskTextView.delegate = self;
    taskTextView.layer.borderWidth = 1.0;
    taskTextView.layer.borderColor = [RGBCOLOR(236, 236, 236) CGColor];
    [_baseScrollView addSubview:taskTextView];
    
    placeholderLabel = [UnityLHClass initUILabel:@"请输入任务名称" font:12.0 color:[UIColor grayColor] rect:CGRectMake(5, 3, 100, 20)];
    [taskTextView addSubview:placeholderLabel];
    
    if ([[self.dic objectForKey:@"taskContent"] isEqualToString:@""]) {
        taskTextView.text = @"";
        strTaskContent = @"";
        placeholderLabel.hidden = NO;
    }else{
        
        placeholderLabel.hidden = YES;
        taskTextView.text = [[self.dic objectForKey:@"taskContent"] description];
        strTaskContent = taskTextView.text;
        
    }

    ////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////第三块///////////////////////////////////////
    
    checkFiled = [[UITextField alloc]initWithFrame:CGRectMake(20, 140+80*2-64, kScreenWidth-110, 25)];
    checkFiled.placeholder = @"选择并输入任务地点";
    checkFiled.font = [UIFont systemFontOfSize:12.0];
    checkFiled.layer.borderWidth = 1.0;
    checkFiled.layer.borderColor = [RGBCOLOR(236, 236, 236) CGColor];
    checkFiled.backgroundColor = [UIColor whiteColor];
    checkFiled.delegate = self;
    [_baseScrollView addSubview:checkFiled];
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn setFrame:CGRectMake(kScreenWidth-80, 140+80*2-64, 60, 25)];
    checkBtn.backgroundColor = RGBCOLOR(0, 181, 255);
    [checkBtn setTitle:@"验 证" forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkBtn) forControlEvents:UIControlEventTouchUpInside];
    [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_baseScrollView addSubview:checkBtn];
    
    
    ////////////////////////////////////////////////////////////////////////////////
    
    
    sectionArr = @[@"附近局站",@"曾用局站",@"匹配局站"];
    sectionArray = [self.dic objectForKey:@"nearbyRegions"];
    
    sectionArray1 = [self.dic objectForKey:@"usedRegions"];
    sectionArray2 = [self.dic objectForKey:@"matchedRegions"];
//    sectionArray2 = [[NSMutableArray alloc]initWithObjects:@"第2区",@"第2区", @"第2区",@"第2区", nil];
    if (sectionArray.count == 0) {
        isOpen = NO;
    }else{
       isOpen = YES;
    }
    
    if (sectionArray1.count == 0) {
        isOpen1 = NO;
    }else{
        isOpen1 = YES;
    }
    
    if (sectionArray2.count == 0) {
        isOpen2 = NO;
    }else{
        isOpen2 = YES;
    }
    
//    isOpen = NO;
//    isOpen1 = NO;
//    isOpen2 = NO;

    
    myTableView.sectionHeaderHeight = 40;
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 280, kScreenWidth-30, kScreenHeight-280-64) style:UITableViewStyleGrouped];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.showsVerticalScrollIndicator = NO;
    [_baseScrollView addSubview:myTableView];

    NSLog(@"asd == %@",self.dic);
}

#pragma mark == 获取时间
-(NSString *)getDate :(NSInteger) dis
{
//    NSInteger dis = 3; //前后的天数
    
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"MM/dd"];
    
    
    
    if(dis!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        
        theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*dis ];
        //or
        theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
        
    }
    else
    {
        theDate = nowDate;
    }
    
    NSString *  locationString = [dateformatter stringFromDate:theDate];
//    NSLog(@"%@",locationString);
    return locationString;
}

-(NSString *)getYYYYDate :(NSInteger) dis
{
    //    NSInteger dis = 3; //前后的天数
    
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    
    
    if(dis!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        
        theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*dis ];
        //or
        theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
        
    }
    else
    {
        theDate = nowDate;
    }
    
    NSString *  locationString = [dateformatter stringFromDate:theDate];
//    NSLog(@"%@",locationString);
    return locationString;
}


#pragma mark == 选择任务完成时间
- (void)buttonAciton:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    
//    [button setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
//    [_selectedBtn setBackgroundColor:[UIColor clearColor]];
//    _selectedBtn = button;
    
    strRegionDate = [self getYYYYDate:sender.tag-100];
    
    UIButton *btn = (UIButton *)[_baseScrollView viewWithTag:100];
    UIButton *btn1 = (UIButton *)[_baseScrollView viewWithTag:101];
    UIButton *btn2 = (UIButton *)[_baseScrollView viewWithTag:102];
    UIButton *btn3 = (UIButton *)[_baseScrollView viewWithTag:103];
    UIButton *btn4 = (UIButton *)[_baseScrollView viewWithTag:104];
    UIButton *btn5 = (UIButton *)[_baseScrollView viewWithTag:105];
    UIButton *btn6 = (UIButton *)[_baseScrollView viewWithTag:106];
    UIButton *btn7 = (UIButton *)[_baseScrollView viewWithTag:107];
    UIButton *btn8 = (UIButton *)[_baseScrollView viewWithTag:108];
    UIButton *btn9 = (UIButton *)[_baseScrollView viewWithTag:109];
    
    
    if (sender.tag == 100) {
        [btn setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [btn1 setBackgroundColor:[UIColor clearColor]];
        [btn2 setBackgroundColor:[UIColor clearColor]];
        [btn3 setBackgroundColor:[UIColor clearColor]];
        [btn4 setBackgroundColor:[UIColor clearColor]];
        [btn5 setBackgroundColor:[UIColor clearColor]];
        [btn6 setBackgroundColor:[UIColor clearColor]];
        [btn7 setBackgroundColor:[UIColor clearColor]];
        [btn8 setBackgroundColor:[UIColor clearColor]];
        [btn9 setBackgroundColor:[UIColor clearColor]];
        
    }else if (sender.tag == 101) {
        [btn1 setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn2 setBackgroundColor:[UIColor clearColor]];
        [btn3 setBackgroundColor:[UIColor clearColor]];
        [btn4 setBackgroundColor:[UIColor clearColor]];
        [btn5 setBackgroundColor:[UIColor clearColor]];
        [btn6 setBackgroundColor:[UIColor clearColor]];
        [btn7 setBackgroundColor:[UIColor clearColor]];
        [btn8 setBackgroundColor:[UIColor clearColor]];
        [btn9 setBackgroundColor:[UIColor clearColor]];
    }else if (sender.tag == 102) {
        
        [btn2 setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [btn1 setBackgroundColor:[UIColor clearColor]];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn3 setBackgroundColor:[UIColor clearColor]];
        [btn4 setBackgroundColor:[UIColor clearColor]];
        [btn5 setBackgroundColor:[UIColor clearColor]];
        [btn6 setBackgroundColor:[UIColor clearColor]];
        [btn7 setBackgroundColor:[UIColor clearColor]];
        [btn8 setBackgroundColor:[UIColor clearColor]];
        [btn9 setBackgroundColor:[UIColor clearColor]];
        
    }else if (sender.tag == 103) {
        
        [btn3 setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [btn1 setBackgroundColor:[UIColor clearColor]];
        [btn2 setBackgroundColor:[UIColor clearColor]];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn4 setBackgroundColor:[UIColor clearColor]];
        [btn5 setBackgroundColor:[UIColor clearColor]];
        [btn6 setBackgroundColor:[UIColor clearColor]];
        [btn7 setBackgroundColor:[UIColor clearColor]];
        [btn8 setBackgroundColor:[UIColor clearColor]];
        [btn9 setBackgroundColor:[UIColor clearColor]];
        
    }else if (sender.tag == 104) {
        
        [btn4 setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [btn1 setBackgroundColor:[UIColor clearColor]];
        [btn2 setBackgroundColor:[UIColor clearColor]];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn3 setBackgroundColor:[UIColor clearColor]];
        [btn5 setBackgroundColor:[UIColor clearColor]];
        [btn6 setBackgroundColor:[UIColor clearColor]];
        [btn7 setBackgroundColor:[UIColor clearColor]];
        [btn8 setBackgroundColor:[UIColor clearColor]];
        [btn9 setBackgroundColor:[UIColor clearColor]];
        
    }else if (sender.tag == 105) {
        
        [btn5 setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [btn1 setBackgroundColor:[UIColor clearColor]];
        [btn2 setBackgroundColor:[UIColor clearColor]];
        [btn3 setBackgroundColor:[UIColor clearColor]];
        [btn4 setBackgroundColor:[UIColor clearColor]];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn6 setBackgroundColor:[UIColor clearColor]];
        [btn7 setBackgroundColor:[UIColor clearColor]];
        [btn8 setBackgroundColor:[UIColor clearColor]];
        [btn9 setBackgroundColor:[UIColor clearColor]];
        
    }else if (sender.tag == 106) {
        
        [btn6 setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [btn1 setBackgroundColor:[UIColor clearColor]];
        [btn2 setBackgroundColor:[UIColor clearColor]];
        [btn3 setBackgroundColor:[UIColor clearColor]];
        [btn4 setBackgroundColor:[UIColor clearColor]];
        [btn5 setBackgroundColor:[UIColor clearColor]];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn7 setBackgroundColor:[UIColor clearColor]];
        [btn8 setBackgroundColor:[UIColor clearColor]];
        [btn9 setBackgroundColor:[UIColor clearColor]];
        
    }else if (sender.tag == 107) {
        
        [btn7 setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [btn1 setBackgroundColor:[UIColor clearColor]];
        [btn2 setBackgroundColor:[UIColor clearColor]];
        [btn3 setBackgroundColor:[UIColor clearColor]];
        [btn4 setBackgroundColor:[UIColor clearColor]];
        [btn5 setBackgroundColor:[UIColor clearColor]];
        [btn6 setBackgroundColor:[UIColor clearColor]];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn8 setBackgroundColor:[UIColor clearColor]];
        [btn9 setBackgroundColor:[UIColor clearColor]];
        
    }else if (sender.tag == 108) {
        
        [btn8 setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [btn1 setBackgroundColor:[UIColor clearColor]];
        [btn2 setBackgroundColor:[UIColor clearColor]];
        [btn3 setBackgroundColor:[UIColor clearColor]];
        [btn4 setBackgroundColor:[UIColor clearColor]];
        [btn5 setBackgroundColor:[UIColor clearColor]];
        [btn6 setBackgroundColor:[UIColor clearColor]];
        [btn7 setBackgroundColor:[UIColor clearColor]];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn9 setBackgroundColor:[UIColor clearColor]];
        
    }else if (sender.tag == 109) {
        
        [btn9 setBackgroundColor:[UIColor colorWithRed:139.0/255.0 green:206.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [btn1 setBackgroundColor:[UIColor clearColor]];
        [btn2 setBackgroundColor:[UIColor clearColor]];
        [btn3 setBackgroundColor:[UIColor clearColor]];
        [btn4 setBackgroundColor:[UIColor clearColor]];
        [btn5 setBackgroundColor:[UIColor clearColor]];
        [btn6 setBackgroundColor:[UIColor clearColor]];
        [btn7 setBackgroundColor:[UIColor clearColor]];
        [btn8 setBackgroundColor:[UIColor clearColor]];
        [btn setBackgroundColor:[UIColor clearColor]];
        
    }
    
}

#pragma mark == 右上方按钮
-(void)rightAction
{
    NSLog(@"右上方");
    [taskTextView resignFirstResponder];
    [checkFiled resignFirstResponder];
    if (strRegionDate == nil || strRegionDate.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"请选择任务完成时间" :@"确定" :nil];
    }else if (strTaskContent == nil || strTaskContent.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"请输入任务内容" :@"确定" :nil];
    }else if (strRegionId == nil || strRegionId.length <= 0){
       [self showAlertWithTitle:@"提示" :@"请选择任务地点" :@"确定" :nil];
    }else{
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myTask/AddMyTaskInfo";
        paraDict[@"taskContent"] = strTaskContent; //任务内容
        paraDict[@"taskType"] = @"10"; //任务类型CODE
        paraDict[@"regionId"] = strRegionId; //局站ID
        paraDict[@"regionName"] = strRegionName; //局站名称
        paraDict[@"regionAddress"] = strRegionAddress; //局站地址
        paraDict[@"planEndDate"] = strRegionDate; //计划完成时间（YYYY-MM-dd格式）
        
        NSLog(@" ===> %@",paraDict);
        
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"])
            {
                taskTextView.text = @"";
                checkFiled.text = @"";
                strTaskContent = @"";
                strRegionId = @"";
                strRegionName = @"";
                strRegionAddress = @"";
                [self showAlertWithTitle:@"提示" :@"新增成功" :@"确定" :nil];
                
            }else{
                
            }
            
        }, ^(id result) {
            
        });
 
    }
    
    
}

#pragma mark == 验证
-(void)checkBtn
{
    [checkFiled resignFirstResponder];
    checkFiled.text = @"";
    if (strAddress == nil || strAddress.length <= 0) {
        [self showAlertWithTitle:@"提示" :@"选择并输入任务地点" :@"确定" :nil];
    }else{
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myTask/GetRegionByNameForMyTask";
        paraDict[@"regionName"] = strAddress;
        
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            strAddress = @"";
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                isOpen2 = YES;
                sectionArray2 = [result objectForKey:@"list"];
                [myTableView reloadData];
            }
        }, ^(id result) {
            
        });
    }
    
}

#pragma mark == UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -=30;
    frame.size.height +=30;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    strAddress = textField.text;
    
}




#pragma mark == UITextView
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    strTaskContent = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{    if (![text isEqualToString:@""])
    
{
    
    placeholderLabel.hidden = YES;
    
}
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        
        placeholderLabel.hidden = NO;
        
    }
    
    return YES;
    
}

#pragma mark == UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return  isOpen?sectionArray.count:0;
    }else if (section==1) {
        
        return  isOpen1?sectionArray1.count:0;
        
    }else if (section==2) {
        
        return  isOpen2?sectionArray2.count:0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sectioncellIdentifier = @"sectioncell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sectioncellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sectioncellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section==0) {
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        NSString *str = [NSString stringWithFormat:@"%@%@",[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"regionName"] description],[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description]];
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description]].location);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] range:redRange];
        cell.textLabel.attributedText = noteStr;

//        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"regionName"] description],[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description]];
    }
    
    if (indexPath.section==1) {
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        NSString *str = [NSString stringWithFormat:@"%@%@",[[[sectionArray1 objectAtIndex:indexPath.row] objectForKey:@"regionName"] description],[[[sectionArray1 objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description]];
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:[[[sectionArray1 objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description]].location);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] range:redRange];
        cell.textLabel.attributedText = noteStr;

//        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",[[[sectionArray1 objectAtIndex:indexPath.row] objectForKey:@"regionName"] description],[[[sectionArray1 objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description]];
    }
    
    if (indexPath.section==2) {
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        NSString *str = [NSString stringWithFormat:@"%@%@",[[[sectionArray2 objectAtIndex:indexPath.row] objectForKey:@"regionName"] description],[[[sectionArray2 objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description]];
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:[[[sectionArray2 objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description]].location);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] range:redRange];
        cell.textLabel.attributedText = noteStr;
//        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",[[[sectionArray2 objectAtIndex:indexPath.row] objectForKey:@"regionName"] description],[[[sectionArray2 objectAtIndex:indexPath.row] objectForKey:@"regionAddress"] description]];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TemporaryHeadView *headv = [[TemporaryHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    headv.backgroundColor = RGBCOLOR(226, 226, 226);
    
    if (section == 0) {
        headv.label1.text = [NSString stringWithFormat:@"%@ (%d)",[sectionArr objectAtIndex:section],sectionArray.count];
    }else if (section == 1){
        headv.label1.text = [NSString stringWithFormat:@"%@ (%d)",[sectionArr objectAtIndex:section],sectionArray1.count];
    }else{
        headv.label1.text = [NSString stringWithFormat:@"%@ (%d)",[sectionArr objectAtIndex:section],sectionArray2.count];
    }
    
    
    headv.label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    
    headv.bgBtn.tag = 1000+section;
    
    [headv.bgBtn addTarget:self action:@selector(expButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return headv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0){
        
    }else if (indexPath.section==1){
        
    }else if (indexPath.section==2){
        
        checkFiled.text = [[sectionArray2 objectAtIndex:indexPath.row] objectForKey:@"regionName"];
        strAddress = [[sectionArray2 objectAtIndex:indexPath.row] objectForKey:@"regionName"];
        
        strRegionName = [[sectionArray2 objectAtIndex:indexPath.row] objectForKey:@"regionName"];
        
        strRegionAddress = [[sectionArray2 objectAtIndex:indexPath.row] objectForKey:@"regionAddress"];
        
        strRegionId = [[[sectionArray2 objectAtIndex:indexPath.row] objectForKey:@"regionId"] description];
    }
}

-(void)expButtonAction:(UIButton*)btn
{
    if (btn.tag == 1000) {
        isOpen =!isOpen;
    }
    if (btn.tag == 1001) {
        isOpen1 =!isOpen1;
    }
    if (btn.tag == 1002) {
        isOpen2 =!isOpen2;
    }
    
    [myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
