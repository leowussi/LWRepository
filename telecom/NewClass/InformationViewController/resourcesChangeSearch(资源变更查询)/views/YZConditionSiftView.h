//
//  YZConditionSiftView.h
//  AlertView
//
//  Created by 锋 on 16/5/10.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZConditionSiftView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *title_desc;
@property (nonatomic, strong) NSMutableArray *selectedIndexArray;
@property (nonatomic, assign) BOOL isSingleSelect;
//点击确定按钮后的回调block
@property (nonatomic, copy) void(^completionBlock)(NSString *string);

- (instancetype)initWithFrame:(CGRect)frame tableViewFrame:(CGRect)tFrame dataArray:(NSArray *)dataArray title:(NSString *)title;

//计算文字的高度
- (CGFloat)calculateTextHeight:(NSString *)text width:(CGFloat)width;

@end

@interface YZConditionSiftTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageView_accessory;
@property (nonatomic, strong) UILabel *label_desc;
@property (nonatomic, assign) BOOL isSelected;


@end