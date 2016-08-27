//
//  ResourceTableViewCell.h
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZJiaoZhengButtom;

@interface ResourceTableViewCell : UITableViewCell

@property(strong,nonatomic)UILabel *leftLable;
@property(strong,nonatomic)UILabel *leftLable1;
@property(strong,nonatomic)UILabel *leftLable2;
@property(strong,nonatomic)UILabel *leftLable3;
@property(strong,nonatomic)UILabel *leftLable4;

@property(strong,nonatomic)UILabel *jicaoLable;
@property(strong,nonatomic)UILabel *zicaoLable;
@property(strong,nonatomic)UILabel *ztLable;
@property(strong,nonatomic)UILabel *classLable;
@property(strong,nonatomic)UILabel *xinghaoLable;

//校正按钮
@property (nonatomic, strong) YZJiaoZhengButtom *jiaoZhengButton;

@end

@interface YZJiaoZhengButtom : UIButton

@property (nonatomic, strong) NSIndexPath *buttonIndexPath;

@end