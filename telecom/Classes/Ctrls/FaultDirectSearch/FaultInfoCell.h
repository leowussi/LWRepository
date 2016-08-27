//
//  FaultInfoCell.h
//  telecom
//
//  Created by liuyong on 15/10/27.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaultInfoModel.h"

@protocol FaultInfoCellDelegate <NSObject>
- (void)showSharePersonInfoWith:(UITapGestureRecognizer *)ges;
@end

@interface FaultInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;
@property (strong, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *workTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *workStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sharePersonInfoImageView;

@property(nonatomic,weak)id <FaultInfoCellDelegate> delegate;
- (void)configFaultInfoCell:(FaultInfoModel *)model;
@end
