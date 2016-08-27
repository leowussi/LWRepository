//
//  ZhDetailTableViewCell.h
//  telecom
//
//  Created by 郝威斌 on 15/9/18.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectBtnDelegate <NSObject>

- (void)selectButt:(NSInteger)index;

@end

@interface ZhDetailTableViewCell : UITableViewCell

@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *contentLable;
@property(strong,nonatomic)UILabel *statusLable;
@property(strong,nonatomic)UIButton *button;
@property(strong,nonatomic)UIButton *selectBtn;
@property(strong,nonatomic)UIButton *selectBtn1;
@property(strong,nonatomic)UILabel *selectLable;
@property(strong,nonatomic)UILabel *selectLable1;
@property(strong,nonatomic)UIButton *dateBtn;
@property(strong,nonatomic)UIButton *dateBtn1;
@property(strong,nonatomic)UIButton *dateBtn2;
@property(strong,nonatomic)UIButton *upPhotoBtn;
@property(strong,nonatomic)UITextField *myTextField;
@property(nonatomic,strong)UILabel *remarkLabel;

@property(assign,nonatomic)id<selectBtnDelegate>delegate;
- (void)cellButt:(NSArray*)arr withInt:(NSInteger)index withFrame:(float)recY;


@end
