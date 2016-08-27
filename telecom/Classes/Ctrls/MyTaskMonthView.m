//
//  MyTaskMonthView.m
//  telecom
//
//  Created by ZhongYun on 14-12-19.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyTaskMonthView.h"
#import "VRGCalendarView.h"
#import "NSDate+convenience.h"
#import "MyTaskListViewController.h"
#import "MyBookingList2.h"
#import "PullTableView.h"
#import "MyRepairFaultDetailKB.h"
#import "HiddenDangerController.h"
#import "AllTaskViewController.h"
#import "TemporaryViewController.h"

#define ROW_H       64
@interface MyTaskMonthView ()<UITableViewDataSource, UITableViewDelegate, VRGCalendarViewDelegate,PullTableViewDelegate>
{
    NSMutableArray* m_list1;
    NSMutableArray* m_list2;
    PullTableView* m_table;
    BOOL m_isPageInit;
    VRGCalendarView *m_calendar;
    
    UIImageView *_upImageView;
    BOOL _isUpDirect;
    
    NSInteger _curPage;
    NSInteger _pageSize;
}
@end

@implementation MyTaskMonthView

- (void)dealloc
{
    [m_calendar release];
    [m_list1 release];
    [m_list2 release];
    [m_table release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        m_list1 = [[NSMutableArray alloc] init];
        m_list2 = [[NSMutableArray alloc] init];
        m_isPageInit = YES;
        _isUpDirect = YES;
        _curPage = 1;
        _pageSize = 20;
        
        m_calendar = [[VRGCalendarView alloc] init];
        m_calendar.frame = RECT(0, 64, m_calendar.frame.size.width, m_calendar.frame.size.height);
        m_calendar.delegate = self;
        m_calendar.tag = 40;
        [self addSubview:m_calendar];
        self.date = [NSDate date];
        
        m_table = [[PullTableView alloc] initWithFrame:RECT(0, m_calendar.ey, APP_W, self.fh-m_calendar.ey-49) style:UITableViewStylePlain];
        m_table.backgroundColor = [UIColor whiteColor];
        m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        m_table.bounces = YES;
        m_table.rowHeight = ROW_H;
        m_table.delegate = self;
        m_table.dataSource = self;
        m_table.pullDelegate = self;
        [self addSubview:m_table];
        
        _upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(m_table.bounds.size.width/2 - 18, 0, 36, 17)];
        _upImageView.contentMode = UIViewContentModeCenter;
        _upImageView.userInteractionEnabled = YES;
        _upImageView.transform = CGAffineTransformMakeRotation(- M_PI_2);
        _upImageView.image = [UIImage imageNamed:@"right_arrow_cur.png"];
        m_table.tableHeaderView = _upImageView;
        
        [_upImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upTranslation)]];
        [_upImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(upTranslation)]];
        
    }
    return self;
}

#pragma mark - 下拉刷新
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)refreshTable
{
    _curPage = 1;
    [self refreshMoreDataWithCurPage:_curPage pageSize:_pageSize];
}

#pragma mark - 上拉加载
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

- (void) loadMoreDataToTable
{
    _curPage++;
    [self loadMoreDataWithCurPage:_curPage pageSize:_pageSize];
}

- (void)upTranslation
{
    if (_isUpDirect) {
        [UIView animateWithDuration:0.5f animations:^{
            CGRect tempF = m_calendar.frame;
            tempF.origin.y = (m_calendar.frame.origin.y - m_calendar.frame.size.height);
            m_calendar.frame = tempF;
            
            CGRect tempTableViewF = m_table.frame;
            tempTableViewF.origin.y = (m_table.frame.origin.y - m_calendar.frame.size.height);
            tempTableViewF.size.height = self.fh - 64;
            m_table.frame = tempTableViewF;
            
            _upImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
            _isUpDirect = NO;
        }];
    }else{//向下
        [UIView animateWithDuration:0.5f animations:^{
            
            CGRect tempF = m_calendar.frame;
            tempF.origin.y = (m_calendar.frame.origin.y + m_calendar.frame.size.height);
            m_calendar.frame = tempF;
            
            CGRect tempTableViewF = m_table.frame;
            tempTableViewF.origin.y = (m_table.frame.origin.y + m_calendar.frame.size.height);
            tempTableViewF.size.height = self.fh-m_calendar.ey;
            m_table.frame = tempTableViewF;
            
            _upImageView.transform = CGAffineTransformMakeRotation(- M_PI_2);
            _isUpDirect = YES;
        }];
    }
}

- (void)setDate:(NSDate *)date
{
    _date = [date retain];
    _dateComp = [[self getDateCompByDate:date] retain];
}

- (NSDateComponents*)getDateCompByDate:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    return [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
}

- (void)loadData
{
    if (![self bIsSameMonth:self.date :m_calendar.currentMonth]) {
        mainThread(loadDataByMonth:, m_calendar.currentMonth);
        return;
    }
    //NW_GetTaskListMonth
    NSString* planDate = date2str(self.date, DATE_FORMAT);
    _curPage = 1;
    httpGET1(@{URL_TYPE:@"MyTask/GetCurrentDayTask",@"planDate":planDate,@"curPage":@(_curPage),@"pageSize":@(_pageSize)}, ^(id result) {
        //        for (NSDictionary* item in result[@"list"]) {
        //            if (![self bisExistInList:item]) {
        //                [m_list1 addObject:item];
        //            }
        //        }
        [m_list2 removeAllObjects];
        [m_list2 addObjectsFromArray:result[@"list"]];
        [m_table reloadData];
        
        [self setMarkDates];
        m_isPageInit = NO;
    });
}

- (void)loadMoreDataWithCurPage:(NSInteger)curPage pageSize:(NSInteger)pageSize;
{
    if (![self bIsSameMonth:self.date :m_calendar.currentMonth]) {
        mainThread(loadDataByMonth:, m_calendar.currentMonth);
        return;
    }
    NSString* planDate = date2str(self.date, DATE_FORMAT);
    httpGET2(@{URL_TYPE:@"MyTask/GetCurrentDayTask",@"planDate":planDate,@"curPage":@(curPage),@"pageSize":@(pageSize)}, ^(id result) {
        if ([result[@"list"] count] == 0) {
            showAlert(@"没有更多的数据了!");
        }else{
            [m_list2 addObjectsFromArray:result[@"list"]];
            [m_table reloadData];
            
            [self setMarkDates];
            m_isPageInit = NO;
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    m_table.pullTableIsLoadingMore = NO;
}

- (void)refreshMoreDataWithCurPage:(NSInteger)curPage pageSize:(NSInteger)pageSize;
{
    if (![self bIsSameMonth:self.date :m_calendar.currentMonth]) {
        mainThread(loadDataByMonth:, m_calendar.currentMonth);
        return;
    }
    NSString* planDate = date2str(self.date, DATE_FORMAT);
    httpGET2(@{URL_TYPE:@"MyTask/GetCurrentDayTask",@"planDate":planDate,@"curPage":@(curPage),@"pageSize":@(pageSize)}, ^(id result) {
        if ([result[@"list"] count] == 0) {
            showAlert(@"没有更多的数据了!");
        }else{
            [m_list2 removeAllObjects];
            [m_list2 addObjectsFromArray:result[@"list"]];
            [m_table reloadData];
            
            [self setMarkDates];
            m_isPageInit = NO;
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    m_table.pullTableIsRefreshing = NO;
}

- (BOOL)bIsSameMonth:(NSDate*)d1 :(NSDate*)d2
{
    if (d2==nil || d1 == nil) return YES;
    NSString* strd1 = date2str(d1, @"yyyy-MM-01");
    NSString* strd2 = date2str(d2, @"yyyy-MM-01");
    return ([strd1 isEqualToString:strd2]);
}

- (void)loadDataByMonth:(NSDate*)currMonth
{
    //NW_GetTaskListMonth
    NSString* planDate = date2str(currMonth, @"yyyy-MM");
    httpGET1(@{URL_TYPE:@"MyTask/GetCurrentMonthTask",@"planDate":planDate}, ^(id result) {
        for (NSDictionary* item in result[@"list"]) {
            if (![self bisExistInList:item]) {
                [m_list1 addObject:item];
            }
        }
        [self setMarkDates];
    });
}

- (BOOL)bisExistInList:(NSDictionary*)newItem
{
    for (NSDictionary* item in m_list1) {
        if ([item[@"taskDate"] isEqualToString:newItem[@"taskDate"]]) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)isMaskMonth:(NSInteger)month
{
    for (NSDictionary* item in m_list1) {
        NSDate* itemDate = str2date(item[@"taskDate"], DATE_FORMAT);
        if ([self getDateCompByDate:itemDate].month == month) {
            return YES;
        }
    }
    return NO;
}

- (void)setMarkDates
{
    NSMutableArray* list = [NSMutableArray array];
    for (NSDictionary* item in m_list1) {
        NSDate* date = str2date(item[@"taskDate"], DATE_FORMAT);
        NSDictionary* info = @{@"date":date, @"count":item[@"taskCount"]};
        [list addObject:info];
    }
    [tagViewEx(self, 40, VRGCalendarView) markDates:list];
}

#pragma mark - VRGCalendarViewDelegate
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    //    if (![self isMaskMonth:month]) {
    //        [self loadDataByMonth:month];
    //    } else {
    //        [self setMarkDates];
    //    }
    if (!m_isPageInit) {
        [m_list1 removeAllObjects];
        [self loadDataByMonth:calendarView.currentMonth];
    }
    m_table.fy = calendarView.ey;
    m_table.fh = self.fh-calendarView.ey;
    calendarView.selectedDate = self.date;
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    
    self.date = date;
    [self loadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_list2.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    
    int taskType = [m_list2[indexPath.row][@"taskType"] intValue];
    if (taskType == 1) {//周期工作
        MyTaskListViewController* vc = [[MyTaskListViewController alloc] init];
        vc.planDate = date2str(self.date, DATE_FORMAT);
        vc.site = m_list2[indexPath.row];
        [getViewController(self).navigationController pushViewController:vc animated:YES];
        [vc release];
    } else if (taskType == 2){//故障
        NSLog(@"%@",m_list2);
//        MyRepairFaultDetailKB *repairFaultKBDetailCtrl = [[MyRepairFaultDetailKB alloc] init];
//        repairFaultKBDetailCtrl.workInfo = m_list2[indexPath.row];
//        [getViewController(self).navigationController pushViewController:repairFaultKBDetailCtrl animated:YES];
        NSString* planDate = date2str(self.date, DATE_FORMAT);
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
        paraDict[@"taskType"] = [[m_list2 objectAtIndex:indexPath.row]objectForKey:@"taskType"];
        paraDict[@"regionId"] = [[m_list2 objectAtIndex:indexPath.row]objectForKey:@"siteId"];
        paraDict[@"planDate"] = planDate;
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        NSLog(@"%@",paraDict);
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"]){
                
                AllTaskViewController *allVC = [[AllTaskViewController alloc] init];
                allVC.vcTag = 100;
                allVC.strType = @"2";
                allVC.strID = [[m_list2 objectAtIndex:indexPath.row]objectForKey:@"siteId"];
                allVC.allArr = [result objectForKey:@"list"];
                [getViewController(self).navigationController pushViewController:allVC animated:YES];
                [allVC release];
                
            }else{
                
            }
            
        }, ^(id result) {
            
        });
    }else if (taskType == 3){//预约
//        MyBookingList2* vc = [[MyBookingList2 alloc] init];
////                vc.siteId = m_list2[indexPath.row][@"siteId"];
////                vc.planDate = date2str(self.date, DATE_FORMAT);
//        [getViewController(self).navigationController pushViewController:vc animated:YES];
        NSString* planDate = date2str(self.date, DATE_FORMAT);
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
        paraDict[@"taskType"] = [[m_list2 objectAtIndex:indexPath.row]objectForKey:@"taskType"];
        paraDict[@"regionId"] = [[m_list2 objectAtIndex:indexPath.row]objectForKey:@"siteId"];
        paraDict[@"planDate"] = planDate;
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        NSLog(@"%@",paraDict);
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"]){
                
                AllTaskViewController *allVC = [[AllTaskViewController alloc] init];
                allVC.vcTag = 100;
                allVC.strType = @"3";
                allVC.strID = [[m_list2 objectAtIndex:indexPath.row]objectForKey:@"siteId"];
                allVC.allArr = [result objectForKey:@"list"];
                [getViewController(self).navigationController pushViewController:allVC animated:YES];
                [allVC release];
                
            }else{
                
            }
            
        }, ^(id result) {
            
        });
        
    }else if (taskType == 4){//隐患
//        HiddenDangerController *hiddenDangerCtrl = [[HiddenDangerController alloc] init];
//        [getViewController(self).navigationController pushViewController:hiddenDangerCtrl animated:YES];
        NSString* planDate = date2str(self.date, DATE_FORMAT);
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
        paraDict[@"taskType"] = [[m_list2 objectAtIndex:indexPath.row]objectForKey:@"taskType"];
        paraDict[@"regionId"] = [[m_list2 objectAtIndex:indexPath.row]objectForKey:@"siteId"];
        paraDict[@"planDate"] = planDate;
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        NSLog(@"%@",paraDict);
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"]){
                
                AllTaskViewController *allVC = [[AllTaskViewController alloc] init];
                allVC.vcTag = 100;
                allVC.strType = @"4";
                allVC.strID = [[m_list2 objectAtIndex:indexPath.row]objectForKey:@"siteId"];
                allVC.allArr = [result objectForKey:@"list"];
                [getViewController(self).navigationController pushViewController:allVC animated:YES];
                [allVC release];
                
            }else{
                
            }
            
        }, ^(id result) {
            
        });
    }else if (taskType == 10){
        
        NSString* planDate = date2str(self.date, DATE_FORMAT);
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"myTask/GetAllTaskInfo";
        paraDict[@"taskType"] = [[m_list2 objectAtIndex:indexPath.row]objectForKey:@"taskType"];
        paraDict[@"regionId"] = [[m_list2 objectAtIndex:indexPath.row]objectForKey:@"siteId"];
        paraDict[@"planDate"] = planDate;
        paraDict[@"curPage"] = @"1";
        paraDict[@"pageSize"] = @"10";
        
        NSLog(@"%@",paraDict);
        httpPOST(paraDict, ^(id result) {
            NSLog(@"%@",result);
            if ([result[@"result"] isEqualToString:@"0000000"]){
                
                TemporaryViewController *allVC = [[TemporaryViewController alloc] init];
                allVC.vcTag = 100;
                allVC.temArr = [result objectForKey:@"list"];
                [getViewController(self).navigationController pushViewController:allVC animated:YES];
                [allVC release];
                
            }else{
                
            }
            
        }, ^(id result) {
            
        });
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_list2[indexPath.row];
    static NSString *reuseId = @"reuse";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:reuseId] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row % 2 != 0) {
        cell.backgroundColor = [UIColor colorWithRed:254/255.0f green:254/255.0f blue:254/255.0f alpha:1.0f];
    }else{
        cell.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    }
    
    int taskType = [m_list2[indexPath.row][@"taskType"] intValue];
    
    NSString *iconNameStr = nil;
    NSString *taskName = nil;
    if (taskType == 1) {//
        iconNameStr = @"zqgz.png";
        taskName = @"周期工作";
    }else if (taskType == 2){//
        iconNameStr = @"gz.png";
        taskName = @"故障";
    }else if (taskType == 3){
        iconNameStr = @"yy.png";
        taskName = @"预约";
    }else{
        iconNameStr = @"yhqd.png";
        taskName = @"隐患";
    }
    
    for (UIView *views in cell.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 8, 30, 30)];
    iconView.image = [UIImage imageNamed:iconNameStr];
    [cell.contentView addSubview:iconView];
    [iconView release];
    
    UILabel *taskNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, iconView.ey, iconView.fw+20, 20)];
    taskNameLabel.font = [UIFont systemFontOfSize:12.0f];
    taskNameLabel.text = taskName;
    taskNameLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:taskNameLabel];
    [taskNameLabel release];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    //    CGRect sizeRect = [dataRow[@"siteName"] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f]} context:nil];
    titleLabel.frame = CGRectMake(iconView.ex+40, 17, 150, 30);
    titleLabel.text = dataRow[@"siteName"];
    [cell.contentView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *taskNum = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.ex+5, titleLabel.fy+2.5, 26, 26)];
    taskNum.layer.cornerRadius = 13;
    taskNum.layer.backgroundColor = [UIColor colorWithRed:58/255.0f green:148/255.0f blue:224/255.0f alpha:1.0].CGColor;
    [taskNum setTextAlignment:NSTextAlignmentCenter];
    [taskNum setTextColor:[UIColor whiteColor]];
    taskNum.text = dataRow[@"taskCount"];
    [cell.contentView addSubview:taskNum];
    [taskNum release];
    
    return cell;
}


@end
