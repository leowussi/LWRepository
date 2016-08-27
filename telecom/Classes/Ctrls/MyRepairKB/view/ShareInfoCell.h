//
//  ShareInfoCell.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareInfoModel.h"

@interface ShareInfoCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *infoTitle;
@property (retain, nonatomic) IBOutlet UILabel *sharePerson;
@property (retain, nonatomic) IBOutlet UILabel *shareDateAndTime;
@property (retain, nonatomic) IBOutlet UILabel *attachNum;

- (void)config:(ShareInfoModel *)model;

@end
