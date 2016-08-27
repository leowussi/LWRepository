//
//  YZChooseAlertView.h
//  AcceptanceApplication
//
//  Created by 锋 on 16/5/24.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZChooseAlertView : UIView

@property (nonatomic, copy) void(^respBlock) (NSInteger SelectedIndex,NSString *message);

@end


@interface YZPlaceholderTextView : UITextView

@property (nonatomic, assign) BOOL shouldDrawPlaceholder;

/*!
 * @brief 占位符文本,与UITextField的placeholder功能一致
 */
@property (nonatomic, strong) NSString *placeholder;

/*!
 * @brief 占位符文本颜色
 */
@property (nonatomic, strong) UIColor *placeholderTextColor;
@end