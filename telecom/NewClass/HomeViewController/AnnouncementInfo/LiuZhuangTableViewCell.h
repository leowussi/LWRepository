//
//  LiuZhuangTableViewCell.h
//  telecom
//
//  Created by Sundear on 16/1/18.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiuZhuangTableViewCell : UITableViewCell

+(instancetype)tabcell:(UITableView *)tableview;
@property(nonatomic,strong)NSDictionary *model;
@end
