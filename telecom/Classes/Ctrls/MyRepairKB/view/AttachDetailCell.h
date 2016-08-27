//
//  AttachDetailCell.h
//  telecom
//
//  Created by liuyong on 15/4/24.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttaFileDetailModel.h"

@interface AttachDetailCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *attachImage;
@property (retain, nonatomic) IBOutlet UILabel *imageName;
@property (retain, nonatomic) IBOutlet UILabel *uploadTime;
- (void)config:(AttaFileDetailModel *)model;
@end
