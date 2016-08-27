//
//  TemporyTableViewCell.h
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemporyTableViewCell : UITableViewCell

@property(strong,nonatomic)UILabel *taskContent;
@property(strong,nonatomic)UILabel *taskAddress;
@property(strong,nonatomic)UILabel *taskDate;
@property(strong,nonatomic)UILabel *taskPeople;

@property(strong,nonatomic)UIView *View;
@property(strong,nonatomic)UIView *View1;

@property(strong,nonatomic)UILabel *leftLable;
@property(strong,nonatomic)UILabel *leftLable1;
@property(strong,nonatomic)UILabel *leftLable2;
@property(strong,nonatomic)UILabel *leftLable3;

@end
