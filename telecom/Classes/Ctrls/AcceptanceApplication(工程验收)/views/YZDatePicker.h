//
//  YZDatePicker.h
//  telecom
//
//  Created by 锋 on 16/5/31.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//
#define BTN_NO  0
#define BTN_OK  1
#import <UIKit/UIKit.h>

typedef void(^AlertBoxBlock)(NSString *dateStr);
@interface YZDatePicker : UIView

@property(nonatomic,strong)AlertBoxBlock respBlock;

- (void)scrollToCurrentTime;

@end
