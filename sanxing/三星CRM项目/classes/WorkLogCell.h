//
//  WorkLogCell.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/15.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "BusinessCell.h"

@interface WorkLogCell : BusinessCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end
