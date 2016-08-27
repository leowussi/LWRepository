//
//  AppDelegate.h
//  telecom
//
//  Created by ZhongYun on 14-6-11.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
#import "BMCustomBottomBarView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@class RootTAMViewController;

@protocol AppcationDelegate <NSObject>

//客保故障
- (void)appcationDelegatePushToControllerWith:(NSString *)workNo;
//风险操作推送
- (void)appcationDelegatePushToRiskOperationControllerWith:(NSString *)workNo;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>
@property (nonatomic,assign)  id <AppcationDelegate> delegate;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL existNewVersion;
@property (nonatomic, copy)   NSString* netVersion;
@property (strong, nonatomic) BMCustomBottomBarView* bottomBarView;
@property (strong, nonatomic) DDMenuController *menuController;
@property (strong, nonatomic) RootTAMViewController *rootVc;
@end
extern AppDelegate* g_app;


@interface UINavigationControllerEx : UINavigationController

@end