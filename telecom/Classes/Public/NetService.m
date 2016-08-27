//
//  NetService.m
//  quanzhi
//
//  Created by ZhongYun on 14-1-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "NetService.h"
#import "utils.h"
#import "defines.h"
#import "Categorys.h"
#import "JSON.h"
#import "Reachability.h"
#include <sys/utsname.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "AFNetworking.h"
#import "HWBProgressHUD.h"
#import "CoreStatus.h"

#define RESP_STATUS     @"result"
#define RESP_INFO       @"msg"
#define RESP_DATA       @"body"


#if ENV_TYPE ==1 //测试
#define CHECK_CONNECTIONT_IP                 @"http://www.guanghua.sh.cn"
#elif ENV_TYPE ==2 //模拟
#define CHECK_CONNECTIONT_IP                 @"http://www.guanghua.sh.cn"
#elif ENV_TYPE ==3 //正式
#define CHECK_CONNECTIONT_IP                 @"http://www.baidu.com"
#else //其他
#define CHECK_CONNECTIONT_IP                 @"http://www.baidu.com"
#endif


const BOOL NET_SUPPORT = YES;

@interface NetService : MKNetworkEngine<BMKLocationServiceDelegate>
{
    int internetStatus;
    NSString* serv_ip;
    BMKLocationService *_locService;
}
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
+ (NetService*)shared;
- (BOOL)httpGet:(NSDictionary*)arg onSuccess:(RespBlock)succ onFailed:(RespBlock)fail onTimeout:(RespBlock)timeout;

- (BOOL)httpPostRequest:(NSDictionary*)arg onSuccess:(RespBlock)succ onFailed:(RespBlock)fail onTimeout:(RespBlock)timeout;

- (BOOL)postRequest:(NSDictionary*) arg;
- (BOOL)checkNetwork;
- (BOOL)downFileFrom:(NSDictionary*)arg onProgress:(ProgBock)prog onSuccess:(RespBlock)succ
            onFailed:(RespBlock)fail onTimeout:(RespBlock)timeout;
@end

@implementation NetService
-(AFHTTPRequestOperationManager *)manager{
    
    if (_manager == nil) {
        
        _manager = [AFHTTPRequestOperationManager manager];
        
        // 设置超时时间
        
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        
        _manager.requestSerializer.timeoutInterval = 15.0f;
        
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    }
    
    return _manager;
    
}
+ (NetService*)shared
{
    static NetService* instance = NULL;
    if (!instance)
    {
        instance = [[NetService alloc] init];
    }
    return instance;
}

- (id)init
{
    if (self = [super initWithHostName:CHECK_CONNECTIONT_IP customHeaderFields:nil]){//www.baidu.com
        internetStatus = 0;
        [NSTimer scheduledTimerWithTimeInterval:90 target:self selector:@selector(checkInternetConnect) userInfo:nil repeats:YES];
        serv_ip = UGET(APP_SERVER);
    }
    return self;
}


- (BOOL)httpPostRequest:(NSDictionary*)arg onSuccess:(RespBlock)succ onFailed:(RespBlock)fail onTimeout:(RespBlock)timeout
{
//    if ( ![self checkNetwork] ){
//        return NO;
//    }
    
    BOOL internetConnect = [self methodOfConnection];
    if (!internetConnect) {
        [self showMessage:@"当前无网络连接！"];
    }
    
    BOOL isShowLoading = ( [arg objectForKey:HIDE_LOADING] == nil ) ;
    if ( isShowLoading ) {
        showLoading(@"请稍等");
    }
    
    
//    //网络类型
//    [self methodOfConnection];
    //位置信息
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    //系统版本
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSMutableString *mutablStr = [NSMutableString string];
    [mutablStr appendString:systemName];
    [mutablStr appendString:systemVersion];
    USET(U_SYSTEMVERSION, mutablStr);
    //应用版本
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    USET(U_APPVERSION, appVersion);
    //硬件型号
    NSString *deviceVersion = [self getCurrentDeviceModel];
    USET(U_DEVICEVERSION, deviceVersion);
    NSString* urlString = [arg objectForKey:URL_TYPE];
    if (!urlString) {
        return NO;
    }
    BOOL isPushServ = ([urlString rangeOfString:@"pushService"].location != NSNotFound);
    if (isPushServ) {
        urlString = [NSString stringWithFormat:@"http://%@/%@.json", serv_ip, urlString];
    } else {
        urlString = [NSString stringWithFormat:@"http://%@/%@/%@.json", serv_ip, ADDR_DIR, urlString];
    }
    
    NSMutableDictionary* paras = [NSMutableDictionary dictionaryWithDictionary:arg];
    [paras removeObjectForKey:URL_TYPE];
    
    paras[@"operationTime"] = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    NSString* tokenName = (isPushServ ? @"userToken" : @"accessToken");
    NSString* tokenValue = UGET(U_TOKEN);
    
    if (tokenValue != nil) {
        paras[tokenName] = tokenValue;
    }
    
    paras[@"network"] = UGET(U_CONNECTIONWAY);
    if (UGET(USERLOCATION_LATITUDE)) {
        paras[@"smy"] = UGET(USERLOCATION_LATITUDE);
    }
    if (UGET(USERLOCATION_LONGITUDE)) {
        paras[@"smx"] = UGET(USERLOCATION_LONGITUDE);
    }
    
    paras[@"appVersion"] = UGET(U_APPVERSION);
    paras[@"deviceType"] = @1;
    paras[@"osVersion"] = UGET(U_SYSTEMVERSION);
    paras[@"deviceMode"] = UGET(U_DEVICEVERSION);
    
//    NSString* urlString = [arg objectForKey:URL_TYPE];
//    if (!urlString) {
//        return NO;
//    }
//    BOOL isPushServ = ([urlString rangeOfString:@"pushService"].location != NSNotFound);
//    if (isPushServ) {
//        urlString = [NSString stringWithFormat:@"http://%@/%@.json", serv_ip, urlString];
//    } else {
//        urlString = [NSString stringWithFormat:@"http://%@/%@/%@.json", serv_ip, ADDR_DIR, urlString];
//    }
    
    
//    NSMutableDictionary* paras = [NSMutableDictionary dictionaryWithDictionary:arg];
//    [paras removeObjectForKey:URL_TYPE];
//    
//    paras[@"operationTime"] = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
//    NSString* tokenName = (isPushServ ? @"userToken" : @"accessToken");
//    NSString* tokenValue = UGET(U_TOKEN);
//    if (tokenValue == nil) tokenValue = UGET(ASSI_IMSI);
//    if (tokenValue != nil) {
//        paras[tokenName] = tokenValue;
//    }
#if defined(V_TELECOM)
    paras[@"appCode"] = @"10000";
#elif defined(V_ASSISTOR)
    paras[@"appCode"] = @"10002";
#endif
    
    
    
    MKNetworkOperation *op = [self operationWithURLString:urlString params:paras httpMethod:@"POST"];
    op.showLoading = isShowLoading;
    //op.stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000); //BGK编码
    
    NSLog(@"HTTP-POST:\n%@", op.url);
    [op onCompletion:^(MKNetworkOperation *operation) {
        [self onCompletion:operation onSuccess:succ onFailed:fail];
    } onFailed:^(MKNetworkOperation *operation) {
        [self onFailed:operation onFailed:fail];
    }onTimeout:^(MKNetworkOperation *operation) {
        [self onTimeOut:operation onTimeout:timeout];
    }];
    [self enqueueOperation:op];
    [_locService stopUserLocationService];
    
    return YES;
}

- (BOOL) httpGet:(NSDictionary*)arg onSuccess:(RespBlock)succ onFailed:(RespBlock)fail onTimeout:(RespBlock)timeout
{

    //网络类型
    BOOL internetConnect = [self methodOfConnection];
    if (!internetConnect) {
        [self showMessage:@"当前无网络连接！"];
    }
    
    BOOL isShowLoading = ( [arg objectForKey:HIDE_LOADING] == nil ) ;
    if ( isShowLoading ) {
        showLoading(@"请稍等");
    }
    
    //位置信息
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
        [_locService startUserLocationService];
    //系统版本
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSMutableString *mutablStr = [NSMutableString string];
    [mutablStr appendString:systemName];
    [mutablStr appendString:systemVersion];
    USET(U_SYSTEMVERSION, mutablStr);
    //应用版本
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    USET(U_APPVERSION, appVersion);
    //硬件型号
    NSString *deviceVersion = [self getCurrentDeviceModel];
    USET(U_DEVICEVERSION, deviceVersion);
    //运营商
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *carrieroperator = carrier.carrierName;
    if ([carrieroperator isEqualToString:@"中国移动"]) {
        carrieroperator = @"ChinaMobile";
    }else if ([carrieroperator isEqualToString:@"中国联通"]){
        carrieroperator = @"ChinaUnicom";
    }else if ([carrieroperator isEqualToString:@"中国电信"]){
        carrieroperator = @"ChinaTelecom";
    }else{
        carrieroperator = @"Others";
    }
    //UUID
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString* urlString = [arg objectForKey:URL_TYPE];
    if (!urlString) {
        return NO;
    }
    BOOL isPushServ = ([urlString rangeOfString:@"pushService"].location != NSNotFound);
    if (isPushServ) {
        urlString = [NSString stringWithFormat:@"http://%@/%@.json", serv_ip, urlString];
    } else {
        urlString = [NSString stringWithFormat:@"http://%@/%@/%@.json", serv_ip, ADDR_DIR, urlString];
    }
    
    NSMutableDictionary* paras = [NSMutableDictionary dictionaryWithDictionary:arg];
    [paras removeObjectForKey:URL_TYPE];
    
    paras[@"operationTime"] = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    NSString* tokenName = (isPushServ ? @"userToken" : @"accessToken");
    NSString* tokenValue = UGET(U_TOKEN);
    
    if (tokenValue != nil) {
        paras[tokenName] = tokenValue;
    }
    
    paras[@"network"] = UGET(U_CONNECTIONWAY);
    if (UGET(USERLOCATION_LATITUDE)) {
        paras[@"smy"] = UGET(USERLOCATION_LATITUDE);
    }
    if (UGET(USERLOCATION_LONGITUDE)) {
        paras[@"smx"] = UGET(USERLOCATION_LONGITUDE);
    }
    
    paras[@"appVersion"] = UGET(U_APPVERSION);
    paras[@"deviceType"] = @1;
    paras[@"osVersion"] = UGET(U_SYSTEMVERSION);
    paras[@"deviceMode"] = UGET(U_DEVICEVERSION);
    paras[@"carrieroperator"] = carrieroperator;
    paras[@"uuid"] = uuid;
    
#if defined(V_TELECOM)
    paras[@"appCode"] = @"10000";
#elif defined(V_ASSISTOR)
    paras[@"appCode"] = @"10002";
#endif
    
    
    
    MKNetworkOperation *op = [self operationWithURLString:urlString params:paras httpMethod:@"GET"];
    op.showLoading = isShowLoading;
    op.stringEncoding = NSUTF8StringEncoding;
    
    NSLog(@"HTTP-GET:\n%@", op.url);
    [op onCompletion:^(MKNetworkOperation *operation) {
        [self onCompletion:operation onSuccess:succ onFailed:fail];
    } onFailed:^(MKNetworkOperation *operation) {
        [self onFailed:operation onFailed:fail];
    }onTimeout:^(MKNetworkOperation *operation) {
        [self onTimeOut:operation onTimeout:timeout];
    }];
    [self enqueueOperation:op];
    
    [_locService stopUserLocationService];
    return YES;
}

//获得设备型号
- (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1691/A1700)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1690/A1699)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod touch 6G (A1574)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad mini 3 (A1599)";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad mini 3 (A1600)";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad mini 3 (A1601)";
    
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad mini 4 (A1538)";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad mini 4 (A1550)";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2 (A1566)";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2 (A1567)";
    
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (A1584)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (A1652)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //    [_mapView updateLocationData:userLocation];
    double lat = userLocation.location.coordinate.latitude ;
    double longt = userLocation.location.coordinate.longitude;
    NSNumber *latitude = [NSNumber numberWithDouble:lat];
    NSNumber *longitude = [NSNumber numberWithDouble:longt];
    USET(USERLOCATION_LATITUDE, latitude);
    USET(USERLOCATION_LONGITUDE, longitude);
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
//    NSLog(@"location error!");
//    showAlert([error localizedDescription]);
}


//检测网络连接的方式WiFi/WWAN
- (BOOL)methodOfConnection
{//测试环境用www.guanghua.sh.cn\生产环境用www.baidu.com
    Reachability *recahMethod = [Reachability reachabilityWithHostname:@"www.guanghua.sh.cn"];
    switch ([recahMethod currentReachabilityStatus]) {
        case NotReachable:
            
            USET(U_CONNECTIONWAY, @"NotReachable");
//            break;
            return NO;
        case ReachableViaWiFi:
            
            USET(U_CONNECTIONWAY, @"ReachableViaWiFi");
//            break;
            return YES;
        case ReachableViaWWAN:
            
            USET(U_CONNECTIONWAY, @"ReachableViaWWAN");
//            break;
            return YES;
    }
}

- (BOOL) httpPost:(NSDictionary*)arg onSuccess:(RespBlock)succ onFailed:(RespBlock)fail onTimeout:(RespBlock)timeout
{
    if ( ![self checkNetwork] ){
        return NO;
    }
    
    BOOL isShowLoading = ( [arg objectForKey:HIDE_LOADING] == nil ) ;
    if ( isShowLoading ) {
        showLoading(@"请稍等");
    }
    
    NSString* urlString = [arg objectForKey:URL_TYPE];
    if (!urlString) {
        return NO;
    }
    NSMutableDictionary* paras = [NSMutableDictionary dictionaryWithDictionary:arg];
    [paras removeObjectForKey:URL_TYPE];
    
    urlString = [NSString stringWithFormat:@"http://%@/%@/%@.json", serv_ip, ADDR_DIR, urlString];
    NSString* optimestr = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    urlString = format(@"%@?accessToken=%@&operationTime=%@", urlString, UGET(U_TOKEN), optimestr);
    paras[@"accessToken"] = UGET(U_TOKEN);
    paras[@"operationTime"] = optimestr;
    
    
    MKNetworkOperation *op = [self operationWithURLString:urlString params:paras httpMethod:@"POST"];
    op.showLoading = isShowLoading;
    
    NSLog(@"HTTP-POST:%@", op.url);
    [op onCompletion:^(MKNetworkOperation *operation) {
        [self onCompletion:operation onSuccess:succ onFailed:fail];
    } onFailed:^(MKNetworkOperation *operation) {
        [self onFailed:operation onFailed:fail];
    }onTimeout:^(MKNetworkOperation *operation) {
        [self onTimeOut:operation onTimeout:timeout];
    }];
    [self enqueueOperation:op];
    
    return YES;
}


- (BOOL)checkNetwork
{
    if (!NET_SUPPORT) {
        return NO;
    }

    
    //获取当前网络状态
    
    CoreNetWorkStatus currentStatus = [CoreStatus currentNetWorkStatus];

    if (currentStatus != CoreNetWorkStatusNone) {//有网络状态
        
        if (internetStatus == 0) {
            [self checkInternetConnect];
        }
        return YES;
        
    } else {
        
        return NO;
    }

    
    return YES;
}

- (void)checkInternetConnect
{
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:CHECK_CONNECTIONT_IP]
                                             cachePolicy:0
                                         timeoutInterval:5];
    NSHTTPURLResponse* response = nil;
    NSError* error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 200) {
        internetStatus = 2;
    } else {
        internetStatus = 1;
    }
}

- (void)onCompletion:(MKNetworkOperation *)operation onSuccess:(RespBlock)succ onFailed:(RespBlock)fail
{
    if ( operation.showLoading ) {
        hideLoading();
    }
    
    int statusCode = [operation HTTPStatusCode];
    if (statusCode == 404 || statusCode != 200) {
        if (fail) fail(nil);
        return;
    }
    
    NSString *respStr = [operation responseString];
    if (respStr == nil) {
        operation.stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        respStr = [operation responseString];
    }
    if ([respStr isEqualToString:@""] || [respStr isEqualToString:@"null"]) {
        if (fail) fail(nil);
        return;
    }
    
    id rsDict = [respStr JSONValue];
    
    if (!rsDict || [rsDict isEqual:[NSNull null]] || [rsDict isEqual:@""]
        || ![rsDict isKindOfClass:[NSDictionary class]]) {
        if (fail) fail(nil);
        return;
    }
    
    NSString* reqResult = [[rsDict objectForKey:RESP_STATUS] uppercaseString];
    reqResult = [reqResult stringByReplacingOccurrencesOfString:@"0" withString:@""];
    if (reqResult.length > 0) {
        NSLog(@"failed: [%@] %@", reqResult, rsDict[@"error"]);
        if (fail) {
            fail(rsDict);
        } else {
            showAlert(rsDict[@"error"]);
        }
        return;
    }
    
    succ(rsDict);
}

- (void)onFailed:(MKNetworkOperation *)operation onFailed:(RespBlock)fail
{
    hideLoading();
    if (fail) {
        fail([NSNumber numberWithInt:[operation HTTPStatusCode]]);
    } else {
        DLLog(@"err:[%d]%@", [operation HTTPStatusCode], operation.url);
    }
}

- (void)onTimeOut:(MKNetworkOperation *)operation onTimeout:(RespBlock)resTimeout
{
    hideLoading();
    if (resTimeout) {
        resTimeout([NSNumber numberWithInt:[operation HTTPStatusCode]]);
    } else {
        DLLog(@"err:[timeout]%@", operation.url);
    }
}

- (BOOL)postRequest:(NSDictionary*) arg
{
    return YES;
}


- (BOOL)downFileFrom:(NSDictionary*)arg onProgress:(ProgBock)prog onSuccess:(RespBlock)succ
            onFailed:(RespBlock)fail onTimeout:(RespBlock)timeout
{
    if ( ![self checkNetwork] ){
        return NO;
    }
    
    if ( [arg objectForKey:SHOW_LOADING] ) {
        showLoading(@"提交中...");
    }
    
    NSString* remoteURL = [arg objectForKey:URL_TYPE];
    NSString* filePath = [arg objectForKey:FILE_PATH];
    if (!remoteURL || !filePath) {
        return NO;
    }
    
    MKNetworkOperation *op = [self operationWithURLString:remoteURL];
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath
                                                            append:YES]];
    NSLog(@"HTTP-DOWN:%@", remoteURL);
    [op onDownloadProgressChanged:^(double progress) {
        prog(progress);
    }];
    [op onCompletion:^(MKNetworkOperation *operation) {
        hideLoading();
        succ(nil);
    } onFailed:^(MKNetworkOperation *operation) {
        [self onFailed:operation onFailed:nil];
    }onTimeout:^(MKNetworkOperation *operation) {
        [self onTimeOut:operation onTimeout:nil];
    }];
    
    [self enqueueOperation:op];
    
    return YES;
}

- (BOOL)upData:(NSDictionary*)arg onProgress:(ProgBock)prog onSuccess:(RespBlock)succ
      onFailed:(RespBlock)fail onTimeout:(RespBlock)timeout
{
    if ( ![self checkNetwork] ){
        return NO;
    }
    
    NSString* urlString = [arg objectForKey:URL_TYPE];
    if (!urlString) {
        return NO;
    }
    BOOL isPushServ = ([urlString rangeOfString:@"pushService"].location != NSNotFound);
    if (isPushServ) {
        urlString = [NSString stringWithFormat:@"http://%@/%@.json", serv_ip, urlString];
    } else {
        urlString = [NSString stringWithFormat:@"http://%@/%@/%@.json", serv_ip, ADDR_DIR, urlString];
    }
    
    NSMutableDictionary* paras = [NSMutableDictionary dictionaryWithDictionary:arg];
    [paras removeObjectForKey:URL_TYPE];
    
    paras[@"operationTime"] = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    NSString* tokenName = (isPushServ ? @"userToken" : @"accessToken");
    NSString* tokenValue = UGET(U_TOKEN);
    if (tokenValue == nil) tokenValue = UGET(ASSI_IMSI);
    if (tokenValue != nil) {
        paras[tokenName] = tokenValue;
    }
#if defined(V_TELECOM)
    paras[@"appCode"] = @"10000";
#elif defined(V_ASSISTOR)
    paras[@"appCode"] = @"10002";
#endif
    
    
    MKNetworkOperation *op = [self operationWithURLString:urlString params:paras httpMethod:@"POST"];
    if (paras[@"content"] != nil)
        [op addFile:paras[@"content"] forKey:@"log"];
    if (paras[@"png_file"] != nil) {
        NSString* imgfile = paras[@"png_file"];
        NSData* data;
        UIImage *image=[UIImage imageWithContentsOfFile:imgfile];
        if (UIImagePNGRepresentation(image)) {
            data = UIImagePNGRepresentation(image);
        }else {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        
        [op addFile:imgfile forKey:@"media"];
        [op addHeaders:@{@"Content-Type":@"application/octet-stream"}];
    }
    
    [op onUploadProgressChanged:^(double progress) {
        prog(progress);
    }];
    [op onCompletion:^(MKNetworkOperation *operation) {
        [self onCompletion:operation onSuccess:succ onFailed:fail];
    } onFailed:^(MKNetworkOperation *operation) {
        [self onFailed:operation onFailed:fail];
    }onTimeout:^(MKNetworkOperation *operation) {
        [self onTimeOut:operation onTimeout:timeout];
    }];
    
    [self enqueueOperation:op];
    return YES;
}


-(BOOL)httpGETAFNNetworking:(NSDictionary*)arg onSuccess:(RespBlock)succ onFailed:(RespBlock)fail onTimeout:(RespBlock)timeout{
    //网络类型
    BOOL internetConnect = [self methodOfConnection];
    if (!internetConnect) {
        [self showMessage:@"当前无网络连接！"];
    }

    //位置信息
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    //系统版本
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSMutableString *mutablStr = [NSMutableString string];
    [mutablStr appendString:systemName];
    [mutablStr appendString:systemVersion];
    USET(U_SYSTEMVERSION, mutablStr);
    //应用版本
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    USET(U_APPVERSION, appVersion);
    //硬件型号
    NSString *deviceVersion = [self getCurrentDeviceModel];
    USET(U_DEVICEVERSION, deviceVersion);
    //运营商
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *carrieroperator = carrier.carrierName;
    if ([carrieroperator isEqualToString:@"中国移动"]) {
        carrieroperator = @"ChinaMobile";
    }else if ([carrieroperator isEqualToString:@"中国联通"]){
        carrieroperator = @"ChinaUnicom";
    }else if ([carrieroperator isEqualToString:@"中国电信"]){
        carrieroperator = @"ChinaTelecom";
    }else{
        carrieroperator = @"Others";
    }
    //UUID
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString* urlString = [arg objectForKey:URL_TYPE];
    if (!urlString) {
        return NO;
    }
    BOOL isPushServ = ([urlString rangeOfString:@"pushService"].location != NSNotFound);
    if (isPushServ) {
        urlString = [NSString stringWithFormat:@"http://%@/%@.json", serv_ip, urlString];
    } else {
        urlString = [NSString stringWithFormat:@"http://%@/%@/%@.json", serv_ip, ADDR_DIR, urlString];
    }
    
    NSMutableDictionary* paras = [NSMutableDictionary dictionaryWithDictionary:arg];
    [paras removeObjectForKey:URL_TYPE];
    
    paras[@"operationTime"] = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    NSString* tokenName = (isPushServ ? @"userToken" : @"accessToken");
    NSString* tokenValue = UGET(U_TOKEN);
    
    if (tokenValue != nil) {
        paras[tokenName] = tokenValue;
    }
    
    paras[@"network"] = UGET(U_CONNECTIONWAY);
    if (UGET(USERLOCATION_LATITUDE)) {
        paras[@"smy"] = UGET(USERLOCATION_LATITUDE);
    }
    if (UGET(USERLOCATION_LONGITUDE)) {
        paras[@"smx"] = UGET(USERLOCATION_LONGITUDE);
    }
    
    paras[@"appVersion"] = UGET(U_APPVERSION);
    paras[@"deviceType"] = @1;
    paras[@"osVersion"] = UGET(U_SYSTEMVERSION);
    paras[@"deviceMode"] = UGET(U_DEVICEVERSION);
    paras[@"carrieroperator"] = carrieroperator;
    paras[@"uuid"] = uuid;
    
#if defined(V_TELECOM)
    paras[@"appCode"] = @"10000";
#elif defined(V_ASSISTOR)
    paras[@"appCode"] = @"10002";
#endif
    
    [self.manager GET:urlString parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succ(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];

    
    [_locService stopUserLocationService];
    
    
    return YES;
}
-(BOOL)httpPOSTAFNNetworking:(NSDictionary*)arg onSuccess:(RespBlock)succ onFailed:(RespBlock)fail onTimeout:(RespBlock)timeout{
    if ( ![self checkNetwork] ){
        return NO;
    }
    BOOL internetConnect = [self methodOfConnection];
    if (!internetConnect) {
        [self showMessage:@"当前无网络连接！"];
    }

    
    NSString* urlString = [arg objectForKey:URL_TYPE];
    if (!urlString) {
        return NO;
    }
    NSMutableDictionary* paras = [NSMutableDictionary dictionaryWithDictionary:arg];
    [paras removeObjectForKey:URL_TYPE];
    
    urlString = [NSString stringWithFormat:@"http://%@/%@/%@.json", serv_ip, ADDR_DIR, urlString];
    NSString* optimestr = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    urlString = format(@"%@?accessToken=%@&operationTime=%@", urlString, UGET(U_TOKEN), optimestr);
//    paras[@"accessToken"] = UGET(U_TOKEN);
//    paras[@"operationTime"] = optimestr;
    
    [self.manager POST:urlString parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succ(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];

    return YES;
}
-(void)showMessage:(NSString *)message{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:view animated:YES];
    //弹出框的类型
    hud.mode = HWBProgressHUDModeText;
    //弹出框上的文字
    hud.detailsLabelText = message;
    //弹出框的动画效果及时间
    [hud showAnimated:YES whileExecutingBlock:^{
        //执行请求，完成
        sleep(2);
    } completionBlock:^{
        //完成后如何操作，让弹出框消失掉
        [hud removeFromSuperview];
    }];
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////


BOOL httpGET1(NSDictionary* arg, RespBlock succ)
{
    return httpGET3(arg, succ, NULL, NULL);
}

BOOL httpGET2(NSDictionary* arg, RespBlock succ, RespBlock fail)
{
    return httpGET3(arg, succ, fail, NULL);
}

BOOL httpGET3(NSDictionary* arg, RespBlock succ, RespBlock fail, RespBlock timeout)
{
    return [[NetService shared] httpGet:arg onSuccess:succ onFailed:fail onTimeout:timeout];
}
BOOL httpGETAFN(NSDictionary* arg, RespBlock succ, RespBlock fail, RespBlock timeout){
    return [[NetService shared] httpGETAFNNetworking:arg onSuccess:succ onFailed:fail onTimeout:timeout] ;
}
BOOL httpPOSTAFN(NSDictionary* arg, RespBlock succ, RespBlock fail, RespBlock timeout) {
    return [[NetService shared] httpPOSTAFNNetworking:arg onSuccess:succ onFailed:fail onTimeout:timeout];
}
BOOL httpPOST(NSDictionary* arg, RespBlock succ, RespBlock fail)
{
    return httpPOST4(arg, succ, fail, NULL);
}

BOOL httpPOST4(NSDictionary* arg, RespBlock succ, RespBlock fail, RespBlock timeout)
{
    return [[NetService shared] httpPostRequest:arg onSuccess:succ onFailed:fail onTimeout:timeout];
}

BOOL httpGET1noPara(NSString* url, RespBlock succ)
{
    NSDictionary* arg = [NSDictionary dictionaryWithObjectsAndKeys:url, URL_TYPE, nil];
    return httpGET1(arg, succ);
}

BOOL httpPOST1(NSDictionary* arg, RespBlock succ)
{
    return httpPOST2(arg, succ, NULL);
}

BOOL httpPOST2(NSDictionary* arg, RespBlock succ, RespBlock fail)
{
    return httpPOST3(arg, succ, fail, NULL);
}

BOOL httpPOST3(NSDictionary* arg, RespBlock succ, RespBlock fail, RespBlock timeout)
{
    return [[NetService shared] httpPost:arg onSuccess:succ onFailed:fail onTimeout:timeout];
}

BOOL httpDown1(NSDictionary* arg, ProgBock prog, RespBlock succ)
{
    return httpDown2(arg, prog, succ, nil);
}

BOOL httpDown2(NSDictionary* arg, ProgBock prog, RespBlock succ, RespBlock fail)
{
    return httpDown3(arg, prog, succ, fail, nil);
}

BOOL httpDown3(NSDictionary* arg, ProgBock prog, RespBlock succ, RespBlock fail, RespBlock timeout)
{
    return [[NetService shared] downFileFrom:arg onProgress:prog onSuccess:succ onFailed:fail onTimeout:timeout];
}

BOOL httpUp1(NSDictionary* arg, ProgBock prog, RespBlock succ)
{
    return httpUp2(arg, prog, succ, nil);
}

BOOL httpUp2(NSDictionary* arg, ProgBock prog, RespBlock succ, RespBlock fail)
{
    return httpUp3(arg, prog, succ, fail, nil);
}

BOOL httpUp3(NSDictionary* arg, ProgBock prog, RespBlock succ, RespBlock fail, RespBlock timeout)
{
    return [[NetService shared] upData:arg onProgress:prog onSuccess:succ onFailed:fail onTimeout:timeout];
}



BOOL checkNetwork(void)
{
    return [[NetService shared] checkNetwork];
}

BOOL isReachableViaWiFi(void)
{
    return [[Reachability reachabilityForInternetConnection] isReachableViaWiFi];
}

BOOL isReachableViaWWAN(void)
{
    return [[Reachability reachabilityForInternetConnection] isReachableViaWWAN];
}
