//
//  TemporaryHeadView.h
//  telecom
//
//  Created by 郝威斌 on 15/7/27.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemporaryHeadView : UIView

@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)UIButton *bgBtn;
@property (nonatomic,strong)UILabel *label1;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,assign)BOOL open;
- (id)initWithFrame:(CGRect)aRect;

@end
