//
//  DatePickerCustomView.h
//  telecom
//
//  Created by liuyong on 16/1/21.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerCustomViewDelegate <NSObject>
- (void)deliverDatePickerResult:(NSString *)dateString indexPath:(NSIndexPath *)indexPath btn:(NSInteger)btnTag;
- (void)cancle;
@end

@interface DatePickerCustomView : UIView
@property(nonatomic,weak)id <DatePickerCustomViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(NSString *)type indexPath:(NSIndexPath *)indexPath btnTag:(NSInteger)tag;
@end
