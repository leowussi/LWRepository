//
//  MyResourceHeaderView.h
//  telecom
//
//  Created by 郝威斌 on 15/7/27.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyResourceHeaderView : UIView

@property (nonatomic,strong)UIButton *bgBtn;
@property (nonatomic,strong)UILabel *label1;
@property (nonatomic,strong)UILabel *label2;
@property (nonatomic,strong)UILabel *label3;

@property (nonatomic, strong) UIButton *jiaoZhengButton;

- (id)initWithFrame:(CGRect)aRect;

@end
