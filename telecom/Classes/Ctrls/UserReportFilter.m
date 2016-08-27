//
//  UserReportFilter.m
//  telecom
//
//  Created by ZhongYun on 14-9-21.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "UserReportFilter.h"
#import "UserReport.h"
#import "FilterCompSelect.h"

#define YEAR_MIN    1990
#define YEAR_MAX    2023

@interface UserReportFilter ()<UITextFieldDelegate>
{
    NSMutableArray* m_types;
    NSMutableArray* m_sites;
    NSMutableArray* m_years;
    NSMutableArray* m_months;
    
    int sel_type;
    int sel_site;
    int sel_year;
    int sel_month;
}
@end

@implementation UserReportFilter

- (void)dealloc
{
    [m_years release];
    [m_sites release];
    [m_types release];
    [m_months release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"条件选择";
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    UIButton* m_checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width),
                                                      (NAV_H-checkIcon.size.height)/2,
                                                      checkIcon.size.width, checkIcon.size.height)];
    [m_checkBtn setBackgroundImage:checkIcon forState:0];
    [m_checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:m_checkBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
//    [self.navBarView addSubview:m_checkBtn];

    CGFloat bar_x=10, bar_w=(APP_W-bar_x*2), bar_h=44;
    UIButton* bar1 = [[UIButton alloc] initWithFrame:RECT(bar_x, self.navBarView.ey+10, bar_w, bar_h)];
    bar1.clipsToBounds = YES;
    maskBorderLayer(bar1, UIRectCornerTopLeft|UIRectCornerTopRight, CGSizeMake(4, 4), [UIColor lightGrayColor], [UIColor whiteColor]);
    [bar1 addTarget:self action:@selector(onBar1NextTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bar1];
    
    UIButton* bar2 = [[UIButton alloc] initWithFrame:RECT(bar_x, bar1.ey-1, bar_w, bar_h)];
    bar2.clipsToBounds = YES;
    maskBorderLayer(bar2, 0, CGSizeMake(0, 0), [UIColor lightGrayColor], [UIColor whiteColor]);
    [bar2 addTarget:self action:@selector(onBar2NextTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bar2];
    
    UIButton* bar3 = [[UIButton alloc] initWithFrame:RECT(bar_x, bar2.ey-1, bar_w, bar_h)];
    bar3.clipsToBounds = YES;
    maskBorderLayer(bar3, 0, CGSizeMake(0, 0), [UIColor lightGrayColor], [UIColor whiteColor]);
    [bar3 addTarget:self action:@selector(onBar3NextTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bar3];
    
    UIButton* bar4 = [[UIButton alloc] initWithFrame:RECT(bar_x, bar3.ey-1, bar_w, bar_h)];
    bar4.clipsToBounds = YES;
    maskBorderLayer(bar4, UIRectCornerBottomLeft|UIRectCornerBottomRight, CGSizeMake(4, 4), [UIColor lightGrayColor], [UIColor whiteColor]);
    [bar4 addTarget:self action:@selector(onBar4NextTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bar4];
    

    newLabel(bar1, @[@21, RECT_OBJ(10, (bar_h-Font3)/2, 70, Font3), APP_COLOR, FontB(Font3), @"统计类型："]);
    newLabel(bar2, @[@22, RECT_OBJ(10, (bar_h-Font3)/2, 70, Font3), APP_COLOR, FontB(Font3), @"站点："]);
    newLabel(bar3, @[@23, RECT_OBJ(10, (bar_h-Font3)/2, 70, Font3), APP_COLOR, FontB(Font3), @"年份："]);
    newLabel(bar4, @[@24, RECT_OBJ(10, (bar_h-Font3)/2, 70, Font3), APP_COLOR, FontB(Font3), @"月、季："]);
    
    newTextField(bar1, @[@31, RECT_OBJ(85, 1, bar1.fw-85-30, bar1.fh-2), RGB(0), Font(Font3), @"请选择统计类型", @""]).userInteractionEnabled = NO;
    newTextField(bar2, @[@32, RECT_OBJ(85, 1, bar1.fw-85-30, bar1.fh-2), RGB(0), Font(Font3), @"请选择局站", @""]).userInteractionEnabled = NO;
    newTextField(bar3, @[@33, RECT_OBJ(85, 1, bar1.fw-85-30, bar1.fh-2), RGB(0), Font(Font3), @"请选择年份", @""]).userInteractionEnabled = NO;
    newTextField(bar4, @[@34, RECT_OBJ(85, 1, bar1.fw-85-30, bar1.fh-2), RGB(0), Font(Font3), @"请选择月、季", @""]).userInteractionEnabled = NO;
    
    newImageView(bar1, @[@41, @"arrow_right.png", RECT_OBJ(bar1.fw-10-8, (bar1.fh-16)/2, 8, 16)]);
    newImageView(bar2, @[@42, @"arrow_right.png", RECT_OBJ(bar1.fw-10-8, (bar1.fh-16)/2, 8, 16)]);
    newImageView(bar3, @[@43, @"arrow_right.png", RECT_OBJ(bar1.fw-10-8, (bar1.fh-16)/2, 8, 16)]);
    newImageView(bar4, @[@44, @"arrow_right.png", RECT_OBJ(bar1.fw-10-8, (bar1.fh-16)/2, 8, 16)]);
    
    
    [bar4 release];
    [bar3 release];
    [bar2 release];
    [bar1 release];
    
    [self loadData];
    [self updateTextField];
    NOTIF_ADD(RPT_SITE_DOWN, onHttpGetSite:);
}

- (void)loadData
{
    m_types = [[NSMutableArray alloc] init];
    NSArray* typeNames = @[@"统计个人", @"统计班组"];
    for (int i=0; i<typeNames.count; i++) {
        [m_types addObject:@{@"id":@(i), @"name":typeNames[i]}];
    }
    sel_type = 0;
    
    m_years = [[NSMutableArray alloc] init];
    for (int i=YEAR_MIN; i<=YEAR_MAX; i++) {
        [m_years addObject:@{@"id":@(i-YEAR_MIN), @"name":format(@"%d", i)}];
    }
    sel_year = [date2str([NSDate date], @"yyyy") intValue]-YEAR_MIN;
    
    m_months = [[NSMutableArray alloc] init];
    NSArray* monthNames = @[@"全年", @"第1季度", @"第2季度", @"第3季度", @"第4季度",
                            @"1月", @"2月", @"3月", @"4月", @"5月", @"6月",
                            @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
    for (int i=0; i<monthNames.count; i++) {
        [m_months addObject:@{@"id":@(i), @"name":monthNames[i]}];
    }
    NSString* currMonth = date2str([NSDate date], @"MM");
    sel_month = monthNames.count - (12 - [currMonth intValue]) - 1;
    
    m_sites = [[NSMutableArray alloc] init];
    [self onHttpGetSite:nil];
}
     
- (void)onHttpGetSite:(NSNotification*)sender
{
    NSArray* vcs = self.navigationController.viewControllers;
    UserReport* rptVC = (UserReport*)(vcs[vcs.count-2]);
    if (rptVC.sites != nil) {
        for (NSMutableDictionary* item in rptVC.sites) {
            [m_sites addObject:@{@"id":item[@"siteId"], @"name":item[@"siteName"]}];
        }
        sel_site = 0;
        tagViewEx(self.view, 32, UITextField).text = m_sites[sel_site][@"name"];
    }
}

- (void)updateTextField
{
    tagViewEx(self.view, 31, UITextField).text = m_types[sel_type][@"name"];
    //tagViewEx(self.view, 32, UITextField).text = m_sites[sel_site][@"name"];
    tagViewEx(self.view, 33, UITextField).text = m_years[sel_year][@"name"];
    tagViewEx(self.view, 34, UITextField).text = m_months[sel_month][@"name"];
}

- (void)onCheckBtnTouched:(id)sender
{
    int tmpYear = sel_year + YEAR_MIN;
    
    NSString* r_bgn = @"01";
    NSString* r_end = @"12";
    if (sel_month == 0) {
        
    } else if (sel_month>=1 && sel_month<=4) {
        r_bgn = format(@"%02d", ( (sel_month-1)*3+1 ));
        r_end = format(@"%02d", (  sel_month*3      ));
    }  else {
        r_bgn = r_end = format(@"%02d", ( sel_month-5+1 ));
    }
    r_bgn = format(@"%d%@", tmpYear, r_bgn);
    r_end = format(@"%d%@", tmpYear, r_end);
    
    NSDictionary* paras = @{URL_TYPE:NW_RptWorkTimePercent,
                            @"type":@(sel_type+1), @"siteId":m_sites[sel_site][@"id"],
                            @"startMonth":r_bgn, @"endMonth":r_end};
    httpGET1(paras, ^(id result) {
        
        NSArray* rsList = result[@"list"];
        if (rsList.count > 0) {
            NSArray* vcs = self.navigationController.viewControllers;
            UserReport* rptVC = (UserReport*)(vcs[vcs.count-2]);
            
            
            NSString* paraStr = format(@"%@,%@,%@~%@",
                                       tagViewEx(self.view, 31, UITextField).text,
                                       tagViewEx(self.view, 32, UITextField).text,
                                       r_bgn, r_end);
            [rptVC showReportData:@[rsList[0], paraStr]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            showAlert(@"没有查询到数据");
        }
    });
}

- (void)getResultData
{
    
}

- (void)onBar1NextTouched:(id)sender
{
    FilterCompSelect* vc = [[FilterCompSelect alloc] init];
    vc.selected = sel_type;
    vc.data = m_types;
    vc.idKey = @"id";
    vc.nameKey = @"name";
    vc.respBlock = ^(NSInteger selected){
        sel_type = selected;
        tagViewEx(self.view, 31, UITextField).text = vc.data[selected][vc.nameKey];
    };
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)onBar2NextTouched:(id)sender
{
    FilterCompSelect* vc = [[FilterCompSelect alloc] init];
    vc.selected = sel_site;
    vc.data = m_sites;
    vc.idKey = @"id";
    vc.nameKey = @"name";
    vc.respBlock = ^(NSInteger selected){
        sel_site = selected;
        tagViewEx(self.view, 32, UITextField).text = vc.data[selected][vc.nameKey];
    };
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)onBar3NextTouched:(id)sender
{
    FilterCompSelect* vc = [[FilterCompSelect alloc] init];
    vc.selected = sel_year;
    vc.data = m_years;
    vc.idKey = @"id";
    vc.nameKey = @"name";
    vc.respBlock = ^(NSInteger selected){
        sel_year = selected;
        tagViewEx(self.view, 33, UITextField).text = vc.data[selected][vc.nameKey];
    };
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)onBar4NextTouched:(id)sender
{
    FilterCompSelect* vc = [[FilterCompSelect alloc] init];
    vc.selected = sel_month;
    vc.data = m_months;
    vc.idKey = @"id";
    vc.nameKey = @"name";
    vc.respBlock = ^(NSInteger selected){
        sel_month = selected;
        tagViewEx(self.view, 34, UITextField).text = vc.data[selected][vc.nameKey];
    };
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}



@end
