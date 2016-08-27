//
//  OnDutyLogHistory.m
//  telecom
//
//  Created by ZhongYun on 14-8-21.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "OnDutyLogHistory.h"
#import "OnDutyLogHistoryView.h"
#import "OnDutyLogHistoryFilter.h"
#import "TaskTypeBar.h"

#define TVIEW_H         40
#define TAG_BASIC       18000

@interface OnDutyLogHistory ()<TaskTypeBarDelegate>
{
    UIView* m_filterView;
    UIView* m_contentView;
    
    NSMutableArray* m_typeList;
    TaskTypeBar* m_typeView;
    
    UIButton* m_filterBtn;
}
@end

@implementation OnDutyLogHistory

- (void)dealloc
{
    [m_contentView release];
    [m_typeView release];
    [m_typeList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"值班日志历史记录";
    
    _filterInfo = [[NSMutableDictionary alloc] init];
    m_filterView = [[UIView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, TVIEW_H/2)];
    m_filterView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:m_filterView];
    newLabel(m_filterView, @[@50, RECT_OBJ(10, (m_filterView.fh-Font4)/2, m_filterView.fw-20, Font4), [UIColor whiteColor], Font(Font4), @"1235"]);
    
    m_contentView = [[UIView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W,SCREEN_H-self.navBarView.ey)];
    m_contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_contentView];
    
    UIImage* filterIcon = [UIImage imageNamed:@"nav_filter.png"];
    m_filterBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-filterIcon.size.width),
                                                      (NAV_H-filterIcon.size.height)/2,
                                                      filterIcon.size.width, filterIcon.size.height)];
    [m_filterBtn setBackgroundImage:filterIcon forState:0];
    [m_filterBtn addTarget:self action:@selector(onFilterBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:m_filterBtn];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    m_typeView = [[TaskTypeBar alloc] initWithFrame:RECT(0, 64, APP_W, TVIEW_H)];
    m_typeView.backgroundColor = [UIColor whiteColor];
    m_typeView.delegate = self;
    [m_contentView addSubview:m_typeView];
    
    m_typeList = [[NSMutableArray alloc] init];
    [self loadTypeList];
    
    NOTIF_ADD(LOG_FILTER_OVER, onFilterSelected:);
    NOTIF_ADD(LOG_AUDIT_OVER, refreshViewData:);
}

- (void)onFilterBtnTouched:(id)sender
{
    OnDutyLogHistoryFilter* vc = [[OnDutyLogHistoryFilter alloc] init];
    vc.bodys = self.bodys;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)onFilterSelected:(NSNotification*)notification
{
    NSString* strfilter = @"";
    NSDictionary* info = notification.object;
    
    if (info[@"dateBegin"] != nil) {
        strfilter = [strfilter stringByAppendingString: format(@"%@ ~ %@", info[@"dateBegin"], info[@"dateEnd"])];
    }
    
    if (info[@"body"] != nil) {
        strfilter = [strfilter stringByAppendingString: format(@"  %@", info[@"body"])];
    }
    
    m_contentView.fy = (strfilter.length>0 ? m_filterView.ey : self.navBarView.ey);
    m_contentView.fh = (strfilter.length>0 ? SCREEN_H-m_filterView.ey : SCREEN_H-self.navBarView.ey);
    tagViewEx(m_filterView, 50, UILabel).text = format(@"筛选条件：%@", strfilter);
    
    [self.filterInfo removeAllObjects];
    [self.filterInfo addEntriesFromDictionary:info];
    
    [self refreshViewData:nil];
}

- (void)refreshViewData:(NSNotification*)notification
{
    for (int i=0; i<m_typeList.count; i++) {
        [tagViewEx(m_contentView, (i+TAG_BASIC), OnDutyLogHistoryView) refreshData];
    }
}

- (void)loadTypeList
{
    if (!m_typeList) {
        m_typeList = [[NSMutableArray alloc] init];
        m_typeView = [[TaskTypeBar alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, TVIEW_H)];
        m_typeView.backgroundColor = [UIColor whiteColor];
        m_typeView.buttonWidth = 100;
        m_typeView.delegate = self;
        [m_contentView addSubview:m_typeView];
    }
    [m_typeList removeAllObjects];
    [m_typeList addObjectsFromArray:@[@{@"typeId":@(TI_ALLLOG), @"speciltyName":@"全部", @"taskAmount":@0},
                                      @{@"typeId":@(TI_AUDITED), @"speciltyName":@"已审核", @"taskAmount":@0},
                                      @{@"typeId":@(TI_UNAUDIT), @"speciltyName":@"未审核", @"taskAmount":@0}]];
    NSInteger selected = 0;
    if (m_typeList.count > 0) {
        CGRect frame = RECT(0, m_typeView.ey, APP_W, m_contentView.fh-TVIEW_H);
        for (int i=0; i<m_typeList.count; i++) {
            OnDutyLogHistoryView* view = [[OnDutyLogHistoryView alloc] initWithFrame:frame];
            view.typeInfo = m_typeList[i];
            view.backgroundColor = [UIColor whiteColor];
            view.tag = i + TAG_BASIC;
            view.hidden = YES;
            [m_contentView addSubview:view];
            [view release];
        }
        m_typeView.typeList = m_typeList;
        m_typeView.selected = selected;
    }
}

- (void)updatePointStatus:(NSInteger)index Count:(NSInteger)count
{
    [m_typeView updatePointStatus:index Count:count];
}

- (void)updateNavBtnStatus:(OnDutyLogHistoryView*)view
{
    if (view.tag-TAG_BASIC == m_typeView.selected) {
        
    }
}

- (void)changeBefore:(TaskTypeBar*)sender
{
    [m_contentView viewWithTag:m_typeView.selected+TAG_BASIC].hidden = YES;
}

- (void)changeAfter:(TaskTypeBar*)sender
{
    NSInteger viewTag = sender.selected+TAG_BASIC;
    OnDutyLogHistoryView* view = tagViewEx(m_contentView, viewTag, OnDutyLogHistoryView);
    view.hidden = NO;
    [view buildView];
    [self updateNavBtns:view];
}

- (void)updateNavBtns:(OnDutyLogHistoryView*)currView
{
    
}

@end



