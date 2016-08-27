//
//  CrashReport.m
//  telecom
//
//  Created by ZhongYun on 14-7-31.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "CrashReport.h"
#include <signal.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import "FTPHelper.h"
#import "UploadFile.h"
#import "JSON.h"

static int _signals[] = {
    SIGABRT,
    SIGBUS,
    SIGFPE,
    SIGILL,
    SIGSEGV,
    SIGTRAP,
    SIGTERM,
    SIGKILL,
    SIGQUIT,
    SIGEMT,
    SIGSYS,
    SIGPIPE,
    SIGALRM,
    SIGXFSZ,
};
static int _signalNum = sizeof(_signals) / sizeof(_signals[0]);
void exceptionHandler(NSException *exception);
void stacktrace(int sig, siginfo_t *info, void *context);


@interface CrashReport ()<FTPHelperDelegate>
- (void)initExceptionTrace;
@end

@implementation CrashReport

+ (CrashReport*)shared
{
    static CrashReport* instance = nil;
    if (instance == nil) {
        instance = [[CrashReport alloc] init];
        [instance initExceptionTrace];
        [instance initLogfile];
    }
    return instance;
}

- (void)initExceptionTrace
{
#if LOG_FILE_ENABLED
    struct sigaction mySigAction;
    mySigAction.sa_sigaction = stacktrace;
    mySigAction.sa_flags = SA_SIGINFO;
    sigemptyset(&mySigAction.sa_mask);
    for (int i = 0; i < _signalNum; ++i) {
        sigaction(_signals[i], &mySigAction, NULL);
    }
    NSSetUncaughtExceptionHandler(&exceptionHandler);
#endif
}

- (void)initLogfile
{
    if (!self.blocker || self.blocker().length==0) {
        return;
    }
    
#if LOG_FILE_ENABLED
    [self uploadLogfile];
    [self redirectConsole];
#endif
    [self logBaseInfo];
}

- (void)redirectConsole
{
    NSString* strFileFlag = self.blocker();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSString* strTime = date2str([NSDate date], @"yyyyMMddHHmmss");
    NSString* fileName = format(@"%@_%@_%@.log", strFileFlag, strTime, appName);
    
    NSString *logFullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([logFullPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
    USET(U_LOG, fileName);
}

- (void)uploadLogfile
{
    if (UGET(U_LOG) == nil){
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logFullPath = [documentsDirectory stringByAppendingPathComponent:UGET(U_LOG)];
    if (![[NSFileManager defaultManager] fileExistsAtPath:logFullPath]) {
        return;
    }
    
    UploadFile* httpup = [[UploadFile alloc] init];
    httpup.respBlocker = ^(int t, id v) {
        [self httpUploadFileResp:t Value:v];
    };

    [httpup send:@{URL_TYPE:NW_UploadErrorLog,
                   FILE_PATH:logFullPath,
                   @"content":format(@"%@.log", date2str([NSDate date], @"yyyyMMddHHmmss")),
                   @"appVersion":[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                   @"osVersion":[[UIDevice currentDevice] systemVersion]}];
    [httpup release];
}

- (void)httpUploadFileResp:(int)t Value:(id)v
{
    if (t == RESP_WILL_SEND) {
        showLoading(@"请稍等");
    } else if (t == RESP_PROGRESS) {
        ;
    } else if (t == RESP_ERROR) {
        hideLoading();
    } else if (t == RESP_FAILED) {
        hideLoading();
    } else if (t == RESP_TIMEOUT) {
        hideLoading();
    } else if (t == RESP_SUCCESS) {
        hideLoading();
        NSDictionary* rsDict = [v JSONValue];
        NSLog(@"%@", rsDict);
    }
}


- (void)deleteOldLogfile
{
    if (UGET(U_LOG) == nil){
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logFullPath = [documentsDirectory stringByAppendingPathComponent:UGET(U_LOG)];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logFullPath]) {
        return;
    }
    
    NSError *err;
    if (![fileManager removeItemAtPath:logFullPath error:&err]) {
        NSLog(@"delete log file err:%@", err);
    }
}

- (void)logBaseInfo
{
    NSString* strFileFlag = self.blocker();
    NSString* modelName = [self getDeviceModelName:[self deviceModel]];
    NSString* newType = @"UNKNOWN";
    if (isReachableViaWiFi()) newType = @"WIFI";
    if (isReachableViaWWAN()) newType = @"3G/GPRS";
    
    NSLog(@"**********init log file header **********");
    NSLog(@"UserFlag:%@", strFileFlag);
    NSLog(@"Device Name:%@", [UIDevice currentDevice].name);
    NSLog(@"Device model:%@", [UIDevice currentDevice].model);
    NSLog(@"Device modelName:%@", modelName);
    NSLog(@"Device localizedModel:%@", [UIDevice currentDevice].localizedModel);
    NSLog(@"Device systemName:%@", [UIDevice currentDevice].systemName);
    NSLog(@"Device systemVersion:%@", [UIDevice currentDevice].systemVersion);
    NSLog(@"App Name:%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]);
    NSLog(@"App Version:%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
    NSLog(@"App Build:%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]);
    NSLog(@"Network type:%@", newType);
    NSLog(@"**********init log file trace **********");
}

- (NSString *)deviceModel
{
    NSString *deviceModel = nil;
    char buffer[32];
    size_t length = sizeof(buffer);
    if (sysctlbyname("hw.machine", &buffer, &length, NULL, 0) == 0) {
        deviceModel = [[NSString alloc] initWithCString:buffer encoding:NSASCIIStringEncoding];
    }
    
    return [deviceModel autorelease];
}

- (NSString*)getDeviceModelName:(NSString*)platform
{
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad-3G (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad-3G (4G)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad-3G (4G)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"Phone 5 GSM";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 CDMA";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod 5";
    return format(@"unknown(%@)", platform);
}

@end

void exceptionHandler(NSException *exception) {
    NSLog(@"Trace exception: %@", exception);
    NSLog(@"Trace Stack:\r\n%@", [exception callStackSymbols]);
}

void stacktrace(int sig, siginfo_t *info, void *context)
{
    NSMutableString * mstr = [[NSMutableString alloc] initWithCapacity:0];
    [mstr appendString:@"Stack:\n"];
    
    void* callstack[128];
    int i, frameCount = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frameCount);
    for (i = 0; i < frameCount; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    NSLog(@"Trace Signal:\r\n%@", mstr);
}

