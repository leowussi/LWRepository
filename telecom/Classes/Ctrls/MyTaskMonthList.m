//
//  MyTaskMonthList.m
//  telecom
//
//  Created by ZhongYun on 14-8-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyTaskMonthList.h"
#import "MyTaskMonthView.h"

typedef enum {
	PMMonth     = 101, //月视图任务页面
    PMWeek      = 102, //周视图任务页面
    PMDay       = 103, //日视图任务页面
    PMGeneral   = 104, //通用任务页面
    PMInput     = 105, //任务单填写页面
    PMPower     = 106, //动力周期工作页面
} PageModel;

#define CURR_CONF_LIST()        UGET(U_CONFIG)[@"list"]
#define CURR_PAGE_DIC(PM)       [self getCondition:PM]
#define CURR_COND_DIC(ID)       m_currPMDic[@"listCondition"][ID]; m_currCondId = ID;
#define POP_ROW_H   40

@interface MyTaskMonthList ()
{
    NSArray* m_CfgList;
    PageModel  m_currPM;
    NSDictionary* m_currPMDic;
    int m_currCondId;
    NSDictionary* m_currCondDic;
    
    NSDictionary* m_PmName;
    
    MyTaskMonthView* m_monthView;
}
@end

@implementation MyTaskMonthList

//- (void)dealloc
//{
//    [m_PmName release];
//    [m_monthView release];
//    [super dealloc];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的任务";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addNavigationLeftButton];
    
    m_CfgList = CURR_CONF_LIST();
    m_currPMDic = CURR_PAGE_DIC(PMMonth);
    m_currCondDic = CURR_COND_DIC(0);
    m_PmName = @{@(PMMonth):@"月视图", @(PMWeek):@"周视图"};
    
    UIImage* moreIcon = [UIImage imageNamed:@"nav_more.png"];
    UIButton* moreBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-moreIcon.size.width), (NAV_H-moreIcon.size.height)/2,
                                                             moreIcon.size.width, moreIcon.size.height)];
    [moreBtn setBackgroundImage:moreIcon forState:0];
    [moreBtn addTarget:self action:@selector(onMoreBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    [self.navBarView addSubview:moreBtn];
//    [moreBtn release];
    
    UIButton* pageBtn = [[UIButton alloc] initWithFrame:moreBtn.frame];
    pageBtn.tag = 18856;
    pageBtn.fw = moreBtn.fw*2.0;
    pageBtn.fx = moreBtn.fx - 20 - pageBtn.fw;
    pageBtn.titleLabel.font = FontB(Font2);
    [pageBtn setTitle:m_PmName[@(m_currPM)] forState:0];
    [pageBtn setTitleColor:RGB(0x000000) forState:0];
    [pageBtn addTarget:self action:@selector(onPageBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:pageBtn];
    UIImageView* btnIcon = newImageView(pageBtn, @[@12306, @"page_selected.png"]);
    btnIcon.frame = RECT(pageBtn.fw-btnIcon.fw, pageBtn.fh-btnIcon.fh, btnIcon.fw, btnIcon.fh);
    [pageBtn addSubview:btnIcon];
//    [pageBtn release];
    
    m_monthView = [[MyTaskMonthView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, self.view.fh-self.navBarView.ey)];

    [m_monthView loadData];
    [m_monthView loadDataByMonth:[self getCurrentMonth]];
    [self.view addSubview:m_monthView];
    


    
    [self addMorePopView];
    [self updateMorePopView];
    
    [self addPagePopView];
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSDate *)getCurrentMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: [NSDate date]];
    NSDate *currentMonth = [gregorian dateFromComponents:components]; //clean month
    return currentMonth;
}


- (void)onPageBtnTouched:(id)sender
{
    [self pagePopHidden:NO];
}

- (NSDictionary*)getCondition:(PageModel)vm
{
    m_currPM = vm;
    for (NSDictionary* item in m_CfgList) {
        if ([item[@"pageId"] intValue] == m_currPM) {
            return item;
        }
    }
    return nil;
}

- (void)onMoreBtnTouched:(id)sender
{
    [self popviewHidden:NO];
}

- (void)onMenuBtnTouched:(UIButton*)sender
{
    [self popviewHidden:YES];
    
    int index = sender.tag - 1000;
    if (index == m_currCondId) return;
    
    m_currCondDic = CURR_COND_DIC(index);
    m_monthView.condition = m_currCondDic[@"condition"];
}

- (void)updateMorePopView
{
    NSArray* condList = m_currPMDic[@"listCondition"];
    tagView(self.view, 1502).fh = POP_ROW_H * condList.count;
    
    for (int i = 0; i < condList.count; i++) {
        [tagViewEx(self.view, 1000+i, UIButton) setTitle:condList[i][@"conditionName"] forState:0];
    }
}

- (void)addMorePopView
{
    UIButton* popViewBg = [[UIButton alloc] initWithFrame:RECT(0,0,SCREEN_W,SCREEN_H)];
    popViewBg.tag = 1501;
    popViewBg.hidden = YES;
    popViewBg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:popViewBg];
    [popViewBg clickBlock:^{
        [self popviewHidden:YES];
    }];

    NSArray* condList = m_currPMDic[@"listCondition"];
    CGFloat pop_w = APP_W/2, pop_h = POP_ROW_H * condList.count;
    UIView* popView = [[UIView alloc] initWithFrame:RECT(APP_W-pop_w-10, self.navBarView.ey+0, pop_w, pop_h)];
    popView.backgroundColor = COLOR(239, 239, 239);
    popView.hidden = YES;
    popView.tag = 1502;
    popView.layer.borderWidth = 0.5;
    popView.layer.borderColor = COLOR(215, 215, 215).CGColor;
    popView.clipsToBounds = YES;
    showShadow(popView, CGSizeMake(0, 0));
    [self.view addSubview:popView];
    
    CGFloat top_y = 0;
    for (int i = 0; i < 10; i++) {
        UIButton* menu1 = [[UIButton alloc] initWithFrame:RECT(1, top_y, popView.fw-2, POP_ROW_H)];
        menu1.backgroundColor = [UIColor clearColor];
        //menu1.layer.borderWidth = 0.5;
        menu1.titleLabel.font = FontB(Font3);
        menu1.tag = 1000+i;
        [menu1 setTitle:@"" forState:0];
        [menu1 setTitleColor:[UIColor blackColor] forState:0];
        [menu1 addTarget:self action:@selector(onMenuBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        menu1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        menu1.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [popView addSubview:menu1];
        
        UIView* line = [[UIView alloc] initWithFrame:RECT(1, menu1.ey, popView.fw-2, 1)];
        line.backgroundColor = COLOR(215, 215, 215);
        [popView addSubview:line];
//        
//        [line release];
//        [menu1 release];
        
        top_y += POP_ROW_H;
    }
    
//    [popViewBg release];
//    [popView release];
}

- (void)popviewHidden:(BOOL)isHidden
{
    [self.view viewWithTag:1501].hidden = isHidden;
    [self.view viewWithTag:1502].hidden = isHidden;
}

- (void)addPagePopView
{
    UIButton* popViewBg = [[UIButton alloc] initWithFrame:RECT(0,0,SCREEN_W,SCREEN_H)];
    popViewBg.tag = 2501;
    popViewBg.hidden = YES;
    popViewBg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:popViewBg];
    [popViewBg clickBlock:^{
        [self pagePopHidden:YES];
    }];
    
    
    NSArray* condList = [m_PmName allValues];
    CGFloat pop_w = 80, pop_h = POP_ROW_H * condList.count;
    UIView* popView = [[UIView alloc] initWithFrame:RECT(APP_W-pop_w-60, self.navBarView.ey+0, pop_w, pop_h)];
    popView.backgroundColor = COLOR(239, 239, 239);
    popView.hidden = YES;
    popView.tag = 2502;
    popView.layer.borderWidth = 0.5;
    popView.layer.borderColor = COLOR(215, 215, 215).CGColor;
    popView.clipsToBounds = YES;
    showShadow(popView, CGSizeMake(0, 0));
    [self.view addSubview:popView];
    
    CGFloat top_y = 0;
    for (int i = 0; i < condList.count; i++) {
        UIButton* menu1 = [[UIButton alloc] initWithFrame:RECT(1, top_y, popView.fw-2, POP_ROW_H)];
        menu1.backgroundColor = [UIColor clearColor];
        //menu1.layer.borderWidth = 0.5;
        menu1.titleLabel.font = FontB(Font3);
        menu1.tag = 2000+i;
        [menu1 setTitle:condList[i] forState:0];
        [menu1 setTitleColor:[UIColor blackColor] forState:0];
        [menu1 addTarget:self action:@selector(pagePopBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        menu1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        menu1.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [popView addSubview:menu1];
        
        UIView* line = [[UIView alloc] initWithFrame:RECT(1, menu1.ey, popView.fw-2, 1)];
        line.backgroundColor = COLOR(215, 215, 215);
        [popView addSubview:line];
        
//        [line release];
//        [menu1 release];
        
        top_y += POP_ROW_H;
    }
    
//    [popViewBg release];
//    [popView release];
}

- (void)pagePopHidden:(BOOL)isHidden
{
    [self.view viewWithTag:2501].hidden = isHidden;
    [self.view viewWithTag:2502].hidden = isHidden;
}

- (void)pagePopBtnTouched:(UIButton*)sender
{
    [self pagePopHidden:YES];
    int index = sender.tag - 2000;
    NSString* value = [m_PmName allValues][index];
    NSArray* keys = [m_PmName allKeys];
    for (id key in keys) {
        if ([m_PmName[key] isEqualToString:value]) {
            int tmpKey = [key intValue];
            if (m_currPM != tmpKey) {
                m_currPM = tmpKey;
                UIButton* pageBtn = tagViewEx(self.view, 18856, UIButton);
                [pageBtn setTitle:m_PmName[@(m_currPM)] forState:0];
                
                m_monthView.hidden = (m_currPM != PMMonth);
            }
            return;
        }
    }
}


@end
