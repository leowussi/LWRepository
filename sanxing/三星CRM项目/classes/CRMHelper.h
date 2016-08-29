//
//  CRMHelper.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/17.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

/**
 *  ********* url *************
 */

//#define kBaseUrl @"http://100.100.100.68:61112"
//#define kBaseUrl @"http://sxcrm.auxgroup.com:6065"
#define kBaseUrl @"http://sxcrm.auxgroup.com:6066"


/**
 *  ********* url *************
 */
//NSLog
#ifdef DEBUG
#define ZYFLog(...) NSLog(__VA_ARGS__)
#else
#define ZYFLog(...)
#endif

//当前屏幕的宽度和高度
#define kSystemScreenWidth [UIScreen mainScreen].bounds.size.width
#define kSystemScreenHeight [UIScreen mainScreen].bounds.size.height

#define ZYFUserDefaults [NSUserDefaults standardUserDefaults]

#define ZYFKeyWindow [[UIApplication sharedApplication].windows lastObject]

#define rgb(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0  blue:(b)/255.0 alpha:1.0]
#define rgba(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0  blue:(b)/255.0 alpha:(a)]

/**
 *********************  NSUserDefault存储 **************************
 */

//存储账号和密码
#define ZYFAccountKey @"account"
#define ZYFPwdKey @"pwd"

#define ZYFRmbPwdKey @"rmbPwd"
#define ZYFAutoLoginKey @"auto_login"

#define ZYFDeviceToken @"deviceToken"


//签到成功
#define ZYFSignInSucess @"signinSucess"

//签退成功
#define ZYFSignOutSucess @"signinSucess"
//登陆成功
#define ZYFLoginSucess @"loginSucess"
//是否可更新
#define ZYFIsVaildUpdate @"ZYFIsVaildUpdate"


/**
 ********************* NSUserDefault存储 **********************************************
 */

/**
 *   ******************************* 通知  *******************************
 */
#define ZYFLoginSucessNotify @"loginSucessNotiry"
#define ZYFMessageReceiveNotify  @"messageReceiveNotify"
/**
 *   ******************************* 通知  *******************************
 */

//运维派工，当前已经选择的”问题大类“类型id
#define ZYFProblemId @"problemId"


@interface CRMHelper : NSObject

+ (NSString*) createFilePathWithFileName:(NSString*)fileName;
+ (BOOL) isEnableNetWork;
//带有中文的url转换为合法的url
+ (NSString *)translateRegularUrlWithString:(NSString *)chineseString;


@end
