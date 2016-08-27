//
//  PersonnelViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/10/20.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "PersonnelViewController.h"
#import "UIView+size.h"
#import "PeopleNumViewController.h"

@interface PersonnelViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *backview;
    UIView *pickview;
    UIView *dateView;
    UIDatePicker *datePicker;
    NSString *dateStr;
    UIButton *dateBtn;
    NSArray *leftArr;
    UITableView *myTableView;
    NSMutableArray *dataArr;
}
@end

@implementation PersonnelViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"人员动向一览查询";
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    [self addNavigationLeftButton];
    
    dataArr = [[NSMutableArray alloc]initWithCapacity:10];
    [dataArr addObjectsFromArray:self.chuanArr];
    [self initView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    dateStr = [formatter stringFromDate:[NSDate date]];
    
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

-(void)initView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateBtn setFrame:CGRectMake(10, 80, 120, 23)];
    [dateBtn setTitle:dateString forState:UIControlStateNormal];
    [dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dateBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    dateBtn.layer.borderWidth = 1.0;
    dateBtn.layer.borderColor = RGB(0x666666).CGColor;
    [dateBtn addTarget:self action:@selector(dateBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dateBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(kScreenWidth-70, 80, 60, 23)];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:RGBCOLOR(0, 157, 232)];
    searchBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 110, kScreenWidth-20, kScreenHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIView *headView = [self tableHeadView];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableHeaderView = headView;
    [bgView addSubview:myTableView];
    
    
    

}

#pragma mark ==  UITableView
-(UIView *)tableHeadView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    UILabel *classLable = [UnityLHClass initUILabel:@"任务类型" font:12.0 color:RGBCOLOR(0, 157, 232) rect:CGRectMake(20, 25, 80, 20)];
    classLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    [headerView addSubview:classLable];
    
//    leftArr = @[@"故障",@"预约",@"周期故障",@"隐患",@"自定义"];
    NSMutableArray *numArr = [[NSMutableArray alloc]initWithCapacity:10];
    NSLog(@"%@",dataArr);
    for (int i = 0; i < dataArr.count; i++) {
        
        UILabel *leftLable = [UnityLHClass initUILabel:[[[dataArr objectAtIndex:i] objectForKey:@"typeName"] description] font:12.0 color:[UIColor whiteColor] rect:CGRectMake(0, 50+27*i, 70, 20)];
        leftLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        leftLable.textAlignment = NSTextAlignmentRight;
        leftLable.textColor = [UIColor blackColor];
        [headerView addSubview:leftLable];
        
        NSString *strNum = [[[dataArr objectAtIndex:i] objectForKey:@"peopleNum"] description];
        
        [numArr addObject:strNum];
        
    }
    
    UIImage *img = [UIImage imageNamed:@"bsrt.png"];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(80, 50, 3, img.size.height/2+10)];
    lineView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:lineView];
    
    UIImageView *txtImgView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 40, img.size.width/2, img.size.height/2+10)];
    txtImgView.image = img;
    txtImgView.userInteractionEnabled = YES;
    [headerView addSubview:txtImgView];
    
    NSLog(@"%@",numArr);
    NSNumber * max = [numArr valueForKeyPath:@"@max.floatValue"];
    
    float maxValue = max.floatValue;
    

    for (int i = 0; i < numArr.count; i++) {
        
        UIView *txtView = [[UIView alloc]init];
        txtView.backgroundColor = RGBCOLOR(0, 153, 153);
        txtView.layer.masksToBounds = YES;
        txtView.layer.cornerRadius = 5;
        
        if ([[numArr objectAtIndex:i] floatValue] == 0) {
            txtView.frame = CGRectMake(10, 10+27*i, 0, 20);
        }else{
            txtView.frame = CGRectMake(10, 10+27*i, [[numArr objectAtIndex:i] floatValue]*200/maxValue, 20);
        }
        
        [txtImgView addSubview:txtView];
        
        

//        CGSize numWith = [self numHight:[NSString stringWithFormat:@"%.f",[[numArr objectAtIndex:i] floatValue]]];
        
        UILabel *numLable = [UnityLHClass initUILabel:[NSString stringWithFormat:@"%.f",[[numArr objectAtIndex:i] floatValue]] font:11.0 color:[UIColor whiteColor] rect:CGRectMake(0, 0, [[numArr objectAtIndex:i] floatValue]*200, 20)];
        numLable.textAlignment = NSTextAlignmentRight;
        numLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        
        if ([[numArr objectAtIndex:i] floatValue] == 0) {
            numLable.frame = CGRectMake(0, 0, 0, 20);
        }else{
            numLable.frame = CGRectMake(0, 0, [[numArr objectAtIndex:i] floatValue]*200/maxValue, 20);
        }
        
        [txtView addSubview:numLable];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 10+27*i, 200, 20)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 100+i;
        [button addTarget:self action:@selector(btnClass:) forControlEvents:UIControlEventTouchUpInside];
        [txtImgView addSubview:button];
    }
    
    UILabel *peopleNumLable = [UnityLHClass initUILabel:@"人员数量" font:11.0 color:RGBCOLOR(0, 157, 232) rect:CGRectMake(kScreenWidth-80, img.size.height/2+55, 50, 20)];
    peopleNumLable.textAlignment = NSTextAlignmentRight;
    peopleNumLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    [headerView addSubview:peopleNumLable];
    
    return headerView;
}


- (CGSize)numHight:(NSString*)str
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize constraint = CGSizeMake(180, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}



#pragma mark == 选取日期
-(void)dateBtn
{
    backview.hidden = NO;
    pickview.hidden = NO;
    
    dateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 280)];
    dateView.backgroundColor = [UIColor whiteColor];
    dateView.alpha = 1.0;
    [pickview addSubview:dateView];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth-20, 25)];
    titleLable.text = @"请选择日期";
    titleLable.textColor = [UIColor blackColor];
    titleLable.font = [UIFont systemFontOfSize:17.0];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [dateView addSubview:titleLable];
    
    //设置日期选择器的英文模式
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth-20, 200)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.locale = locale;
    datePicker.date = [NSDate date];
//    datePicker.minimumDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateStr = [dateFormatter stringFromDate:datePicker.date];
    
    
    datePicker.layer.borderWidth = 1.0;
    datePicker.layer.borderColor = [UIColor blueColor].CGColor;
    [dateView addSubview:datePicker];
    // 获取现在的时间
    NSDate *date = [NSDate date];
    // 设置picker上得时间
    [datePicker setDate:date animated:YES];
    
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    
    UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame=CGRectMake(5, 240, 140, 30);
    [okBtn addTarget:self action:@selector(okChosedate:) forControlEvents:UIControlEventTouchUpInside];
//    okBtn.tag = tag;
    okBtn.backgroundColor = [UIColor orangeColor];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [dateView addSubview:okBtn];
    
    UIButton *cancleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame=CGRectMake(155, 240, 140, 30);
    [cancleBtn addTarget:self action:@selector(cancleChosedate) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.backgroundColor = [UIColor orangeColor];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [dateView addSubview:cancleBtn];
}
-(void)cancleChosedate
{
    backview.hidden = YES;
    pickview.hidden = YES;
    [dateView removeFromSuperview];
}

-(void)okChosedate:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateStr = [dateFormatter stringFromDate:datePicker.date];
    backview.hidden = YES;
    pickview.hidden = YES;
    [dateView removeFromSuperview];
    NSLog(@"点击确认后的时间 == %@",dateStr);
    [dateBtn setTitle:dateStr forState:UIControlStateNormal];
    NSLog(@"tag == %d",sender.tag);
}

- (void)dateChanged
{
    NSLog(@"日期改变了");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateStr = [dateFormatter stringFromDate:datePicker.date];
    NSLog(@"dateStr == %@",dateStr);
    
}

#pragma mark == 查询
-(void)searchBtn
{
    if (dateStr == nil || dateStr.length <= 0) {
        
    }else{
        
        [dataArr removeAllObjects];
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myInfo/GetPeopleTrends";
        paraDict[@"queryTime"] = dateStr;
        NSLog(@"paraDict == %@",paraDict);
        httpGET2(paraDict, ^(id result) {
            
            NSLog(@"%@",result);
            
            if ([result[@"result"] isEqualToString:@"0000000"]){
                dataArr = (NSMutableArray *)[result objectForKey:@"list"];
                UIView *headView = [self tableHeadView];
                myTableView.tableHeaderView = headView;
                [myTableView reloadData];
            }
            
        }, ^(id result) {
                
        });
    }
    
}


#pragma mark == 各个任务类型点击事件
-(void)btnClass:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    
    NSString *strTitle = [NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:sender.tag-100] objectForKey:@"typeName"]];
    NSString *strTypeId = [NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:sender.tag-100] objectForKey:@"typeId"]];
    
    NSString *strPeopleNum = [NSString stringWithFormat:@"%@",[[[dataArr objectAtIndex:sender.tag-100] objectForKey:@"peopleNum"] description]];
    
    if (dateStr == nil || dateStr.length <= 0) {
        
    }else if (strPeopleNum.floatValue == 0){
        
    }else{
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myInfo/GetPeopleTaskNum";
        paraDict[@"typeId"] = strTypeId;
        paraDict[@"queryTime"] = dateStr;
        
        httpGET2(paraDict, ^(id result) {
            
            NSLog(@"%@",result);
            
            if ([result[@"result"] isEqualToString:@"0000000"]){
                
                PeopleNumViewController *peopleNumVC = [[PeopleNumViewController alloc]init];
                peopleNumVC.strTitle = strTitle;
                peopleNumVC.dataDic = result[@"list"];
                peopleNumVC.dateStr = dateStr;
                peopleNumVC.typeId = strTypeId;
                peopleNumVC.regionName = [self.chuanDic objectForKey:@"regionName"];
                [self.navigationController pushViewController:peopleNumVC animated:YES];
            }
            
        }, ^(id result) {
            
        });
    }
//    PeopleNumViewController *peopleNumVC = [[PeopleNumViewController alloc]init];
//    peopleNumVC.strTitle = strTitle;
//    [self.navigationController pushViewController:peopleNumVC animated:YES];
    
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
