//
//  MyTaskWeekView.m
//  telecom
//
//  Created by Yun Zhong on 14/12/19.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyTaskWeekView.h"
#import "MyTaskListViewController.h"
#import "MyBookingList.h"

#define ROW_H       42
#define ARR_DOWN    CGAffineTransformMakeRotation(M_PI/2)
#define ARR_RIGHT   CGAffineTransformMakeRotation(0)

@interface MyTaskWeekView ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* m_data;
    UITableView* m_table;    
}
@end

@implementation MyTaskWeekView

- (void)dealloc
{
    [m_data release];
    [m_table release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.date = [[NSDate date] retain];
        [self addWeekNav];
        
        m_data = [[NSMutableArray alloc] init];
        m_table = [[UITableView alloc] initWithFrame:RECT(0, ROW_H, self.fw, self.fh-ROW_H) 
                                               style:UITableViewStylePlain];
        m_table.backgroundColor = [UIColor whiteColor];
        m_table.separatorStyle = UITableViewCellSeparatorStyleNone;
        m_table.bounces = YES;
        m_table.rowHeight = ROW_H;
        m_table.delegate = self;
        m_table.dataSource = self;
        m_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:m_table];
    }
    return self;
}

- (void)addWeekNav
{
    UIView* weekNav = [[UIView alloc] initWithFrame:RECT(0, 0, self.fw, ROW_H)];
    weekNav.backgroundColor = RGB(0xffffff);
    [self addSubview:weekNav];
    
    NSDate* bgnDate = [self.date dateByAddingTimeInterval:-3600*24];
    NSDate* endDate = [self.date dateByAddingTimeInterval:3600*24*5];
    NSString* bgnDateStr = date2str(bgnDate, DATE_FORMAT);
    NSString* endDateStr = date2str(endDate, DATE_FORMAT);
    newLabel(weekNav, @[@21, rect2id(weekNav.bounds), RGB(0x000000), FontB(Font2), format(@"%@ ~ %@", bgnDateStr, endDateStr)]).textAlignment = NSTextAlignmentCenter;;
    
    UIImageView* imgLeft = newImageView(weekNav, @[@101, @"week_left.png"]);
    imgLeft.frame = RECT(1, (weekNav.fh-imgLeft.fh)/2, imgLeft.fw, imgLeft.fh);
    [weekNav addSubview:imgLeft];
    UIButton* btnLeft = [[UIButton alloc] initWithFrame:imgLeft.frame];
    [btnLeft addTarget:self action:@selector(onWeekNavBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [weekNav addSubview:btnLeft];
    [btnLeft release];
    
    UIImageView* imgRight = newImageView(weekNav, @[@102, @"week_right.png"]);
    imgRight.frame = RECT(self.fw-1-imgRight.fw, (weekNav.fh-imgRight.fh)/2, imgRight.fw, imgRight.fh);
    [weekNav addSubview:imgRight];
    UIButton* btnRight = [[UIButton alloc] initWithFrame:imgRight.frame];
    [btnRight addTarget:self action:@selector(onWeekNavBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [weekNav addSubview:btnRight];
    [btnRight release];

    
    UIView* line = [[UIView alloc] initWithFrame:RECT(0, weekNav.fh-0.5, weekNav.fw, 0.5)];
    line.backgroundColor = RGB(0x757575);
    [weekNav addSubview:line];
    [line release];
    
    [weekNav release];
}

- (void)onWeekNavBtnTouched:(UIButton*)sender
{
    int dir = (sender.fx < APP_W/2 ? -1 : 1);
    self.date = [self.date dateByAddingTimeInterval:dir*(3600*24*7)];
    
    NSDate* bgnDate = [self.date dateByAddingTimeInterval:-3600*24];
    NSDate* endDate = [self.date dateByAddingTimeInterval:3600*24*5];
    NSString* bgnDateStr = date2str(bgnDate, DATE_FORMAT);
    NSString* endDateStr = date2str(endDate, DATE_FORMAT);
    tagViewEx(self, 21, UILabel).text = format(@"%@ ~ %@", bgnDateStr, endDateStr);
    
    [self loadData];    
}

- (void)setCondition:(NSString *)condition
{
    _condition = [condition copy];
    [self loadData];
}

- (void)loadData
{
    NSDate* bgnDate = [self.date dateByAddingTimeInterval:-3600*24];
    NSDate* endDate = [self.date dateByAddingTimeInterval:3600*24*5];
    NSString* bgnDateStr = date2str(bgnDate, DATE_FORMAT);
    NSString* endDateStr = date2str(endDate, DATE_FORMAT);
    
    NSDictionary* params = @{URL_TYPE:NW_GetTaskListByGroup,
                             @"Condition":self.condition,
                             @"StartDate":bgnDateStr,
                             @"EndDate":endDateStr};
    if (self.hidden == YES) {
        params = @{URL_TYPE:NW_GetTaskListByGroup,
                   @"Condition":self.condition,
                   @"StartDate":bgnDateStr,
                   @"EndDate":endDateStr,
                   HIDE_LOADING:@1};
    }
    
    httpGET1(params, ^(id result) {
        [m_data removeAllObjects];
        [m_data addObjectsFromArray:result[@"list"]];
        [m_table reloadData];
    });
}

#pragma mark - UITableViewDataSource - section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ROW_H;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header_bg = [[UIButton alloc] initWithFrame:RECT(0, 0, APP_W, ROW_H)];
    header_bg.backgroundColor = [UIColor whiteColor];
    header_bg.clipsToBounds = YES;
    
    
    UIButton* header = [[UIButton alloc] initWithFrame:RECT(1, 1, APP_W-2, ROW_H-2)];
    header.titleLabel.font = FontB(Font2);
    [header setTitle:m_data[section][@"planDate"] forState:0];
    [header setTitleColor:RGB(0x000000) forState:0];
    //[header setBackgroundImage:color2Image(RGB(0xffffff)) forState:0];
    [header addTarget:self action:@selector(onHeaderBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    header.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    header.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    header.tag = 15000 + section;
    [header_bg addSubview:header];
    
    UIImageView* icon = newImageView(header_bg, @[@(16000+section), @"week_arrow.png"]);
    icon.frame = RECT(APP_W-11-icon.fw, (ROW_H-icon.fh)/2, icon.fw, icon.fh);
    BOOL isExtend = ([m_data[section][@"extended"] intValue] == 1);
    if (isExtend) {
        icon.transform = ARR_DOWN;
    }
    //[icon release];
    
    UIView* line = [[UIView alloc] initWithFrame:RECT(0, header_bg.fh-0.5, APP_W, 0.5)];
    line.backgroundColor = RGB(0x757575);
    [header_bg addSubview:line];
    //[line release];
    
    return header_bg;
}

- (void)onHeaderBtnTouched:(UIButton*)sender
{
    int section = sender.tag - 15000;
    UIView* arrow = tagView(sender.superview, sender.tag+1000);
    int currState = [m_data[section][@"extended"] intValue];
    int newState = (currState == 1 ? 0 : 1);
    [UIView animateWithDuration:0.15 animations:^{
        if (newState == 1) {
            arrow.transform = ARR_DOWN;
        } else {
            arrow.transform = ARR_RIGHT;
        }
    }];
    m_data[section][@"extended"] = @(newState);    
    [m_table reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:0];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isExtend = ([m_data[indexPath.section][@"extended"] intValue] == 1);
    
    return (isExtend ? ROW_H : 0);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* list = m_data[section][@"task"];
    return list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    
    int taskType = [m_data[indexPath.section][@"task"][indexPath.row][@"taskType"] intValue];
    if (taskType != 2) {
        MyTaskListViewController* vc = [[MyTaskListViewController alloc] init];
        vc.planDate = date2str(m_data[indexPath.section][@"planDate"], DATE_FORMAT);
        vc.site = m_data[indexPath.section][@"task"][indexPath.row];
        [getViewController(self).navigationController pushViewController:vc animated:YES];
        [vc release];
    } else if (taskType == 2){
        MyBookingList* vc = [[MyBookingList alloc] init];
        vc.siteId = m_data[indexPath.section][@"task"][indexPath.row][@"siteId"];
        vc.planDate = date2str(m_data[indexPath.section][@"planDate"], DATE_FORMAT);
        [getViewController(self).navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* groupDate = m_data[indexPath.section][@"planDate"];
    NSMutableDictionary* dataRow = m_data[indexPath.section][@"task"][indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@_%@", groupDate, dataRow[@"siteId"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.clipsToBounds = YES;
        
        int taskType = [m_data[indexPath.section][@"task"][indexPath.row][@"taskType"] intValue];
        NSString* iconName = (taskType == 2 ? @"site_icon2.png":@"site_icon.png");
        UIImageView* icon = newImageView(cell, @[@20, iconName]);
        icon.frame = RECT(25, (ROW_H-icon.fh)/2, icon.fw, icon.fh);
        
        newLabel(cell, @[@21, RECT_OBJ(icon.ex+5, (ROW_H-Font2)/2, APP_W-15-icon.ex, Font2), RGB(0x000000), FontB(Font2), @""]);
        
        UIView* line = [[UIView alloc] initWithFrame:RECT(15, ROW_H-0.5, APP_W-15, 0.5)];
        line.backgroundColor = COLOR(215, 215, 215);
        [cell addSubview:line];
        [line release];
    }
    
    tagViewEx(cell, 21, UILabel).text = format(@"%@（%@）", dataRow[@"taskName"], dataRow[@"taskCount"]);
    return cell;
}


@end
