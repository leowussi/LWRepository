//
//  QzTimer.h
//  quanzhi
//
//  Created by ZhongYun on 14-3-2.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QzTimer : NSObject
+ (QzTimer*)shared;
- (void)start;
- (void)stop;

@property (nonatomic, assign)NSInteger initSecond;
@property (nonatomic, readonly)NSInteger currSecond;
@property (nonatomic, copy)void(^secondChangeBlock)();
@property (nonatomic, readonly)BOOL isRunning;
@end
