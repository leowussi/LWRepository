//
//  UrgentViewController.m
//  i YunWei
//
//  Created by 郝威斌 on 15/5/8.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "UrgentViewController.h"
#import "UrgentTableViewCell.h"
#import "YuYueTableViewCell.h"
#import "WeekWorkTableViewCell.h"
#import "YinHTableViewCell.h"
#import "PullTableView.h"

#import "MyRepairFaultDetailKB.h"
#import "MyBookingList2.h"
#import "TaskListView.h"
#import "TaskJiaohunList.h"
#import "TaskDetail.h"
#import "HiddenDangerController.h"
#import "MyTaskListViewController.h"
#import "MyBookingSGYYController.h"

@interface UrgentViewController ()<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
{
    PullTableView *myTableView;  //故障
    PullTableView *myTableView1; //预约
    PullTableView *myTableView2; //周期工作
    PullTableView *myTableView3; //隐患
    NSDictionary *data;
    NSDictionary *data1;
    NSDictionary *data2;
    NSDictionary *data3;
    NSArray *array;
    NSArray *sectionArra;
    
    UIButton *moreBtn;
    BOOL ismoreToday;
    BOOL ismoreTomorrow;
    
    NSMutableArray *cycleDaylistArr;   //周期工作今日信息
    NSMutableArray *cycleAfterlistArr; //周期工作明日信息
    
    NSMutableArray *faultDaylistArr;   //故障今日信息
    NSMutableArray *faultAfterlistArr; //故障明日信息
    
    NSMutableArray *orderDaylistArr;   //预约今日信息
    NSMutableArray *orderAfterlistArr; //预约明日信息
    
    NSMutableArray *dangerDaylistArr;   //隐患今日信息
    NSMutableArray *dangerAfterlistArr; //隐患明日信息
}
@end
static int a = 1;
@implementation UrgentViewController


-(void)addLeftSearchBar
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];//allocate titleView
    titleView.backgroundColor = [UIColor clearColor];
    UIImage *searchImg = [UIImage imageNamed:@"search_bg.png"];
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-3, 7, kScreenWidth-120, searchImg.size.height/3+5)];
    searchImgView.image = searchImg;
    searchImgView.userInteractionEnabled = YES;
    [titleView addSubview:searchImgView];
    
    UITextField *searchField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-130, searchImg.size.height/3+5)];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.backgroundColor = [UIColor clearColor];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.placeholder = @"输入站点、名称";
    searchField.textColor = [UIColor whiteColor];
    searchField.font = [UIFont systemFontOfSize:15.0];
    [searchImgView addSubview:searchField];
    
    self.navigationItem.titleView = titleView;
}

- (void)addNavRightBtn:(NSString *)str
{
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardButton.frame = CGRectMake(kScreenWidth-[UIImage imageNamed:str].size.width/2, 12,[UIImage imageNamed:str].size.width/1.3,[UIImage imageNamed:str].size.height/1.3);
    [forwardButton setBackgroundImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}

-(void)rightBtn
{
    NSLog(@"点击了右边按钮");
}

-(void)viewWillAppear:(BOOL)animated
{
    [self hiddenBottomBar:YES];
    
}

-(void)getRequestData
{
    httpGET2(@{URL_TYPE : @"MyTask/GetLimitTaskInfo"}, ^(id result) {
        NSLog(@"%@",result);
        
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            [self setLabelText:result];
            
            faultDaylistArr = [result objectForKey:@"faultDaylist"];
            faultAfterlistArr = [result objectForKey:@"faultAfterlist"];
            
            orderDaylistArr = [result objectForKey:@"orderDaylist"];
            orderAfterlistArr = [result objectForKey:@"orderAfterlist"];
            
            cycleDaylistArr = [result objectForKey:@"cycleDaylist"];
            cycleAfterlistArr = [result objectForKey:@"cycleAfterlist"];
            
            dangerDaylistArr = [result objectForKey:@"dangerDaylist"];
            dangerAfterlistArr = [result objectForKey:@"dangerAfterlist"];

            
            if (faultDaylistArr.count == 0 && faultAfterlistArr.count == 0) {
                myTableView.hidden = YES;
            }else{
                data = [[NSDictionary alloc]initWithObjectsAndKeys:faultDaylistArr,@"one",faultAfterlistArr,@"two", nil];
                [myTableView reloadData];
            }
            
            if (orderDaylistArr.count == 0 && orderDaylistArr.count == 0) {
                myTableView1.hidden = YES;
            }else{
                data1 = [[NSDictionary alloc]initWithObjectsAndKeys:orderDaylistArr,@"one",orderDaylistArr,@"two", nil];
                [myTableView1 reloadData];
            }
            
            if (cycleDaylistArr.count == 0 && cycleAfterlistArr.count == 0) {
                myTableView2.hidden = YES;
            }else{
                data2 = [[NSDictionary alloc]initWithObjectsAndKeys:cycleDaylistArr,@"one",cycleAfterlistArr,@"two", nil];
                [myTableView2 reloadData];
            }

            if (dangerDaylistArr.count == 0 && dangerAfterlistArr.count == 0) {
                myTableView3.hidden = YES;
            }else{
                data3 = [[NSDictionary alloc]initWithObjectsAndKeys:dangerDaylistArr,@"one",dangerAfterlistArr,@"two", nil];
                [myTableView3 reloadData];
            }
            
            NSLog(@"data3 = %@",data3);
        }
    }, ^(id result) {
    });
}

- (void)setLabelText:(NSDictionary*)dic
{
    
    NSLog(@"%@",dic);
    UIButton *button = (UIButton*)[_baseScrollView viewWithTag:10];
    UIButton *button1 = (UIButton*)[_baseScrollView viewWithTag:11];
    UIButton *button2 = (UIButton*)[_baseScrollView viewWithTag:12];
    UIButton *button3 = (UIButton*)[_baseScrollView viewWithTag:13];
    NSDictionary* infoDic = [dic objectForKey:@"detail"];
    NSLog(@"%@",infoDic);
    
    UILabel* label1 = (UILabel*)[button viewWithTag:200];
    label1.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"faultCount"]];//floatValue
    NSLog(@"%@",label1.text);
    UILabel* label2 = (UILabel*)[button1 viewWithTag:201];
    label2.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"orderCount"]];
    NSLog(@"%@",label2.text);
    UILabel* label3 = (UILabel*)[button2 viewWithTag:202];
    label3.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"cycleCount"] ];
    UILabel* label4 = (UILabel*)[button3 viewWithTag:203];
    
    label4.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"dangerCount"] ];
    
    if ([label1.text isEqualToString:@"0"]) {
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [self navigl:@"紧急任务"];
    [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    [self addLeftSearchBar];
//    [self addNavRightBtn:@"menu_icon.png"];
    [self addNavigationLeftButton];
    
    faultDaylistArr = [[NSMutableArray alloc]initWithCapacity:10];
    faultAfterlistArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    orderDaylistArr = [[NSMutableArray alloc]initWithCapacity:10];
    orderAfterlistArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    cycleDaylistArr = [[NSMutableArray alloc]initWithCapacity:10];
    cycleAfterlistArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    dangerDaylistArr = [[NSMutableArray alloc]initWithCapacity:10];
    dangerAfterlistArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    [self getRequestData];
    
    [self initView];
    
    ismoreToday=NO;
    ismoreTomorrow=NO;
    
}

-(NSString *)GetTomorrowDay:(NSDate *)aDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy/MM/dd"];
    return [dateday stringFromDate:beginningOfWeek];
}

-(void)initView
{
 
    NSLog(@"%@",cycleAfterlistArr);
    
    NSArray* array1  = [NSArray arrayWithObjects:@"故障",@"预约",@"周期工作",@"隐患", nil];
    NSArray *numArr = @[@"1",@"2",@"5",@"1"];
    
    for (int i = 0; i<4; i++) {
        
        UIButton* butt = [UIButton buttonWithType:UIButtonTypeCustom];
        [butt setFrame:CGRectMake(kScreenWidth/4*i, 15, kScreenWidth/4, 30)];
        [butt setTag:10+i];
        [butt setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
        [butt addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_baseScrollView addSubview:butt];
        
        CGSize sizeWith = [self labelHight:[array1 objectAtIndex:i]];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, sizeWith.width+5, 25)];
        label.text = [array1 objectAtIndex:i];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];
        label.tag = 20+i;
        label.textColor = [UIColor colorWithRed:134.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1.0];
        [butt addSubview:label];
        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(sizeWith.width+15, 9, 12, 12)];
        numLabel.text = [numArr objectAtIndex:i];
        [numLabel setFont:[UIFont systemFontOfSize:11.0]];
        numLabel.tag = 200+i;
        numLabel.layer.masksToBounds = YES;
        numLabel.layer.cornerRadius = 6;
        numLabel.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = [UIColor whiteColor];
        [butt addSubview:numLabel];
        
        if (i == 0) {
            [butt setFrame:CGRectMake(kScreenWidth/4*i, 15, kScreenWidth/4-10, 30)];
            [butt setBackgroundImage:[UIImage imageNamed:@"tab_bg_white"] forState:UIControlStateNormal];
            label.textColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
            numLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
            
        }
        
        if (i == 1) {
            [butt setFrame:CGRectMake(kScreenWidth/4*i-10, 15, kScreenWidth/4-10, 30)];
        }
        
        if (i == 2) {
            [butt setFrame:CGRectMake(kScreenWidth/4*i-20, 15, kScreenWidth/4+25, 30)];
        }
        
        if (i == 3) {
            [butt setFrame:CGRectMake(kScreenWidth/4*i+5, 15, kScreenWidth/4-5, 30)];
        }
        
    }
    
    
    array = [[NSArray alloc]initWithObjects:@"one",@"two", nil];
    
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy/MM/dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSString *strToday = [NSString stringWithFormat:@"今日任务 %@",locationString];
    NSString *strTomorrow = [NSString stringWithFormat:@"明日任务 %@",[self GetTomorrowDay:[NSDate date]]];
    
    sectionArra = @[strToday,strTomorrow]; // 今日任务  明日任务
    
    myTableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth, kScreenHeight-110) style:UITableViewStyleGrouped];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.pullDelegate = self;
    [_baseScrollView addSubview:myTableView];
    _baseScrollView.scrollEnabled = NO;
//    [self setExtraCellLineHidden:myTableView];//去掉UITableView底部多余的分割线
    
    myTableView1 = [[PullTableView alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth, kScreenHeight-110) style:UITableViewStyleGrouped];
    myTableView1.dataSource = self;
    myTableView1.delegate = self;
    myTableView1.pullDelegate = self;
    myTableView1.hidden = YES;
    [_baseScrollView addSubview:myTableView1];
    _baseScrollView.scrollEnabled = NO;
//    [self setExtraCellLineHidden:myTableView1];//去掉UITableView底部多余的分割线
    
    
    
    myTableView2 = [[PullTableView alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth, kScreenHeight-110) style:UITableViewStyleGrouped];
    myTableView2.dataSource = self;
    myTableView2.delegate = self;
    myTableView2.pullDelegate = self;
    myTableView2.hidden = YES;
    [_baseScrollView addSubview:myTableView2];
    _baseScrollView.scrollEnabled = NO;
    //    [self setExtraCellLineHidden:myTableView2];//去掉UITableView底部多余的分割线
    
    myTableView3 = [[PullTableView alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth, kScreenHeight-110) style:UITableViewStyleGrouped];
    myTableView3.dataSource = self;
    myTableView3.delegate = self;
    myTableView3.pullDelegate = self;
    myTableView3.hidden = YES;
    [_baseScrollView addSubview:myTableView3];
    _baseScrollView.scrollEnabled = NO;
//    [self setExtraCellLineHidden:myTableView3];//去掉UITableView底部多余的分割线
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (CGSize)labelHight:(NSString*)str
{
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    CGSize constraint = CGSizeMake(180, 20000.0f);
    CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == myTableView) {
        
        return array.count;
        
    }else if (tableView == myTableView1){
        
        return array.count;
        
        
    }else if (tableView == myTableView2){
        
        return array.count;
        
    }else if (tableView == myTableView3){
        
        return array.count;
        
        
    }else{
        
        return 1;
        
        
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == myTableView) {
        
        NSString *string = [array objectAtIndex:section];
        NSArray *row = [data objectForKey:string];
//        if (section==0) {
//            if (!ismoreToday) {
//                return 3;
//            }else if (ismoreToday){
//                return row.count;
//            }
//        }else if (section==1){
//            
//            if (!ismoreTomorrow) {
//                return 2;
//            }
//            else if (ismoreTomorrow){
//                return row.count;
//            }
//            
//        }
        
//        return 0;
        return row.count;
        
    }else if (tableView == myTableView1) {
        
        NSString *string = [array objectAtIndex:section];
        NSArray *row = [data1 objectForKey:string];
//        if (section==0) {
//            if (!ismoreToday) {
//                return 3;
//            }else if (ismoreToday){
//                return row.count;
//            }
//        }else if (section==1){
//            
//            if (!ismoreTomorrow) {
//                return 2;
//            }
//            else if (ismoreTomorrow){
//                return row.count;
//            }
//            
//        }
//        
//        return 0;
        return row.count;
        
    }else if (tableView == myTableView2) {
        
        NSString *string = [array objectAtIndex:section];
        NSArray *row = [data2 objectForKey:string];
        NSLog(@"row === %@",row);
//        if (section==0) {
//            if (!ismoreToday) {
//                return row.count;
//            }else if (ismoreToday){
//                return row.count;
//            }
//        }else if (section==1){
//            
//            if (!ismoreTomorrow) {
//                return row.count;
//            }
//            else if (ismoreTomorrow){
//                return row.count;
//            }
//            
//        }
//        
//        return 0;
        return row.count;
        
    }else if (tableView == myTableView3) {
        
        NSString *string = [array objectAtIndex:section];
        NSArray *row = [data3 objectForKey:string];
//        if (section==0) {
//            if (!ismoreToday) {
//                return 3;
//            }else if (ismoreToday){
//                return row.count;
//            }
//        }else if (section==1){
//            
//            if (!ismoreTomorrow) {
//                return 2;
//            }
//            else if (ismoreTomorrow){
//                return row.count;
//            }
//            
//        }
//        
//        return 0;
        return row.count;
        
    }else{
        return 0;
    }
    
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (tableView == myTableView) {
        
        return [array objectAtIndex:section];
        
    }else if (tableView == myTableView1){
        
        return [array objectAtIndex:section];
        
    }else if (tableView == myTableView2){
        
        return [array objectAtIndex:section];
        
    }else if (tableView == myTableView3){
        
        return [array objectAtIndex:section];
        
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == myTableView) {
        
        static NSString *messageDetailCell = @"messageDetailCell";
        UrgentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageDetailCell];
        if (!cell) {
            cell = [[UrgentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageDetailCell];
        }
        
        NSString *string = [array objectAtIndex:indexPath.section];
        NSArray *arrayy = [data objectForKey:string];
        NSLog(@"1-------arrayy == %@",arrayy);
        
        
        cell.titleLable.text = [NSString stringWithFormat:@"%@(%@)",[[arrayy objectAtIndex:indexPath.row] objectForKey:@"workType"],[[arrayy objectAtIndex:indexPath.row] objectForKey:@"faultLevel"]];
        
        cell.contentLable.text = [NSString stringWithFormat:@"%@: %@",[[arrayy objectAtIndex:indexPath.row] objectForKey:@"flowNum"],[[arrayy objectAtIndex:indexPath.row] objectForKey:@"faultContent"]];
        
        cell.dateLable.text = [[arrayy objectAtIndex:indexPath.row] objectForKey:@"workTime"];

        
        return cell;
        
    }else if (tableView == myTableView1) {
        
        static NSString *yuDetailCell = @"yuDetailCell";
        YuYueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:yuDetailCell];
        if (!cell) {
            cell = [[YuYueTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yuDetailCell];
        }
        
        NSString *string = [array objectAtIndex:indexPath.section];
        NSArray *arrayy = [data1 objectForKey:string];
        NSLog(@"22222222222222222222222222222222------arrayy == %@",arrayy);
        cell.titleLable.text = [NSString stringWithFormat:@"%@(%@)",[[arrayy objectAtIndex:indexPath.row] objectForKey:@"projectName"],[[arrayy objectAtIndex:indexPath.row] objectForKey:@"constructionPeople"]];//
        
        cell.contentLable.text = [[arrayy objectAtIndex:indexPath.row] objectForKey:@"constructionPlace"];
        
        cell.nameLable.text = [[arrayy objectAtIndex:indexPath.row] objectForKey:@"enterReason"];
        
        cell.dateLable.text = [[arrayy objectAtIndex:indexPath.row] objectForKey:@"constructionTime"];

        
        return cell;
        
    }else if (tableView == myTableView2) {
        
        static NSString *weekDetailCell = @"weekDetailCell";
        WeekWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:weekDetailCell];
        if (!cell) {
            cell = [[WeekWorkTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:weekDetailCell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        
        NSString *string = [array objectAtIndex:indexPath.section];
        NSArray *arrayy = [data2 objectForKey:string];
        NSLog(@"3-------arrayy == %@",arrayy);
        cell.titleLable.text = [NSString stringWithFormat:@"%@: %@",[[arrayy objectAtIndex:indexPath.row] objectForKey:@"specialName"],[[arrayy objectAtIndex:indexPath.row] objectForKey:@"cycleContent"]];
        
        cell.contentLable.text = [[arrayy objectAtIndex:indexPath.row] objectForKey:@"siteName"];
        
        cell.dateLable.text = [[arrayy objectAtIndex:indexPath.row] objectForKey:@"planDate"];
        
        return cell;
        
    }else{
        
        static NSString *yinhDetailCell = @"yinhDetailCell";
        YinHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:yinhDetailCell];
        if (!cell) {
            cell = [[YinHTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yinhDetailCell];
        }
        
        NSString *string = [array objectAtIndex:indexPath.section];
        NSArray *arrayy = [data3 objectForKey:string];
        NSLog(@"4------arrayy == %@",arrayy);
        cell.titleLable.text = [NSString stringWithFormat:@"%@",[[arrayy objectAtIndex:indexPath.row] objectForKey:@"nuName"]];
        
        cell.contentLable.text = [[arrayy objectAtIndex:indexPath.row] objectForKey:@"dangerCategory"];
        
        cell.dateLable.text = [NSString stringWithFormat:@"%@ %@",[[arrayy objectAtIndex:indexPath.row] objectForKey:@"commitPeople"],[[arrayy objectAtIndex:indexPath.row] objectForKey:@"commitTime"]];

        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == myTableView) {
        
        return 60;
        
    }else if (tableView == myTableView1) {
        
        return 80;
        
    }else if (tableView == myTableView2) {
        
        return 60;
        
    }else{
        return 70;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == myTableView) {
        
        return 30;
        
    }else if (tableView == myTableView1) {
        
        return 30;
        
    }else if (tableView == myTableView2) {
        
        return 30;
        
    }else{
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == myTableView) {
        
        return 20;
        
    }else if (tableView == myTableView1) {
        
        return 20;
        
    }else if (tableView == myTableView2) {
        
        return 20;
        
    }else{
        return 20;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView == myTableView) {
        
        UIView* myView = [[UIView alloc] init];
        myView.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
        backView.backgroundColor = [UIColor redColor];
        [myView addSubview:backView];
        if (section == 0) {
            backView.backgroundColor = [UIColor orangeColor];
        }else{
            backView.backgroundColor = [UIColor greenColor];
        }
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 22)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [sectionArra objectAtIndex:section];
        titleLabel.font = [UIFont systemFontOfSize:13.0];
        [myView addSubview:titleLabel];
        return myView;
        
    }else if (tableView == myTableView1) {
        
        UIView* myView = [[UIView alloc] init];
        myView.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
        backView.backgroundColor = [UIColor redColor];
        [myView addSubview:backView];
        if (section == 0) {
            backView.backgroundColor = [UIColor orangeColor];
        }else{
            backView.backgroundColor = [UIColor greenColor];
        }
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 22)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [sectionArra objectAtIndex:section];
        titleLabel.font = [UIFont systemFontOfSize:13.0];
        [myView addSubview:titleLabel];
        return myView;
        
    }else if (tableView == myTableView2) {
        
        UIView* myView = [[UIView alloc] init];
        myView.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
        backView.backgroundColor = [UIColor redColor];
        [myView addSubview:backView];
        if (section == 0) {
            backView.backgroundColor = [UIColor orangeColor];
        }else{
            backView.backgroundColor = [UIColor greenColor];
        }
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 22)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [sectionArra objectAtIndex:section];
        titleLabel.font = [UIFont systemFontOfSize:13.0];
        [myView addSubview:titleLabel];
        return myView;
        
    }else{
        UIView* myView = [[UIView alloc] init];
        myView.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
        backView.backgroundColor = [UIColor redColor];
        [myView addSubview:backView];
        if (section == 0) {
            backView.backgroundColor = [UIColor orangeColor];
        }else{
            backView.backgroundColor = [UIColor greenColor];
        }
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 22)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [sectionArra objectAtIndex:section];
        titleLabel.font = [UIFont systemFontOfSize:13.0];
        [myView addSubview:titleLabel];
        return myView;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (tableView == myTableView) {
        
        UIView* myView = [[UIView alloc] init];
        myView.backgroundColor = [UIColor whiteColor];
        
        moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        moreBtn.tag = section;
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [moreBtn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (section==0) {
            if (!ismoreToday) {
                [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            }else if (ismoreToday)
            {
                [moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
        }
        if (section==1) {
            if (!ismoreTomorrow) {
                [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            }else if (ismoreTomorrow)
            {
                [moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
        }
        [myView addSubview:moreBtn];
        return myView;

        
    }else if (tableView == myTableView1) {
        
        UIView* myView = [[UIView alloc] init];
        myView.backgroundColor = [UIColor whiteColor];
        
        moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        moreBtn.tag = section;
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [moreBtn addTarget:self action:@selector(moreBtn1:) forControlEvents:UIControlEventTouchUpInside];
        
        if (section==0) {
            if (!ismoreToday) {
                [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            }else if (ismoreToday)
            {
                [moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
        }
        if (section==1) {
            if (!ismoreTomorrow) {
                [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            }else if (ismoreTomorrow)
            {
                [moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
        }
        [myView addSubview:moreBtn];
        return myView;

        
    }else if (tableView == myTableView2) {
        
        UIView* myView = [[UIView alloc] init];
        myView.backgroundColor = [UIColor whiteColor];
        
        moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        moreBtn.tag = section;
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [moreBtn addTarget:self action:@selector(moreBtn2:) forControlEvents:UIControlEventTouchUpInside];
        
        if (section==0) {
            if (!ismoreToday) {
                [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            }else if (ismoreToday)
            {
                [moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
        }
        if (section==1) {
            if (!ismoreTomorrow) {
                [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            }else if (ismoreTomorrow)
            {
                [moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
        }
        [myView addSubview:moreBtn];
        return myView;
        
    }else{
        UIView* myView = [[UIView alloc] init];
        myView.backgroundColor = [UIColor whiteColor];
        
        moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        moreBtn.tag = section;
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [moreBtn addTarget:self action:@selector(moreBtn3:) forControlEvents:UIControlEventTouchUpInside];
        
        if (section==0) {
            if (!ismoreToday) {
                [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            }else if (ismoreToday)
            {
                [moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
        }
        if (section==1) {
            if (!ismoreTomorrow) {
                [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            }else if (ismoreTomorrow)
            {
                [moreBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
        }
        [myView addSubview:moreBtn];
        return myView;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == myTableView) {//故障

        MyRepairFaultListKB *RepairFaultDetailKBCtrl = [[MyRepairFaultListKB alloc] init];
//        RepairFaultDetailKBCtrl.workInfo = workInfo;
        [self.navigationController pushViewController:RepairFaultDetailKBCtrl animated:YES];
        
    }else if (tableView == myTableView1) {//预约
        
//        MyBookingList2* vc = [[MyBookingList2 alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        MyBookingSGYYController *myBookVC = [[MyBookingSGYYController alloc]init];
        [self.navigationController pushViewController:myBookVC animated:YES];
        
    }else if (tableView == myTableView2) {//周期工作
        
        NSString *string = [array objectAtIndex:indexPath.section];
        NSArray *arrayy = [data2 objectForKey:string];
        NSMutableDictionary *workInfo = arrayy[indexPath.row];

        MyTaskListViewController *taskListCtrl = [[MyTaskListViewController alloc] init];
        taskListCtrl.site = workInfo;
        taskListCtrl.planDate = workInfo[@"planDate"];
        [self.navigationController pushViewController:taskListCtrl animated:YES];
        
    }else{//隐患
        DoNothingViewController *hiddenCtrl = [[DoNothingViewController alloc] init];
        [self.navigationController pushViewController:hiddenCtrl animated:YES];
    }
}

#pragma mark == 加载更多
-(void)moreBtn:(UIButton *)sender
{
    NSLog(@"加载更多");
    NSLog(@"%d",sender.tag);
    
    if (sender.tag == 0) {
        
        
        if (ismoreToday){
            ismoreToday=NO;
        }else{
            ismoreToday=YES;
        }
    }else if (sender.tag == 1){
        
        if (ismoreTomorrow){
            ismoreTomorrow=NO;
        }else{
            ismoreTomorrow=YES;
        }
    }
    
    [myTableView reloadData];
}


-(void)moreBtn1:(UIButton *)sender
{
    NSLog(@"加载更多");
    NSLog(@"%d",sender.tag);
    
    if (sender.tag == 0) {
        
        
        if (ismoreToday){
            ismoreToday=NO;
        }else{
            ismoreToday=YES;
        }
    }else if (sender.tag == 1){
        
        if (ismoreTomorrow){
            ismoreTomorrow=NO;
        }else{
            ismoreTomorrow=YES;
        }
    }
    
    [myTableView1 reloadData];
}

-(void)moreBtn2:(UIButton *)sender
{
    NSLog(@"加载更多");
    NSLog(@"%d",sender.tag);
    
    if (sender.tag == 0) {
        
        
        if (ismoreToday){
            ismoreToday=NO;
        }else{
            ismoreToday=YES;
        }
    }else if (sender.tag == 1){
        
        if (ismoreTomorrow){
            ismoreTomorrow=NO;
        }else{
            ismoreTomorrow=YES;
        }
    }
    
    [myTableView2 reloadData];
}

-(void)moreBtn3:(UIButton *)sender
{
    NSLog(@"加载更多");
    NSLog(@"%d",sender.tag);
    
    if (sender.tag == 0) {
        
        
        if (ismoreToday){
            ismoreToday=NO;
        }else{
            ismoreToday=YES;
        }
    }else if (sender.tag == 1){
        
        if (ismoreTomorrow){
            ismoreTomorrow=NO;
        }else{
            ismoreTomorrow=YES;
        }
    }
    
    [myTableView3 reloadData];
}

#pragma mark == 选项按钮
-(void)clickBtn:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
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
    
    UILabel *numLable1 = (UILabel *)[_baseScrollView viewWithTag:200];
    UILabel *numLable2 = (UILabel *)[_baseScrollView viewWithTag:201];
    UILabel *numLable3 = (UILabel *)[_baseScrollView viewWithTag:202];
    UILabel *numLable4 = (UILabel *)[_baseScrollView viewWithTag:203];
    
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
        
        numLable1.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
        numLable2.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        numLable3.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        numLable4.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        
        
        
        if (faultDaylistArr.count == 0 && faultAfterlistArr.count == 0) {
            myTableView.hidden = YES;
            myTableView1.hidden = YES;
            myTableView2.hidden = YES;
            myTableView3.hidden = YES;
        }else{
            data = [[NSDictionary alloc]initWithObjectsAndKeys:faultDaylistArr,@"one",faultAfterlistArr,@"two", nil];
            myTableView.hidden = NO;
            myTableView1.hidden = YES;
            myTableView2.hidden = YES;
            myTableView3.hidden = YES;
            [myTableView reloadData];
        }
        
        
        
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
        
        numLable1.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        numLable2.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
        numLable3.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        numLable4.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        
        
        
        if (orderDaylistArr.count == 0 && orderDaylistArr.count == 0) {
            myTableView.hidden = YES;
            myTableView1.hidden = YES;
            myTableView2.hidden = YES;
            myTableView3.hidden = YES;
        }else{
            data1 = [[NSDictionary alloc]initWithObjectsAndKeys:orderDaylistArr,@"one",orderDaylistArr,@"two", nil];
            myTableView.hidden = YES;
            myTableView1.hidden = NO;
            myTableView2.hidden = YES;
            myTableView3.hidden = YES;
            [myTableView1 reloadData];
        }
        
        
        
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
        
        numLable1.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        numLable2.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        numLable3.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
        numLable4.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        
        
        
        if (cycleDaylistArr.count == 0 && cycleAfterlistArr.count == 0) {
            myTableView.hidden = YES;
            myTableView1.hidden = YES;
            myTableView2.hidden = YES;
            myTableView3.hidden = YES;
        }else{
            data2 = [[NSDictionary alloc]initWithObjectsAndKeys:cycleDaylistArr,@"one",cycleAfterlistArr,@"two", nil];
            myTableView.hidden = YES;
            myTableView1.hidden = YES;
            myTableView2.hidden = NO;
            myTableView3.hidden = YES;
            [myTableView2 reloadData];
        }
        
        
        
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
        
        numLable1.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        numLable2.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        numLable3.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0];
        numLable4.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:156.0/255.0 blue:231.0/255.0 alpha:1.0];
        
        
        if (dangerDaylistArr.count == 0 && dangerAfterlistArr.count == 0) {
            myTableView.hidden = YES;
            myTableView1.hidden = YES;
            myTableView2.hidden = YES;
            myTableView3.hidden = YES;
        }else{
            data3 = [[NSDictionary alloc]initWithObjectsAndKeys:dangerDaylistArr,@"one",dangerAfterlistArr,@"two", nil];
            myTableView.hidden = YES;
            myTableView1.hidden = YES;
            myTableView2.hidden = YES;
            myTableView3.hidden = NO;
            [myTableView3 reloadData];
        }
        
    }
    
}

//////////////////////////////////////////////////////////////////////

#pragma mark - 上拉
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    if (pullTableView == myTableView) {
        
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
        
    }else if (pullTableView == myTableView1){
        
        [self performSelector:@selector(refreshTable1) withObject:nil afterDelay:3.0f];
        
    }else if (pullTableView == myTableView2){
        
        [self performSelector:@selector(refreshTable2) withObject:nil afterDelay:3.0f];
        
    }else if (pullTableView == myTableView3){
        
        [self performSelector:@selector(refreshTable3) withObject:nil afterDelay:3.0f];
        
    }
    
}

- (void) refreshTable
{
    NSLog(@"上拉刷新了");
    a = 1;
    [myTableView reloadData];
    myTableView.pullTableIsRefreshing = NO;
    
}

- (void) refreshTable1
{
    NSLog(@"上拉刷新了");
    a = 1;
    [myTableView1 reloadData];
    myTableView1.pullTableIsRefreshing = NO;
    
}

- (void) refreshTable2
{
    NSLog(@"上拉刷新了");
    a = 1;
    [myTableView2 reloadData];
    myTableView2.pullTableIsRefreshing = NO;
    
}

- (void) refreshTable3
{
    NSLog(@"上拉刷新了");
    a = 1;
    [myTableView3 reloadData];
    myTableView3.pullTableIsRefreshing = NO;
    
}

#pragma mark - 下拉
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
    if (pullTableView == myTableView) {
        
        [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
        
    }else if (pullTableView == myTableView1){
        
        [self performSelector:@selector(loadMoreDataToTable1) withObject:nil afterDelay:3.0f];
        
    }else if (pullTableView == myTableView2){
        
        [self performSelector:@selector(loadMoreDataToTable2) withObject:nil afterDelay:3.0f];
        
    }else if (pullTableView == myTableView3){
        
        [self performSelector:@selector(loadMoreDataToTable3) withObject:nil afterDelay:3.0f];
        
    }
}

- (void) loadMoreDataToTable
{
    NSLog(@"下拉加载了");
    a++;
    NSLog(@"%d",a);
    [myTableView reloadData];
    myTableView.pullTableIsLoadingMore = NO;
}

- (void) loadMoreDataToTable1
{
    NSLog(@"下拉加载了");
    a++;
    NSLog(@"%d",a);
    [myTableView1 reloadData];
    myTableView1.pullTableIsLoadingMore = NO;
}


- (void) loadMoreDataToTable2
{
    NSLog(@"下拉加载了");
    a++;
    NSLog(@"%d",a);
    [myTableView2 reloadData];
    myTableView2.pullTableIsLoadingMore = NO;
}


- (void) loadMoreDataToTable3
{
    NSLog(@"下拉加载了");
    a++;
    NSLog(@"%d",a);
    [myTableView3 reloadData];
    myTableView3.pullTableIsLoadingMore = NO;
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
