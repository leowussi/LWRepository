//
//  PersonalWorkInfoViewController.m
//  telecom
//
//  Created by iOS开发工程师 on 15/11/4.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "PersonalWorkInfoViewController.h"
#import "PersonalWorkInfoTableViewCell.h"

@interface PersonalWorkInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    
    NSInteger btnTag;
    
    NSArray *leftArr;
    
    NSMutableDictionary *todayDetailArr;
    NSMutableDictionary *monthDetailArr;
    NSMutableDictionary *weekDetailArr;
    NSMutableDictionary *allDetailArr;
}

@end

@implementation PersonalWorkInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
    [self getPersonalWorkInfo];
}

-(void)getPersonalWorkInfo
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"myInfo/GetPersonalWorkInfo";
    
    httpGET2(paraDict, ^(id result) {
        
        NSLog(@"%@",result);
        
        if ([result[@"result"] isEqualToString:@"0000000"]){
            
            todayDetailArr = [result objectForKey:@"todayDetail"];
            monthDetailArr = [result objectForKey:@"monthDetail"];
            weekDetailArr = [result objectForKey:@"weekDetail"];
            allDetailArr = [result objectForKey:@"allDetail"];
            [myTableView reloadData];
        }
        
    }, ^(id result) {
        
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人工作信息";
    [self addNavigationLeftButton];
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    
    todayDetailArr = [[NSMutableDictionary alloc]initWithCapacity:10];
    monthDetailArr = [[NSMutableDictionary alloc]initWithCapacity:10];
    weekDetailArr = [[NSMutableDictionary alloc]initWithCapacity:10];
    allDetailArr = [[NSMutableDictionary alloc]initWithCapacity:10];
    
    leftArr = @[@"里       程",@"工       时",@"巡检任务数",@"解决故障数",@"发现隐患数"];
//    leftArr = @[@"里       程",@"工       时",@"巡检任务数",@"解决故障数",@"发现隐患数",@"运维积分",@"全局排名"];
    
    btnTag = 0;
    
    [self initView];
}

-(void)initView
{
    NSArray* array1  = [NSArray arrayWithObjects:@"今日",@"本周",@"当月",@"累计", nil];
    
    for (int i = 0; i<array1.count; i++) {
        
        UIButton* butt = [UIButton buttonWithType:UIButtonTypeCustom];
        [butt setFrame:CGRectMake((kScreenWidth-20)/4*i+10, 15, (kScreenWidth-20)/4, 30)];
        [butt setTag:10+i];
        [butt setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
        [butt addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_baseScrollView addSubview:butt];
        
        CGSize sizeWith = [self labelHight:[array1 objectAtIndex:i]];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, sizeWith.width+5, 25)];
        label.text = [array1 objectAtIndex:i];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];
        label.tag = 20+i;
        label.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        [butt addSubview:label];
        
        if (i == 0) {
            [butt setBackgroundImage:[UIImage imageNamed:@"tab_bg_white"] forState:UIControlStateNormal];
            label.textColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
            
        }
    }
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 105, kScreenWidth-20, kScreenHeight-64)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth-20, kScreenHeight-64) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [bgView addSubview:myTableView];
    
}


-(void)clickBtn:(UIButton *)sender
{
    UIImage *wxzBtnImg = [UIImage imageNamed:@"tab_bg"]; //未选中button的图片
    UIImage *xzBtnImg = [UIImage imageNamed:@"tab_bg_white"];  //选中button的图片
    
    UIButton* btn1 = (UIButton*)[_baseScrollView viewWithTag:10];
    UIButton* btn2 = (UIButton*)[_baseScrollView viewWithTag:11];
    UIButton* btn3 = (UIButton*)[_baseScrollView viewWithTag:12];
    UIButton* btn4 = (UIButton*)[_baseScrollView viewWithTag:13];
    
    UILabel *titleLable1 = (UILabel *)[_baseScrollView viewWithTag:20];
    UILabel *titleLable2 = (UILabel *)[_baseScrollView viewWithTag:21];
    UILabel *titleLable3 = (UILabel *)[_baseScrollView viewWithTag:22];
    UILabel *titleLable4 = (UILabel *)[_baseScrollView viewWithTag:23];
    
    
    
    if (sender.tag == 10) {
        NSLog(@"0");
        [btn1 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn4 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        
        titleLable1.textColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
        titleLable2.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        titleLable3.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        titleLable4.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        
        btnTag = 0;
        [myTableView reloadData];
        
    }else if (sender.tag == 11) {
        NSLog(@"1");
        [btn1 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn4 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        
        titleLable1.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        titleLable2.textColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
        titleLable3.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        titleLable4.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        
        btnTag = 1;
        [myTableView reloadData];
        
    }else if (sender.tag == 12) {
        NSLog(@"2");
        [btn1 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        [btn4 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        
        titleLable1.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        titleLable2.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        titleLable3.textColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
        titleLable4.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        
        btnTag = 2;
        [myTableView reloadData];
        
    }else if (sender.tag == 13) {
        NSLog(@"3");
        [btn1 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn2 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn3 setBackgroundImage:wxzBtnImg forState:UIControlStateNormal];
        [btn4 setBackgroundImage:xzBtnImg forState:UIControlStateNormal];
        
        titleLable1.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        titleLable2.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        titleLable3.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        titleLable4.textColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
        
        btnTag = 3;
         [myTableView reloadData];
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return leftArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *personalCell = @"personalCell";
    PersonalWorkInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:personalCell];
    if (!cell) {
        cell = [[PersonalWorkInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personalCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = RGBCOLOR(250, 250, 250);
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.leftLable.text = [NSString stringWithFormat:@"%@:",[leftArr objectAtIndex:indexPath.row]];
    
    switch (btnTag) {
        case 0:
        {
            if (indexPath.row == 0) {//里程
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 公里",[todayDetailArr objectForKey:@"mileageNum"]];
            }
            if (indexPath.row == 1) {//工时
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 小时",[todayDetailArr objectForKey:@"hoursNum"]];
            }
            
            if (indexPath.row == 2) {//巡检任务数
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 项",[todayDetailArr objectForKey:@"inspectionNum"]];
            }
            
            if (indexPath.row == 3) {//解决故障数
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 项",[todayDetailArr objectForKey:@"falutNum"]];
            }
            
            if (indexPath.row == 4) {//发现隐患数
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 项",[todayDetailArr objectForKey:@"riskNum"]];
            }
            
            if (indexPath.row == 5) {//运维积分
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 分",[todayDetailArr objectForKey:@"vantagesNum"]];
            }
            
            if (indexPath.row == 6) {//全局排名
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 名",[todayDetailArr objectForKey:@"rankNum"]];
            }
        }
            break;
            
        case 1:
        {
            if (indexPath.row == 0) {//里程
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 公里",[weekDetailArr objectForKey:@"mileageNum"]];
            }
            if (indexPath.row == 1) {//工时
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 小时",[weekDetailArr objectForKey:@"hoursNum"]];
            }
            
            if (indexPath.row == 2) {//巡检任务数
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 项",[weekDetailArr objectForKey:@"inspectionNum"]];
            }
            
            if (indexPath.row == 3) {//解决故障数
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 项",[weekDetailArr objectForKey:@"falutNum"]];
            }
            
            if (indexPath.row == 4) {//发现隐患数
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 项",[weekDetailArr objectForKey:@"riskNum"]];
            }
            
            if (indexPath.row == 5) {//运维积分
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 分",[weekDetailArr objectForKey:@"vantagesNum"]];
            }
            
            if (indexPath.row == 6) {//全局排名
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 名",[weekDetailArr objectForKey:@"rankNum"]];
            }
        }
            break;
            
        case 2:
        {
            if (indexPath.row == 0) {//里程
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 公里",[monthDetailArr objectForKey:@"mileageNum"]];
            }
            if (indexPath.row == 1) {//工时
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 小时",[monthDetailArr objectForKey:@"hoursNum"]];
            }
            
            if (indexPath.row == 2) {//巡检任务数
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 项",[monthDetailArr objectForKey:@"inspectionNum"]];
            }
            
            if (indexPath.row == 3) {//解决故障数
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 项",[monthDetailArr objectForKey:@"falutNum"]];
            }
            
            if (indexPath.row == 4) {//发现隐患数
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 项",[monthDetailArr objectForKey:@"riskNum"]];
            }
            
            if (indexPath.row == 5) {//运维积分
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 分",[monthDetailArr objectForKey:@"vantagesNum"]];
            }
            
            if (indexPath.row == 6) {//全局排名
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 名",[monthDetailArr objectForKey:@"rankNum"]];
            }
        }
            break;
            
        case 3:
        {
            if (indexPath.row == 0) {//里程
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 公里",[allDetailArr objectForKey:@"mileageNum"]];
            }
            if (indexPath.row == 1) {//工时
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 小时",[allDetailArr objectForKey:@"hoursNum"]];
            }
            
            if (indexPath.row == 2) {//巡检任务数
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 项",[allDetailArr objectForKey:@"inspectionNum"]];
            }
            
            if (indexPath.row == 3) {//解决故障数
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 项",[allDetailArr objectForKey:@"falutNum"]];
            }
            
            if (indexPath.row == 4) {//发现隐患数
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 项",[allDetailArr objectForKey:@"riskNum"]];
            }
            
            if (indexPath.row == 5) {//运维积分
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 分",[allDetailArr objectForKey:@"vantagesNum"]];
            }
            
            if (indexPath.row == 6) {//全局排名
                cell.rightLable.text = [NSString stringWithFormat:@"%@ 名",[allDetailArr objectForKey:@"rankNum"]];
            }
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
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
