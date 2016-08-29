//
//  ZYFEditableCell.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/8.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYFEditableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
//yes，显示数字键盘
@property (nonatomic,assign,getter = isShowNumKeyboard) BOOL showNumKeyboard;

@end
