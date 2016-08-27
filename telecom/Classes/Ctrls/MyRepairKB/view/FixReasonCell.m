//
//  FixReasonCell.m
//  telecom
//
//  Created by liuyong on 15/8/18.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "FixReasonCell.h"

@implementation FixReasonCell

- (void)configWithModel:(FixReasonModel *)model
{
    self.fixReasonLabel.text = model.resultContent;
    self.fixReasonLabel.numberOfLines = 3;
    self.fixReasonLabel.clipsToBounds = YES;
}

@end
