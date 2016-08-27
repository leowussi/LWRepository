//
//  AssiMainViewController.m
//  telecom
//
//  Created by ZhongYun on 14-7-9.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "AssiMainViewController.h"
#import "QrReadView.h"
#import "TaskTypeBar.h"
#import "AssiMainAddSGYY.h"
#import "AssiMainListView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#define TVIEW_H         40
#define TAG_BASIC       18000
#define POP_ROW_H   40

@interface AssiMainViewController ()<TaskTypeBarDelegate/*, BMKLocationServiceDelegate*/>
{
    NSMutableArray* m_typeList;
    TaskTypeBar* m_typeView;
    
//    BMKLocationService* m_locService;
}
@end

@implementation AssiMainViewController

- (void)dealloc
{
//    [m_locService stopUserLocationService];
//    [m_locService release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"i 运维外协版";
    tagView(self.view, TAG_NAV_LEFT).hidden = YES;
    NOTIF_ADD(ASSI_ADD_SGYY, onAddSuccessForSGYY:);
    
    UIImage* addIcon = [UIImage imageNamed:@"nav_add.png"];
    UIButton* addBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-addIcon.size.width), (NAV_H-addIcon.size.height)/2,
                                                            addIcon.size.width, addIcon.size.height)];
    [addBtn setBackgroundImage:addIcon forState:0];
    [addBtn addTarget:self action:@selector(onAddBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:addBtn];
    [addBtn release];
    
    m_typeView = [[TaskTypeBar alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, TVIEW_H)];
    m_typeView.backgroundColor = [UIColor whiteColor];
    m_typeView.delegate = self;
    [self.view addSubview:m_typeView];
    
    m_typeList = [[NSMutableArray alloc] init];
    [self loadTypeList];
    
    [self addMorePopView];
    
    [self initPublicObjs];
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
    [m_typeList addObjectsFromArray:@[@{@"typeId":@(YY_SGRW), @"speciltyName":@"随工任务", @"taskAmount":@0},
                                      @{@"typeId":@(YY_SGYY), @"speciltyName":@"施工预约", @"taskAmount":@0}, ]];
    NSInteger selected = 0;
    if (m_typeList.count > 0) {
        CGRect frame = RECT(0, m_typeView.ey, APP_W, SCREEN_H-m_typeView.ey);
        for (int i=0; i<m_typeList.count; i++) {
            AssiMainListView* view = [[AssiMainListView alloc] initWithFrame:frame];
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

- (void)onAddSuccessForSGYY:(NSNotification*)notifcation
{
    m_typeView.selected = 1;
}

- (void)updatePointStatus:(NSInteger)index Count:(NSInteger)count
{
    [m_typeView updatePointStatus:index Count:count];
}

- (void)updateNavBtnStatus:(AssiMainListView*)view
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
    AssiMainListView* view = tagViewEx(self.view, viewTag, AssiMainListView);
    view.hidden = NO;
    [view viewDidLoad];
    [self updateNavBtns:view];
}

- (void)updateNavBtns:(AssiMainListView*)currView
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
    
    NSArray* condList = @[@"注册",@"施工预约"];
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
        
        [line release];
        [menu1 release];
        
        top_y += POP_ROW_H;
    }
    
    [popViewBg release];
    [popView release];
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
//        AssiImsiSettings* vc = [[AssiImsiSettings alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        [vc release];
    } else if (index == 1) {
        AssiMainAddSGYY* vc = [[AssiMainAddSGYY alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Other obj func
- (void)initPublicObjs
{
    NOTIF_ADD(ASSI_IMSI_UNKNOWN, toUserRegist:);
    NOTIF_ADD(DEVICE_TOKEN_RECIVED, onDeviceTokenRecieved:);
    NOTIF_ADD(ASSI_REGIST_SUCCESS, onRegistSuccess:);
//    NOTIF_ADD(GPS_LOCATION_START, onGpsLocationStart:);
    
//    m_locService = [[BMKLocationService alloc]init];
//    m_locService.delegate = self;
    
    if (UGET(ASSI_IMSI) == nil) {
        [self getImsi];
    }
    [QrReadView requestCamera];
}

- (void)loadData
{
    m_typeView.selected = 0;
    AssiMainListView* view = tagViewEx(self.view, m_typeView.selected+TAG_BASIC, AssiMainListView);
    [view loadData];
}

- (void)toUserRegist:(NSNotification*)notification
{
//    if (UGET(ASSI_CONSTRUCTION_ID) == nil) {
//        showAlert(@"当前手机未注册，请先完成注册。");
//        AssiImsiSettings* vc = [[AssiImsiSettings alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        [vc release];
//    } else {
//        showAlert(@"您的手机注册无效，请联系管理员。");
//    }
}

- (void)getImsi
{
    if (UGET(DEVICE_TOKEN) != nil) {
        USET(ASSI_IMSI, UGET(DEVICE_TOKEN));
        [self loadData];
    } else {
        showLoading(@"请稍等(远程通知)！");
    }
}

- (void)onDeviceTokenRecieved:(id)sender
{
    if (UGET(ASSI_IMSI) == nil) {
        hideLoading();
        [self getImsi];
    }
}

- (void)onRegistSuccess:(id)sender
{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1];
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)apsAssiMain
{
    [self popToRootViewController];
    [self loadData];
}

- (void)apsAssiDetail:(NSString*)detailId
{
    [self popToRootViewController];
    
    m_typeView.selected = 0;
    AssiMainListView* view = tagViewEx(self.view, m_typeView.selected+TAG_BASIC, AssiMainListView);
    [view openAssiDetailById:detailId];

}

/////////////////////////////////////////////////////////////////////////////////////
//- (void)onGpsLocationStart:(NSNotification*)notification
//{
//    [m_locService startUserLocationService];
//}

//- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
//{
//    [m_locService stopUserLocationService];
//    if (ABS(m_locService.userLocation.location.coordinate.longitude)>10
//        && ABS(m_locService.userLocation.location.coordinate.latitude)>10) {
//        NOTIF_POST(GPS_LOCATION_OVER, m_locService.userLocation.location);
//    }
//}

//- (void)didFailToLocateUserWithError:(NSError *)error
//{
//    [m_locService stopUserLocationService];
//#if !TARGET_IPHONE_SIMULATOR
//    showAlert(@"GPS定位失败!");
//#else
//    NOTIF_POST(GPS_LOCATION_OVER, nil);
//#endif
//}

@end
