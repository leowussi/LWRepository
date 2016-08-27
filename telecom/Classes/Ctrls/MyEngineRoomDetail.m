//
//  MyEngineRoomDetail.m
//  telecom
//
//  Created by ZhongYun on 14-8-22.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyEngineRoomDetail.h"
#import "MyEngineRoomDetailView.h"
#import "TaskTypeBar.h"

#define TVIEW_H         40
#define TAG_BASIC       18000

@interface MyEngineRoomDetail ()<TaskTypeBarDelegate>
{
    NSMutableArray* m_typeList;
    TaskTypeBar* m_typeView;
}
@end

@implementation MyEngineRoomDetail

- (void)dealloc
{
    [m_typeView release];
    [m_typeList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.roomInfo[@"roomName"];
    
    m_typeView = [[TaskTypeBar alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, TVIEW_H)];
    m_typeView.backgroundColor = [UIColor whiteColor];
    m_typeView.delegate = self;
    [self.view addSubview:m_typeView];
    
    m_typeList = [[NSMutableArray alloc] init];
    [self loadTypeList];
}

- (void)loadTypeList
{
    if (!m_typeList) {
        m_typeList = [[NSMutableArray alloc] init];
        m_typeView = [[TaskTypeBar alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, TVIEW_H)];
        m_typeView.backgroundColor = [UIColor whiteColor];
        m_typeView.buttonWidth = 100;
        m_typeView.delegate = self;
        [self.view addSubview:m_typeView];
    }
    [m_typeList removeAllObjects];
    [m_typeList addObjectsFromArray:@[@{@"typeId":@(TI_SITE_INFO), @"speciltyName":@"局站信息", @"taskAmount":@0},
                                      @{@"typeId":@(TI_ROOM_INFO), @"speciltyName":@"机房信息", @"taskAmount":@0},
                                      @{@"typeId":@(TI_ROOM_FRAME), @"speciltyName":@"机房格局", @"taskAmount":@0}]];
    NSInteger selected = 0;
    if (m_typeList.count > 0) {
        CGRect frame = RECT(0, m_typeView.ey, APP_W, SCREEN_H-m_typeView.ey);
        for (int i=0; i<m_typeList.count; i++) {
            MyEngineRoomDetailView* view = [[MyEngineRoomDetailView alloc] initWithFrame:frame];
            view.roomId = self.roomInfo[@"roomId"];
            view.typeInfo = m_typeList[i];
            view.backgroundColor = [UIColor whiteColor];
            view.tag = i + TAG_BASIC;
            view.hidden = YES;
            [self.view addSubview:view];
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

- (void)updateNavBtnStatus:(MyEngineRoomDetailView*)view
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
    MyEngineRoomDetailView* view = tagViewEx(self.view, viewTag, MyEngineRoomDetailView);
    view.hidden = NO;
    [view buildView];
    [self updateNavBtns:view];
}

- (void)updateNavBtns:(MyEngineRoomDetailView*)currView
{
    
}

@end
