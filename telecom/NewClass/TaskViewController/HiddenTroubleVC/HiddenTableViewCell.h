//
//  HiddenTableViewCell.h
//  telecom
//
//  Created by 郝威斌 on 15/8/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HiddenTableViewCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *dict;
+(instancetype)table:(UITableView *)tableview;
@end
