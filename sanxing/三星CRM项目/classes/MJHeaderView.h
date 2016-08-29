
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYFGroup, MJHeaderView;


@protocol MJHeaderViewDelegate <NSObject>
@optional
- (void)headerViewDidClickedNameView:(MJHeaderView *)headerView;
@end

@interface MJHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) ZYFGroup *group;

@property (nonatomic, weak) id<MJHeaderViewDelegate> delegate;

@end
