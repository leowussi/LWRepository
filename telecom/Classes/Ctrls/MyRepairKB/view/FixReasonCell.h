//
//  FixReasonCell.h
//  telecom
//
//  Created by liuyong on 15/8/18.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixReasonModel.h"

@interface FixReasonCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *fixReasonLabel;

- (void)configWithModel:(FixReasonModel *)model;
@end
