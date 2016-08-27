//
//  BackLocation.m
//  telecom
//
//  Created by ZhongYun on 15-4-13.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BackLocation.h"
#import "NSTimer+Blocks.h"
#import "TaskListView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define TM_SEND_INTERVAL   1800

id g_waitingGpsObj = nil;

@interface BackLocation ()<BMKLocationServiceDelegate,BMKMapViewDelegate>
//<CLLocationManagerDelegate,MKMapViewDelegate>

{
    BMKLocationService* m_locService;
    NSTimer* m_timer;
    NSTimer* m_StopTimer;
    CLLocationManager *locationmanager;
    __block UIBackgroundTaskIdentifier m_bgTaskId;
}
@end

@implementation BackLocation

+(BackLocation*)shared
{
    static BackLocation* instance = nil;
    if (instance == nil) {
        instance = [[BackLocation alloc] init];
    }
    return instance;
}
//-fno-objc-arc
//- (void)dealloc
//{
//    FREE_TIMER(m_timer);
//    g_waitingGpsObj = nil;
//    [m_locService stopUserLocationService];
//    [m_locService release];
////    [locationmanager stopUpdatingLocation];
//    [super dealloc];
//}

- (id)init
{
    if (self == [super init]) {
        NOTIF_ADD(UIApplicationDidEnterBackgroundNotification, onDidEnterBackground:);
        NOTIF_ADD(UIApplicationDidBecomeActiveNotification, onDidBecomeActive:);
        m_bgTaskId = UIBackgroundTaskInvalid;
        
        //        m_locService = [[BMKLocationService alloc]init];
        //        m_locService.delegate = self;
        
        //初始化BMKLocationService
        m_locService = [[BMKLocationService alloc]init];
        m_locService.delegate = self;
        //启动LocationService
        [m_locService startUserLocationService];
        
        if (UGET(U_GPS_INTV) == nil)
            USET(U_GPS_INTV, @(TM_SEND_INTERVAL));
        //        [self dingwei];
        [self restartTimer];
    }
    return self;
}

- (void)onTimerEvent
{
    //    NSLog(@"timer loop start location. (%d)", (int)[UIApplication sharedApplication].backgroundTimeRemaining);
    if (iOS_V >= 8.0) {
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestWhenInUseAuthorization];  // For foreground access
        [locationmanager requestAlwaysAuthorization]; // For background access
        //        [lm release];
    }
    
    g_waitingGpsObj = self;
    [m_locService startUserLocationService];
    
    //    [locationmanager startUpdatingLocation];
}

- (void)restartTimer
{
    NSTimeInterval interval = [UGET(U_GPS_INTV) doubleValue];
    //    NSLog(@"timer start (%ds).", (int)interval);
    if (m_timer == nil) {
        m_timer = [NSTimer timerWithTimeInterval:interval
                                          target:self selector:@selector(onTimerEvent)
                                        userInfo:nil repeats:YES];
        [m_timer setFireDate:[NSDate distantFuture]];
        [[NSRunLoop currentRunLoop]addTimer:m_timer forMode:NSDefaultRunLoopMode];
        [m_timer setFireDate:[NSDate date]];
    } else {
        FREE_TIMER(m_timer);
        m_timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                   target:self selector:@selector(onTimerEvent)
                                                 userInfo:nil repeats:YES];
    }
}

- (void)onDidEnterBackground:(NSNotification*)notification
{
    if(![[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        showAlert(@"本手机不支持多任务");
        return;
    }
    
    NSLog(@"DidEnterBackground");
    [self closeBackgroundTask];
    m_bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self closeBackgroundTask];
    }];
    NSLog(@"beginBackgroundTask:%d", (int)m_bgTaskId);
}

- (void)onDidBecomeActive:(NSNotification*)notification
{
    [self closeBackgroundTask];
}

- (void)closeBackgroundTask
{
    UIApplication* application = [UIApplication sharedApplication];
    if (m_bgTaskId != UIBackgroundTaskInvalid) {
        NSLog(@"endBackgroundTask:%d", (int)m_bgTaskId);
        [application endBackgroundTask:m_bgTaskId];
        m_bgTaskId = UIBackgroundTaskInvalid;
    }
}



- (void)sendGpsToServer:(CLLocation*)location
{
    //    if (UGET(U_TOKEN) != nil) {
    //        httpGET2(@{URL_TYPE:NW_uploadGps,
    //                   @"longitude":@(location.coordinate.longitude),
    //                   @"latitude":@(location.coordinate.latitude)}, ^(id result) {
    //
    //                       NSLog(@"<><>%@",result);
    //                       NSInteger nextUploadTime = [result[@"detail"][@"nextUploadTime"] integerValue]; //单位是毫秒
    //                       nextUploadTime = nextUploadTime / 1000; //单位是秒;
    //                       USET(U_GPS_INTV, @(nextUploadTime));
    //                       [self restartTimer];
    //                   }, ^(id result) {
    //                       [self restartTimer];
    ////                       showAlert(result[@"error"]);
    //                   });
    //    } else {
    //        NSLog(@"失败");
    //        [self restartTimer];
    //    }
    
    if (UGET(U_TOKEN) != nil) {
        
        NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
        NSString *accessToken = UGET(U_TOKEN);
        
        NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/uploadGps.json?operationTime=%@&accessToken=%@",ADDR_IP,ADDR_DIR,opreatinTime,accessToken];
        
        NSLog(@"uid == %@",requestUrl);
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"uploadGps";
        paraDict[@"longitude"] = @(location.coordinate.longitude);
        paraDict[@"latitude"] = @(location.coordinate.latitude);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager GET:requestUrl parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"<><>%@",responseObject);
            
            NSInteger nextUploadTime = [responseObject[@"detail"][@"nextUploadTime"] integerValue]; //单位是毫秒
            nextUploadTime = nextUploadTime / 1000; //单位是秒;
            USET(U_GPS_INTV, @(nextUploadTime));
            [self restartTimer];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error----%@",error);
            [self restartTimer];
        }];
        
    } else {
        NSLog(@"失败");
        [self restartTimer];
    }
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    NSLog(@"%f",userLocation.location.coordinate.latitude);
    NSLog(@"%f",userLocation.location.coordinate.longitude);
    if (g_waitingGpsObj==nil || g_waitingGpsObj==self) {
        CLLocationCoordinate2D coor = m_locService.userLocation.location.coordinate;
        [m_locService stopUserLocationService];
        g_waitingGpsObj = nil;
        if (ABS(coor.longitude)>10 && ABS(coor.latitude)>10) {
            NSLog(@"bgTimeRemaining: %d", (int)[UIApplication sharedApplication].backgroundTimeRemaining);
            NSLog(@"%f, %f", (double)coor.longitude, (double)coor.latitude);
            mainThread(sendGpsToServer:, m_locService.userLocation.location);
        }
    } else if ([g_waitingGpsObj isKindOfClass:[TaskListView class]]) {
        //        [g_waitingGpsObj performSelector:NSSelectorFromString(@"didUpdateUserLocation:") withObject:userLocation];
    }
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"%f",userLocation.location.coordinate.latitude);
    NSLog(@"%f",userLocation.location.coordinate.longitude);
    if (g_waitingGpsObj==nil || g_waitingGpsObj==self) {
        CLLocationCoordinate2D coor = m_locService.userLocation.location.coordinate;
        [m_locService stopUserLocationService];
        g_waitingGpsObj = nil;
        if (ABS(coor.longitude)>10 && ABS(coor.latitude)>10) {
            NSLog(@"bgTimeRemaining: %d", (int)[UIApplication sharedApplication].backgroundTimeRemaining);
            NSLog(@"%f, %f", (double)coor.longitude, (double)coor.latitude);
            mainThread(sendGpsToServer:, m_locService.userLocation.location);
        }
    } else if ([g_waitingGpsObj isKindOfClass:[TaskListView class]]) {
        //        [g_waitingGpsObj performSelector:NSSelectorFromString(@"didUpdateUserLocation:") withObject:userLocation];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    if (g_waitingGpsObj==nil || g_waitingGpsObj==self) {
        NSLog(@"didFailToLocateUserWithError:%@", error);
        [m_locService stopUserLocationService];
        g_waitingGpsObj = nil;
        [self restartTimer];
    } else if ([g_waitingGpsObj isKindOfClass:[TaskListView class]]) {
        //        [g_waitingGpsObj performSelector:NSSelectorFromString(@"didFailToLocateUserWithError:") withObject:error];
    }
}



//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}


@end