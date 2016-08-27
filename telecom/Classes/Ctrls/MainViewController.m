//
//  MainViewController.m
//  telecom
//
//  Created by ZhongYun on 14-6-11.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
#import "MyWorkViewController.h"
#import "MyBookingList2.h"
#import "MyRepairFaultList.h"
#import "MyRepairFaultListKB.h"
#import "MyNetManage.h"
#import "OnDutyLog.h"
#import "MyTaskMonthList.h"
#import "MyEngineRoom.h"
#import "QrReadView.h"
#import "MyResources.h"
#import "OnDutyLogHistory.h"
#import "PhotoViewer.h"

#define TAG_FUNC_BASE       500

@interface MainViewController ()
{
    BOOL m_coorOk;
}
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"i 运维";
    NOTIF_ADD(USER_CONFIG, addBtnIcons:);
    
    tagView(self.view, TAG_NAV_LEFT).hidden = YES;
    
    /*
     
     
     */
    
    
    
    
    //    通过指定的路径读取文本内容
    //newImageView(self.navBarView, @[@50, @"i_logo.png", RECT_OBJ((APP_W-74)/2, (NAV_H-30)/2, 74, 30)]);
    
    UIImage* settingIcon = [UIImage imageNamed:@"setting.png"];
    UIButton* btnIcon = [[UIButton alloc] initWithFrame:RECT((APP_W-settingIcon.size.width), 0, settingIcon.size.width, settingIcon.size.height)];
    [btnIcon setBackgroundImage:settingIcon forState:0];
    [btnIcon addTarget:self action:@selector(onBtnSettingTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:btnIcon];
    [btnIcon release];
    
    
    UIImage* bg = [UIImage imageNamed:(isBigScreen?@"main_bg_2.png":@"main_bg.png")];
    UIImageView* bgView = [[UIImageView alloc] initWithImage:bg];
    bgView.frame = RECT(0, self.navBarView.ey, bg.size.width, bg.size.height);
    [self.view addSubview:bgView];
    [bgView release];
    
    [QrReadView requestCamera];
    
    if (isBigScreen) {
        newImageView(self.view, @[@50, @"i_logo.png", RECT_OBJ((APP_W-74)/2, bgView.fy+40, 74, 30)]);
    }
}

- (void)addBtnIcons:(NSNotification*)notification
{
    CGFloat offset_y = (isBigScreen ? 135 : 90);
    NSArray* btnTitles = @[@[@"我的任务", @"func_01.png", @"TaskActivity", @1],
                           @[@"我的周期工作", @"func_02.png", @"IExtralAppActivity", @2],
                           @[@"我的报修(客保)", @"func_03.png", @"CustomerRepair", @3],
                           @[@"我的报修(WX)", @"func_03-1.png", @"BugActivity", @10],
                           @[@"我的预约", @"func_04.png", @"AppointmentListActivity", @4],
                           //@[@"i动力", @"func_05.png", @"iPower", @5],
                           @[@"我的机房", @"func_06.png", @"MyRoomActivity", @6],
                           @[@"资源巡检", @"func_07.png", @"ResourcesCheckAct", @7],
                           @[@"值班日志", @"func_08.png", @"LogBookAct", @8],
                           @[@"网管", @"func_09.png", @"NetMgrAct", @9],
                           @[@"我的资源", @"myresource.png", @"MyRes", @11] ];
    
    CGFloat x = 25, y = self.navBarView.ey+offset_y, w = 55, h = 55;
    if (SCREEN_H == 480) y -= 30;
    for (int i = 0; i < btnTitles.count; i++) {
        NSInteger btnTag = TAG_FUNC_BASE + [btnTitles[i][3] intValue];
        NSInteger titleTag = btnTag + 50;
        if ([self.view viewWithTag:btnTag] != nil) {
            UIButton* btnFunc = tagViewEx(self.view, btnTag, UIButton);
            UILabel* lbtitle = tagViewEx(self.view, titleTag, UILabel);
            btnFunc.hidden = YES;
            [btnFunc removeFromSuperview];
//            [btnFunc release];
            lbtitle.hidden = YES;
            [lbtitle removeFromSuperview];
            [lbtitle release];
        }
        
        NSString* appLocation = btnTitles[i][2];
        NSString* title = [self getAppIconTitle:appLocation];
        if (title == nil)
            continue;
        
        UIImage* btnIcon = [UIImage imageNamed:btnTitles[i][1]];
        UIButton* funcBtn = [[UIButton alloc] initWithFrame:RECT(x, y, w, h)];
        funcBtn.tag = btnTag;
        [funcBtn setBackgroundImage:btnIcon forState:0];
        [funcBtn addTarget:self action:@selector(onBtnFuncTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:funcBtn];
        newLabel(self.view, @[@(funcBtn.tag+50), RECT_OBJ(funcBtn.fx-25, funcBtn.ey+8, APP_W/3, Font3), [UIColor blackColor], FontB(Font3), title]).textAlignment = NSTextAlignmentCenter;
        [funcBtn release];
        
        x += (w + 50);
        if (x > (APP_W-w)) {
            x = 25;
            y += (h + 40);
        }
    }
}

- (void)onBtnFuncTouched:(UIButton*)sender
{
    NSInteger func_id = sender.tag - TAG_FUNC_BASE;
    if (func_id == 1) {
        MyTaskMonthList* vc = [[MyTaskMonthList alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    if (func_id == 2) {
        MyWorkViewController* vc = [[MyWorkViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    if (func_id == 3) {
        MyRepairFaultListKB* vc = [[MyRepairFaultListKB alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    if (func_id==10) {
        MyRepairFaultList* vc = [[MyRepairFaultList alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    if (func_id == 4) {
        MyBookingList2* vc = [[MyBookingList2 alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    if (func_id == 5) {
        NSString* strUrl = format(@"iPower://iPowerDK?accessToken=%@", UGET(U_POWER_TOKEN));
        NSString *unicodeURL = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:unicodeURL]];
    }
    if (func_id == 6) {
        MyEngineRoom* vc = [[MyEngineRoom alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    if (func_id == 7) {
        NSString* strUrl = format(@"iPower://iPowerPR?accessToken=%@", UGET(U_POWER_TOKEN));
        NSString *unicodeURL = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:unicodeURL]];
    }
    if (func_id == 8) {
        OnDutyLog* vc = [[OnDutyLog alloc] init];
        //        OnDutyLogHistory* vc = [[OnDutyLogHistory alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    if (func_id == 9) {
        MyNetManage* vc = [[MyNetManage alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    if (func_id == 11){
        NSLog(@"11");
#if defined(V_TELECOM)
        MyResources *vc = [[MyResources alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
#elif defined(V_ASSISTOR)
        
#endif
    }
}

//- (void)deliverMemorySelectItem:(NSString *)memorySelect
//{
//    self.memoryItem = memorySelect;
//}

- (NSString*)getAppIconTitle:(NSString*)appLocation
{
    NSArray* list5 = UGET(U_CONFIG)[@"list5"];
    for (NSDictionary* item in list5) {
        NSString* tmpa = [item[@"appLocation"] lowercaseString];
        NSString* tmpb = [appLocation lowercaseString];
        if ([tmpa rangeOfString:tmpb].location != NSNotFound) {
            if ([item[@"isVisible"] intValue] == 1) {
                return item[@"appName"];
            }
        }
    }
    return nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    if (!m_coorOk) {
        getCoordinate();
        m_coorOk = YES;
    }
}

- (void)onBtnSettingTouched:(id)sender
{
    SettingsViewController* vc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}



- (void)onBtnIconTouched:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
}


//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)apsToMyBookingList
{
    if (self.navigationController.viewControllers.count > 1) {
        id first = self.navigationController.viewControllers[1];
        if ([first isKindOfClass:[MyBookingList2 class]]) {
            
        } else {
            [self popToRootViewController];
            [self performSelector:@selector(toShowMyBookingList) withObject:nil afterDelay:1];
        }
    } else {
        [self toShowMyBookingList];
    }
}

- (void)apsToMyBookingDetail:(NSString*)detailId WithType:(int)type
{
    if (self.navigationController.viewControllers.count > 1) {
        id first = self.navigationController.viewControllers[1];
        if ([first isKindOfClass:[MyBookingList2 class]]) {
            
        } else {
            [self popToRootViewController];
            [self performSelector:@selector(toShowMyBookingList) withObject:nil afterDelay:1];
        }
    } else {
        [self toShowMyBookingList];
    }
}

- (void)toShowMyBookingList
{
    MyBookingList2* vc = [[MyBookingList2 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

@end
