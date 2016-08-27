//
//  EponInfoCellONU.h
//  telecom
//
//  Created by liuyong on 15/10/21.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EponInfoModelONU.h"
@protocol EponInfoCellONUDelegate <NSObject>
- (void)showUpperSetsInfoOfGes:(UITapGestureRecognizer *)ges;
- (void)showBottomSetsInfoOfGes:(UITapGestureRecognizer *)ges;
@end

@interface EponInfoCellONU : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *info_1;
@property (strong, nonatomic) IBOutlet UILabel *info_2;
@property (strong, nonatomic) IBOutlet UILabel *info_3;
@property (strong, nonatomic) IBOutlet UILabel *info_4;
@property (strong, nonatomic) IBOutlet UILabel *info_5;
@property (strong, nonatomic) IBOutlet UILabel *info_6;
@property (strong, nonatomic) IBOutlet UILabel *info_7;
@property (strong, nonatomic) IBOutlet UILabel *info_8;
@property (strong, nonatomic) IBOutlet UIImageView *upperSetImage;
@property (strong, nonatomic) IBOutlet UILabel *upperSetCode;
@property (strong, nonatomic) IBOutlet UIView *bottomSetList;
@property (strong, nonatomic) IBOutlet UIImageView *bottomSetImage;
@property (strong, nonatomic) IBOutlet UILabel *bottomSetInfo;
@property (strong, nonatomic) IBOutlet UIView *centerView;

@property(nonatomic,weak)id <EponInfoCellONUDelegate> delegate;
- (void)configONUCell:(EponInfoModelONU *)model;
@end
