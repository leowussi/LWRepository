//
//  SignInOutView.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/15.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "SignInOutView.h"
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "CRMHelper.h"
#import "ZYFUrl.h"
#import "CRMHelper.h"
#import "ZYFHttpTool.h"
#import "SignInStatus.h"
#import <BaiduMapAPI/BMapKit.h>


#define kYesButtonClick 1

@interface SignInOutView() <CLLocationManagerDelegate,UIAlertViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    bool isGeoSearch;
}

@property (nonatomic,copy) NSString *addr;

@property (nonatomic,assign,getter=isSignIn) BOOL signIn;

@property (nonatomic,weak) UIPanGestureRecognizer *signInPan;
@property (nonatomic,weak) UIPanGestureRecognizer *signOutPan;
@property (weak, nonatomic) IBOutlet UILabel *signInStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *signOutStatusLabel;

@end

@implementation SignInOutView

-(instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"signInOut" owner:nil options:nil]lastObject];
        [self setButtons];
        self.signInStatusLabel.text = nil;
        self.signOutStatusLabel.text = nil;

        self.dateLabel.text = [self getSystemDate];

        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self;

        [self getSignInStatusFromServer];
        
    }
    return self;
}

- (void)dealloc
{
    _locService.delegate = nil;
}

- (void)getSignInStatusFromServer
{
    NSString *const urlString = kSignInOutStatusUrl;
    [ZYFHttpTool getWithURL:urlString params:nil success:^(id json) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *code = dictionary[@"Code"];
        NSString *msg = dictionary[@"Msg"];
        //如果msg中已经签到或者签退
        if (msg.length > 5) {
            NSRange range = [msg rangeOfString:@";"];
            NSString *signInString = [msg substringToIndex:range.location];
            NSString *signOutString = [msg substringFromIndex:(range.location + 1)];
            self.signInStatusLabel.text = [NSString stringWithFormat:@"今日签到时间:%@",signInString];
            self.signOutStatusLabel.text = [NSString stringWithFormat:@"今日签退时间:%@",signOutString];
        }else{
            self.signInStatusLabel.text = @"今日尚未签到";
            self.signOutStatusLabel.text = @"今日尚未签退";
        }

    } failure:^(NSError *error) {
        
    }];
}

-(void)setButtons{
    
    self.SignInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.SignOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    
    CGFloat x = kSystemScreenWidth / 4.0;
    CGFloat y = kSystemScreenHeight / 3.0 * 2.0;
    CGFloat w = kSystemScreenWidth / 4;
    
    self.SignInBtn.center = CGPointMake(x, y);
    self.SignInBtn.bounds = CGRectMake(0, 0, w, w);
    [self.SignInBtn setTitle:@"签到" forState:UIControlStateNormal];
    self.SignInBtn.titleLabel.font = [UIFont systemFontOfSize:23];
    self.SignInBtn.layer.cornerRadius = self.SignInBtn.frame.size.width / 2.0;
    [self.SignInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.SignInBtn.backgroundColor = [UIColor blueColor];
    
//    UIPanGestureRecognizer *signInPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [self.SignInBtn addGestureRecognizer:signInPan];
//    self.signInPan = signInPan;

    
    self.SignOutBtn.center = CGPointMake(3 * x, y);
    self.SignOutBtn.bounds = CGRectMake(0, 0, w, w);
    [self.SignOutBtn setTitle:@"签退" forState:UIControlStateNormal];
    self.SignOutBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    self.SignOutBtn.layer.cornerRadius = self.SignOutBtn.frame.size.width / 2.0;
    [self.SignOutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.SignOutBtn.backgroundColor = [UIColor yellowColor];
    
    [self.SignInBtn addTarget:self action:@selector(signInClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.SignOutBtn addTarget:self action:@selector(signOutClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIPanGestureRecognizer *signOutPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [self.SignOutBtn addGestureRecognizer:signOutPan];
//    self.signOutPan = signOutPan;
    
    [self addSubview:self.SignInBtn];
    [self addSubview:self.SignOutBtn];

}

- (void) handlePan: (UIPanGestureRecognizer *)rec{
    CGPoint point = [rec translationInView:self];
    rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
    [rec setTranslation:CGPointMake(0, 0) inView:self];
}


- (IBAction)signInClicked:(UIButton *)sender {
    self.signIn = YES;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"签到" message:@"确定现在签到吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (IBAction)signOutClicked:(UIButton *)sender {
    self.signIn = NO;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"签退" message:@"确定现在签退吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(NSString *)getSystemDate
{
    NSDate *now = [NSDate date];
//    NSLog(@"now == %@",now);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
//    NSLog(@"year=%d,month == %d,day == %d",year,month,day);
    
    NSString *dateText = [NSString stringWithFormat:@"%ld/%02ld/%02ld",year,month,day];
    return dateText;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self reverseWithLocation:userLocation.location];
}

/**
 *  将经度纬度发送到服务器
 *
 *  @param longitude 经度
 *  @param latitude  纬度
 */
-(void)sendLongitude:(double)longitude latitude:(double)latitude
{
    //只要获取到经纬度数据就停止更新当前位置
    [_locService stopUserLocationService];
    
    [MBProgressHUD showMessage:nil toView:ZYFKeyWindow];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    AFJSONRequestSerializer *afjsonRequestSerializer = [[AFJSONRequestSerializer alloc] init];
    [afjsonRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    mgr.requestSerializer = afjsonRequestSerializer;
    
    NSString *urlString = kSignInUrl;
    
    //    businessMgr.requestSerializer.timeoutInterval = 5.0;
    NSMutableDictionary *params =[NSMutableDictionary dictionary];
    NSNumber *longitu = [[NSNumber alloc]initWithDouble:longitude];
    NSNumber *latitu = [[NSNumber alloc]initWithDouble:latitude];
    
    params[@"new_longitude"] = [NSString stringWithFormat:@"%@",longitu];
    params[@"new_latitude"] = [NSString stringWithFormat:@"%@",latitu];
    params[@"new_address"] = [NSString stringWithFormat:@"%@",self.addr];
    if (self.isSignIn) {
        params[@"new_name"] = @"signin";
    }else{
        params[@"new_name"] = @"signout";
    }
    
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr PUT :urlString parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          //签到成功
          [MBProgressHUD hideAllHUDsForView:ZYFKeyWindow animated:YES];
          
          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves   error:nil];
          NSNumber *code  = dict[@"Code"];
          if (code.intValue == 1) {
              if (self.isSignIn) {
                  [MBProgressHUD showSuccess:@"签到成功"];
//                  self.signInStatusLabel.text = @"签到成功";
                  self.addr = nil;
              }else{
                  [MBProgressHUD showSuccess:@"签退成功"];
//                  self.signInStatusLabel.text = @"签退成功";
                  self.addr = nil;
              }
              [self getSignInStatusFromServer];

          }else{
              [MBProgressHUD showError:@"失败"];
          }
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          //签到失败
          [MBProgressHUD hideAllHUDsForView:ZYFKeyWindow animated:YES];
          [MBProgressHUD showError:@"失败"];
          
      }];
    
}

#pragma mark -- alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == kYesButtonClick) {
        NSLog(@"进入普通定位态");
        [_locService startUserLocationService];
    }else{
        
    }
}

#pragma mark - 反地理编码


-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        self.addr = showmeg;
        [self sendLongitude:item.coordinate.longitude latitude:item.coordinate.latitude];

    }else{
        [MBProgressHUD showError:@"反向地理编码错误"];
    }
}

- (void)reverseWithLocation:(CLLocation *)location
{
    isGeoSearch = false;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (location) {
        pt = (CLLocationCoordinate2D)location.coordinate;
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}



@end
