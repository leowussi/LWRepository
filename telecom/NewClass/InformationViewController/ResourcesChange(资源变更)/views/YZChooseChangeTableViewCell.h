//
//  YZChooseChangeTableViewCell.h
//  ResouceChanged
//
//  Created by 锋 on 16/5/3.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZIndexTextField;

@interface YZChooseChangeTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *label_title;
@property (nonatomic, strong) YZIndexTextField *textField_choose;
@property (nonatomic, strong) UIImageView *imageView_accessory;

@property (nonatomic, strong) UIControl *control_choose;

@end

@interface YZIndexTextField : UITextField

@property (nonatomic, strong) NSIndexPath *textFieldIndexPath;

@end
