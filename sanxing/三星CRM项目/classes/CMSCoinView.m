////
////  CMSCoinView.m
////  FlipViewTest
////
////  Created by Rebekah Claypool on 10/1/13.
////  Copyright (c) 2013 Coffee Bean Studios. All rights reserved.
////
//
//#import "CMSCoinView.h"
//#import <CoreLocation/CoreLocation.h>
//#import "AFNetworking.h"
//#import "MBProgressHUD+MJ.h"
//#import "CRMHelper.h"
//#import "ZYFUrl.h"
//#import "CRMHelper.h"
//#import <BaiduMapAPI/BMapKit.h>
//
//
//#define kYesButtonClick 1
//#define kDisplayingPrimary @"displayingPrimary"
//
//
//@interface CMSCoinView ()<CLLocationManagerDelegate,UIAlertViewDelegate,BMKLocationServiceDelegate>
//{
//    BMKLocationService* _locService;
//}
///**
// *  当前应该显示签到还是签退
// */
//@property (nonatomic,assign) BOOL displayingPrimary;
//@property (nonatomic,strong) CLLocationManager *locationManager;
///**
// *  当日签到的次数
// */
//@property (nonatomic,assign) int numberOfSignIn;
//
//@property (nonatomic,assign) NSInteger result;
//
////是否发起了
//
//
//@end
//
//@implementation CMSCoinView
//
//@synthesize primaryView=_primaryView, secondaryView=_secondaryView, spinTime;
//
//- (id) initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if(self){
//        spinTime = 1.0;
//        self.displayingPrimary = NO;
//        self.locationManager = [[CLLocationManager alloc]init];
//        
//        self.result = [ZYFUserDefaults integerForKey:ZYFSignInSucess];;
//        
//        _locService.delegate = self;
//        
//    }
//    return self;
//}
//
//- (void)dealloc
//{
//    _locService.delegate = nil;
//}
//
//- (void) setupLocation
//{
////    // 如果定位服务可用
////    if([CLLocationManager locationServicesEnabled])
////    {
////
////        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
////        self.locationManager.distanceFilter = 50;
////        self.locationManager.delegate = self;
////        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
////            [self.locationManager requestAlwaysAuthorization];
////        }
////        [self.locationManager startUpdatingLocation];
////    }
////    else
////    {
////        [MBProgressHUD showError:@"无法使用定位服务！"];
////    }
//    
//
//
//}
//
//
//- (void) setPrimaryView:(UIView *)primaryView{
//    _primaryView = primaryView;
//    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [self.primaryView setFrame: frame];
//    [self roundView: self.primaryView];
//    self.primaryView.userInteractionEnabled = YES;
//    [self addSubview: self.primaryView];
//    
//    self.result = [ZYFUserDefaults integerForKey:ZYFSignInSucess];
//
//    if (self.result == 2) {
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setSignIn:)];
//        gesture.numberOfTapsRequired = 1;
//        [self.primaryView addGestureRecognizer:gesture];
//    }else{
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setSignOut:)];
//        gesture.numberOfTapsRequired = 1;
//        [self.primaryView addGestureRecognizer:gesture];
//    }
//    [self roundView:self];
//}
//
//
//- (void) setSecondaryView:(UIView *)secondaryView{
//    _secondaryView = secondaryView;
//    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [self.secondaryView setFrame: frame];
//    [self roundView: self.secondaryView];
//    self.secondaryView.userInteractionEnabled = YES;
//    [self addSubview: self.secondaryView];
//    [self sendSubviewToBack:self.secondaryView];
//    
//    self.result = [ZYFUserDefaults integerForKey:ZYFSignInSucess];
//    
//    if (self.result == 2) {
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setSignIn:)];
//        gesture.numberOfTapsRequired = 1;
//        [self.secondaryView addGestureRecognizer:gesture];
//    }else{
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setSignOut:)];
//        gesture.numberOfTapsRequired = 1;
//        [self.secondaryView addGestureRecognizer:gesture];
//    }
//    [self roundView:self];
//}
//
//- (void) roundView: (UIView *) view{
//    [view.layer setCornerRadius: (self.frame.size.height/2)];
//    [view.layer setMasksToBounds:YES];
//}
//
///**
// *  签到、签退 按钮切换
// */
//-(IBAction) flipTouched:(id)sender{
//    [UIView transitionFromView:self.primaryView
//                        toView:self.secondaryView
//                      duration: spinTime
//                       options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
//                    completion:^(BOOL finished) {
//                    }
//     ];
//    if (self.result == 1) {
//        [ZYFUserDefaults setInteger:2 forKey:ZYFSignInSucess];
//
//    }else if (self.result == 2){
//        [ZYFUserDefaults setInteger:1 forKey:ZYFSignInSucess];
//
//    }else{
//        [ZYFUserDefaults setInteger:2 forKey:ZYFSignInSucess];
//
//    }
//    
//
//
//}
//
//-(void)setSignIn:(id)sender
//{
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"签到" message:@"确定现在签到吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
//}
//
//-(void)setSignOut:(id)sender
//{
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"签退" message:@"确定现在签退吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
//}
//
////#pragma mark --locationManager
////// 成功获取定位数据后将会激发该方法
////-(void)locationManager:(CLLocationManager *)manager
////    didUpdateLocations:(NSArray *)locations
////{
////    // 获取最后一个定位数据
////    CLLocation* location = [locations lastObject];
////    
////    // 依次获取CLLocation中封装的经度、纬度
////    double longitude = location.coordinate.longitude;
////    double latitude = location.coordinate.latitude;
////    //如果定位成功，将经纬度发送给服务器
////    [self sendLongitude:longitude latitude:latitude];
////    
////}
//
///**
// *用户位置更新后，会调用此函数
// *@param userLocation 新的用户位置
// */
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    // 依次获取CLLocation中封装的经度、纬度
//    double longitude = userLocation.location.coordinate.longitude;
//    double latitude = userLocation.location.coordinate.latitude;
//    //如果定位成功，将经纬度发送给服务器
//    [self sendLongitude:longitude latitude:latitude];
//}
//
//// 定位失败时激发的方法
//- (void)locationManager:(CLLocationManager *)manager
//       didFailWithError:(NSError *)error
//{
//    NSLog(@"定位失败: %@",error);
//}
//
///**
// *  将经度纬度发送到服务器
// *
// *  @param longitude 经度
// *  @param latitude  纬度
// */
//-(void)sendLongitude:(double)longitude latitude:(double)latitude
//{
//    [MBProgressHUD showMessage:nil toView:ZYFKeyWindow];
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    AFJSONRequestSerializer *afjsonRequestSerializer = [[AFJSONRequestSerializer alloc] init];
//    [afjsonRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    mgr.requestSerializer = afjsonRequestSerializer;
//    
//    NSString *urlString = kSignInUrl;
//    
//    //    businessMgr.requestSerializer.timeoutInterval = 5.0;
//    NSMutableDictionary *params =[NSMutableDictionary dictionary];
//    NSNumber *longitu = [[NSNumber alloc]initWithDouble:longitude];
//    NSNumber *latitu = [[NSNumber alloc]initWithDouble:latitude];
//    
//    params[@"longitude"] = [NSString stringWithFormat:@"%@",longitu];
//    params[@"latitude"] = [NSString stringWithFormat:@"%@",latitu];
//    
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [mgr PUT :urlString parameters:params
//      success:^(AFHTTPRequestOperation *operation, id responseObject) {
//          //签到成功
//          [MBProgressHUD hideAllHUDsForView:ZYFKeyWindow animated:YES];
//          
//          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves   error:nil];
//          NSNumber *code  = dict[@"Code"];
//          NSLog(@"msg === %@",dict[@"Msg"]);
//          if (code.intValue == 1) {
//              if (self.result == 1) {
//              //如果result==1，表明当前进行的是签到请求
//                  [self flipTouched:nil];
//                  [MBProgressHUD showSuccess:@"签到成功"];
//                  [_locService stopUserLocationService];
//                  return ;
//              }else if(self.result == 2){
//                  [self flipTouched:nil];
//                  [MBProgressHUD showSuccess:@"签退成功"];
//                  return;
//              }else{
//                  [self flipTouched:nil];
//                  [MBProgressHUD showSuccess:@"签到成功"];
//                  [_locService stopUserLocationService];
//                  return ;
//              }
//          }else{
//              [MBProgressHUD showError:@"失败"];
//          }
//
//          
//      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//          //签到失败
//          [MBProgressHUD hideAllHUDsForView:ZYFKeyWindow animated:YES];
//          NSLog(@"error === %@",error);
//          [MBProgressHUD showError:@"失败"];
//          
//      }];
//    
//}
//
//#pragma mark -- alertView
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == kYesButtonClick) {
////        [self setupLocation];
//        NSLog(@"进入普通定位态");
//        [_locService startUserLocationService];
//    }else{
//        
//    }
//}
//
//
//
//@end
