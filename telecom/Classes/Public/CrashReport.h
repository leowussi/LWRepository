//
//  CrashReport.h
//  telecom
//
//  Created by ZhongYun on 14-7-31.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h> 

#define LOG_FILE_ENABLED    1

#if LOG_FILE_ENABLED
# define logMark(fmt, ...)     NSLog((@"\n%s \n%s (%d)\n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define logMark(...);
#endif

#define INIT_LOG_FILE       [[CrashReport shared] initLogfile]

typedef NSString*(^FlagBlock)();
@interface CrashReport : NSObject
+ (CrashReport*)shared;
- (void)initLogfile;
@property (nonatomic, copy)FlagBlock blocker;
@end



