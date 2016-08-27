//
//  ResultTableViewCell.h
//  telecom
//
//  Created by 郝威斌 on 15/5/29.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ResultTableViewCell;


@interface ResultTableViewCell : UITableViewCell

@property(strong,nonatomic)UIImageView *leftImgView;
@property(strong,nonatomic)UIButton *leftBtn;
@property(strong,nonatomic)UIImageView *rightImgView;
@property(strong,nonatomic)UILabel *titleLable;
@property(strong,nonatomic)UILabel *contentLable;

@end
