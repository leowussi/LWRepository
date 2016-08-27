//
//  DownTimer.m
//  telecom
//
//  Created by ZhongYun on 14-7-10.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "DownTimer.h"
#import "NSTimer+Blocks.h"

@interface DownTimer ()
{
    NSTimer* m_timer;
}
@end

@implementation DownTimer

- (void)dealloc
{
    FREE_TIMER(m_timer);
    [super dealloc];
}

- (void)launchTimer
{
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^{
        if (_second <= 0) {
            FREE_TIMER(m_timer);
            if (self.overBlock) {
                self.overBlock();
            }
        } else {
            _second--;
            if (self.secondBlock) {
                self.secondBlock();
            }
        }
    } repeats:YES]; //这个重复是每1秒进行一次状态更新;
    if (self.secondBlock) {
        self.secondBlock();
    }
}

- (void)start
{
    if (m_timer) return;
    _second = _totalSeconds;
    [self launchTimer];
}

- (void)stop
{
    if (!m_timer) return;
    FREE_TIMER(m_timer);
    _second = 0;
}

- (BOOL)isRunning
{
    return (m_timer != nil);
}

- (NSString *)secondStr
{
    if (_second <= 0)
        _second=0;
    NSInteger m = _second / 60;
    NSInteger s = _second % 60;
    return format(@"%02d:%02d", m, s);
}

- (void)startWithOldDate:(NSDate*)date
{
    if (m_timer) return;
    NSInteger speedSecond = ABS([date timeIntervalSinceNow]);
    _second = _totalSeconds - speedSecond;
    
    /* 由于倒计时结束后会再次获取服务器状态时间，如果早于服务器完成倒计时，则会再次启动定时器;
       为了避免这种情况，在计算剩余时间时，多计算1秒，目的是为了晚于服务器完成倒计时.*/
    _second += 1;
    [self launchTimer];
}

@end
