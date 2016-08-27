//
//  QzTimer.m
//  quanzhi
//
//  Created by ZhongYun on 14-3-2.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "QzTimer.h"
#import "NSTimer+Blocks.h"

@interface QzTimer ()
{
    NSTimer* m_timer;
}
@end

@implementation QzTimer
+ (QzTimer*)shared
{
    static QzTimer* instance = nil;
    if (!instance) {
        instance = [[QzTimer alloc] init];
    }
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        m_timer = nil;
    }
    return self;
}

- (void)start
{
    if (m_timer) return;
    _currSecond = self.initSecond;
    if (self.secondChangeBlock) {
        self.secondChangeBlock();
    }
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^{
        if (_currSecond == 0) {
            [m_timer invalidate];
            m_timer = nil;
        } else {
            _currSecond--;
            if (self.secondChangeBlock) {
                self.secondChangeBlock();
            }
        }
        
    } repeats:YES]; //这个重复是每1秒进行一次状态更新;
}

- (void)stop
{
    if (!m_timer) return;
    [m_timer invalidate];
    m_timer = nil;
    _currSecond = 0;
}

- (BOOL)isRunning
{
    return (m_timer != nil);
}

@end
