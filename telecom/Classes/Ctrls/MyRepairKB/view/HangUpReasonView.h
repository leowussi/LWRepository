//
//  HangUpReasonView.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HangUpReasonViewDelegate <NSObject>

- (void)deliverHangUpReason:(NSString *)hangUpReason;

@end

@interface HangUpReasonView : UIView
@property(nonatomic,assign)id <HangUpReasonViewDelegate>delegate;

- (void)loadDateWithURL:(NSString *)urlString;
@end
