//
//  FixsViewController.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"


//forward declare
@class IFlyDataUploader;
@class IFlyRecognizerView;

@interface FixsViewController : SXABaseViewController

//带界面的听写识别对象
@property (nonatomic,strong) IFlyRecognizerView * iflyRecognizerView;
//数据上传对象
@property (nonatomic, strong) IFlyDataUploader * uploader;

@property (nonatomic,copy)NSString *workNum;
@property (nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *spec;

@end

@interface ZYPlaceholderTextView : UITextView

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
