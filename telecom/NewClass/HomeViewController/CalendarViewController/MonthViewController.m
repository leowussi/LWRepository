//
//  MonthViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/6/9.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MonthViewController.h"
//#import "FSCalendarHeader.h"
//#import "UintModel.h"
//
//@interface MonthViewController ()<FSCalendarDataSource,FSCalendarDelegate,UITableViewDataSource,UITableViewDelegate>
//{
//    UITableView *_monthListTableView;
//    
//    NSMutableArray *_monthListDataArray;
//    
//    NSMutableArray *_dayListDataArray;
//}
//@end
//
//@implementation MonthViewController
//
//-(void)viewWillAppear:(BOOL)animated
//{
//    [self hiddenBottomBar:YES];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.title = @"当月任务";
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    _monthListDataArray = [NSMutableArray array];
//    _dayListDataArray = [NSMutableArray array];
//    [self loadData];
//    
//    [self setUpUI];
//    
//    
//}
//
//- (void)setUpUI
//{
//    [self addNavigationLeftButton];
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 320)];
//    
//    FSCalendarHeader *header = [[FSCalendarHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
//    [headerView addSubview:header];
//    
//    
//    self.calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(header.frame), self.view.bounds.size.width , 280)];
//    self.calendar.header = header;
//    
//    [self.calendar setEventColor:[UIColor redColor]];
//    [headerView addSubview:self.calendar];
//    [self.calendar setTitleWeekendColor:[UIColor orangeColor]];
//    [self.calendar setBackgroundColor:[UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0]];
//    
//    _monthListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
//    _monthListTableView.dataSource = self;
//    _monthListTableView.delegate = self;
//    _monthListTableView.tableHeaderView = headerView;
//    [self.view addSubview:_monthListTableView];
//}
//
//- (void)loadData
//{
//    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
//    paraDict[URL_TYPE] = GetCurrentMonthTask;
//    paraDict[@"planDate"] = date2str([self getCurrentMonth], @"YYYY-MM");
//    httpGET2(paraDict, ^(id result) {
//        if ([result[@"result"] isEqualToString:@"0000000"]) {
//            for (NSDictionary *dict in result[@"list"]) {
//                UintModel *model = [[UintModel alloc] init];
//                [model setValuesForKeysWithDictionary:dict];
//                [_monthListDataArray addObject:model];
//            }
//            NSLog(@"_monthListDataArray---%@",_monthListDataArray);
//            self.calendar.dataSource = self;
//            self.calendar.delegate = self;
//        }
//    }, ^(id result) {
//        showAlert(result[@"error"]);
//    });
//    
//    
//}
//
//- (NSDate *)getCurrentMonth
//{
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *components =
//    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
//                           NSDayCalendarUnit) fromDate: [NSDate date]];
//    NSDate *currentMonth = [gregorian dateFromComponents:components]; //clean month
//    
//    return currentMonth;
//}
//
//#pragma mark - FSCalendarDelegate
//- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
//{
//    NSLog(@"%@",date);
//}
//
//- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
//{
//    NSString *dateStr = date2str(date, @"yyyy-MM-dd");
//    NSString *indexStr = [dateStr substringFromIndex:dateStr.length-2];
//    NSInteger index = [indexStr integerValue];
//    UintModel *model = _monthListDataArray[index];
//    if (model.taskCount > 0) {
//        return YES;
//    }
//    return NO;
//}
//
//- (void)calendarCurrentMonthDidChange:(FSCalendar *)calendar
//{
//
//}
//
//- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
//{
//    NSLog(@"calendar.currentDate---%@",calendar.currentDate);
//    NSLog(@"calendar.currentMonth---%@",calendar.currentMonth);
//    
//    NSString *dateStr = date2str(date, @"yyyy-MM-dd");
//    NSString *indexStr = [dateStr substringFromIndex:dateStr.length-2];
//    NSInteger index = [indexStr integerValue];
//    UintModel *model = _monthListDataArray[index];
//    
//    return model.taskCount;
////    return nil;
//}
//
//#pragma mark - UITableViewDelegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _dayListDataArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *reuseId = @"reuse";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
//    }
//    
//    
//    return cell;
//}

//@end
