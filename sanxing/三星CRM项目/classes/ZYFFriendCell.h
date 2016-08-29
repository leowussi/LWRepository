//
//  MJFriendCell.h
//  03-QQ好友列表
//
//  Created by apple on 14-4-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJFriend;

@interface MJFriendCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
// friend是C++的关键字,不能用friend作为属性名
@property (nonatomic, strong) MJFriend *friendData;
@end
