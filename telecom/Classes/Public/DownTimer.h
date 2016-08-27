//
//  DownTimer.h
//  telecom
//
//  Created by ZhongYun on 14-7-10.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownTimer : NSObject
- (void)start;
- (void)stop;
- (void)startWithOldDate:(NSDate*)date;

@property (nonatomic, assign)NSInteger totalSeconds;
@property (nonatomic, readonly)NSInteger second;
@property (nonatomic, readonly)NSString* secondStr;
@property (nonatomic, readonly)BOOL isRunning;

@property (nonatomic, copy)void(^secondBlock)();
@property (nonatomic, copy)void(^overBlock)();
@end
