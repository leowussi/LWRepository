//
//  MyBookingList2.m
//  telecom
//
//  Created by ZhongYun on 14-12-26.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyBookingList2.h"
#import "TaskTypeBar.h"
#import "MyBookingListView.h"
#import "MyBookingAdd.h"
#import "MyBookingAddXcsg.h"

#define TVIEW_H         40
#define TAG_BASIC       18000
#define POP_ROW_H   40

@interface MyBookingList2 ()<TaskTypeBarDelegate>
{
    NSMutableArray* m_typeList;
    TaskTypeBar* m_typeView;
}
@end

@implementation MyBookingList2

//- (void)dealloc
//{
//    [m_typeView release];
//    [m_typeList release];
//    [super dealloc];
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的预约";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage* addIcon = [UIImage imageNamed:@"nav_add.png"];
    UIButton* addBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-addIcon.size.width), (NAV_H-addIcon.size.height)/2,
                                                            addIcon.size.width, addIcon.size.height)];
    [addBtn setBackgroundImage:addIcon forState:0];
    [addBtn addTarget:self action:@selector(onAddBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:addBtn];
    
    
    m_typeView = [[TaskTypeBar alloc] initWithFrame:RECT(0, 64, APP_W, TVIEW_H)];
    m_typeView.backgroundColor = [UIColor whiteColor];
    m_typeView.delegate = self;
    [self.view addSubview:m_typeView];
    
    m_typeList = [[NSMutableArray alloc] init];
    [self loadTypeList];
    
    [self addMorePopView];
}

- (void)loadTypeList
{
    if (!m_typeList) {
        m_typeList = [[NSMutableArray alloc] init];
        m_typeView = [[TaskTypeBar alloc] initWithFrame:RECT(0, 64, APP_W, TVIEW_H)];
        m_typeView.backgroundColor = [UIColor whiteColor];
        m_typeView.buttonWidth = 100;
        m_typeView.delegate = self;
        [self.view addSubview:m_typeView];
    }
    [m_typeList removeAllObjects];
    [m_typeList addObjectsFromArray:@[@{@"typeId":@(YY_SGRW), @"speciltyName":@"随工任务", @"taskAmount":@0},
                                      @{@"typeId":@(YY_SGYY), @"speciltyName":@"施工预约", @"taskAmount":@0}, ]];
    NSInteger selected = 0;
    if (m_typeList.count > 0) {
        CGRect frame = RECT(0, m_typeView.ey, APP_W, SCREEN_H-m_typeView.ey);
        for (int i=0; i<m_typeList.count; i++) {
            MyBookingListView* view = [[MyBookingListView alloc] initWithFrame:frame];
            view.typeInfo = m_typeList[i];
            view.backgroundColor = [UIColor whiteColor];
            view.tag = i + TAG_BASIC;
            view.hidden = YES;
            [self.view addSubview:view];

        }
        m_typeView.typeList = m_typeList;
        m_typeView.selected = selected;
    }
}

- (void)updatePointStatus:(NSInteger)index Count:(NSInteger)count
{
    [m_typeView updatePointStatus:index Count:count];
}

- (void)updateNavBtnStatus:(MyBookingListView*)view
{
    if (view.tag-TAG_BASIC == m_typeView.selected) {
        
    }
}

- (void)changeBefore:(TaskTypeBar*)sender
{
    [self.view viewWithTag:m_typeView.selected+TAG_BASIC].hidden = YES;
}

- (void)changeAfter:(TaskTypeBar*)sender
{
    NSInteger viewTag = sender.selected+TAG_BASIC;
    MyBookingListView* view = tagViewEx(self.view, viewTag, MyBookingListView);
    view.hidden = NO;
    [view viewDidLoad];
    [self updateNavBtns:view];
}

- (void)updateNavBtns:(MyBookingListView*)currView
{
    
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
    
    NSArray* condList = @[@"远程开门",@"现场随工"];
    CGFloat pop_w = APP_W/3, pop_h = POP_ROW_H * condList.count;
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
    for (int i = 0; i < condList.count; i++) {
        UIButton* menu1 = [[UIButton alloc] initWithFrame:RECT(1, top_y, popView.fw-2, POP_ROW_H)];
        menu1.backgroundColor = [UIColor clearColor];
        //menu1.layer.borderWidth = 0.5;
        menu1.titleLabel.font = FontB(Font3);
        menu1.tag = 1000+i;
        [menu1 setTitle:condList[i] forState:0];
        [menu1 setTitleColor:[UIColor blackColor] forState:0];
        [menu1 addTarget:self action:@selector(onMenuBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
//        menu1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        menu1.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [popView addSubview:menu1];
        
        UIView* line = [[UIView alloc] initWithFrame:RECT(1, menu1.ey, popView.fw-2, 1)];
        line.backgroundColor = COLOR(215, 215, 215);
        [popView addSubview:line];
        
        top_y += POP_ROW_H;
    }
}

- (void)popviewHidden:(BOOL)isHidden
{
    [self.view viewWithTag:1501].hidden = isHidden;
    [self.view viewWithTag:1502].hidden = isHidden;
}

- (void)onAddBtnTouched:(id)sender
{
    [self popviewHidden:NO];
}

- (void)onMenuBtnTouched:(UIButton*)sender
{
    [self popviewHidden:YES];
    
    int index = sender.tag - 1000;
    if (index == 0) {
        MyBookingAdd* vc = [[MyBookingAdd alloc] init];
        vc.respBlock = ^(id resp) {
            NOTIF_POST(BOOKING_UPDATE_SGRW, nil);
        };
        [self.navigationController pushViewController:vc animated:YES];
//        [vc release];
        
    } else if (index == 1) {
        MyBookingAddXcsg* vc = [[MyBookingAddXcsg alloc] init];
        vc.respBlock = ^(id resp) {
            NOTIF_POST(BOOKING_UPDATE_SGRW, nil);
        };
        [self.navigationController pushViewController:vc animated:YES];
//        [vc release];
    }
}


@end
