//
//  CustomDatePickerView.h
//  telecom
//
//  Created by liuyong on 15/12/1.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDatePickerViewDelegate <NSObject>
- (void)deliverDateWith:(NSString *)date;
- (void)cancleBtnClick;
@end

@interface CustomDatePickerView : UIView
@property(nonatomic,weak)id <CustomDatePickerViewDelegate> delegate;
@end
