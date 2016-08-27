//
//  YZChooseView.h
//  ResourceChangeDetail
//
//  Created by 锋 on 16/5/3.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZChooseView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *heightArray;

@property (nonatomic, copy) void(^selectedCompletionBlock)(NSInteger selectedIndex);

- (instancetype)initWithFrame:(CGRect)frame tableViewHeight:(CGFloat)height;
+ (CGFloat)calculateTextheight:(NSString *)text withTextWidth:(CGFloat)width;
@end
