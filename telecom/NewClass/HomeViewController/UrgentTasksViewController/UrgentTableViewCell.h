//
//  UrgentTableViewCell.h
//  telecom
//
//  Created by 郝威斌 on 15/5/20.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UrgentTableViewCell : UITableViewCell

@property(strong,nonatomic)UILabel *titleLable;
@property(strong,nonatomic)UILabel *dateLable;
@property(strong,nonatomic)UILabel *contentLable;
@property(strong,nonatomic)UIView *leftView;

@end
