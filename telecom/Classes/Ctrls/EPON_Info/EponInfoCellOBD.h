//
//  EponInfoCell.h
//  telecom
//
//  Created by liuyong on 15/10/20.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EponInfoModelOBD.h"

@protocol EponInfoCellOBDDelegate <NSObject>

- (void)showUpperSetsInfoOfGes:(UITapGestureRecognizer *)ges;
- (void)showBottomSetsInfoOfGes:(UITapGestureRecognizer *)ges;
- (void)hRefToShowOBDPanelOf:(NSString *)cableName;
@end

@interface EponInfoCellOBD : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel     *info_1;
@property (strong, nonatomic) IBOutlet UILabel     *info_2;
@property (strong, nonatomic) IBOutlet UILabel     *info_3;
@property (strong, nonatomic) IBOutlet UILabel     *info_4;
@property (strong, nonatomic) IBOutlet UILabel     *info_5;
@property (strong, nonatomic) IBOutlet UILabel     *info_6;
@property (strong, nonatomic) IBOutlet UILabel     *info_7;
@property (strong, nonatomic) IBOutlet UILabel     *info_8;
@property (strong, nonatomic) IBOutlet UILabel     *info_9;
@property (strong, nonatomic) IBOutlet UILabel     *info_10;
@property (strong, nonatomic) IBOutlet UIImageView *upperSet;
@property (strong, nonatomic) IBOutlet UIView      *bottomSet;
@property (strong, nonatomic) IBOutlet UILabel     *upperSetInfo;
@property (strong, nonatomic) IBOutlet UIImageView *bottomSetImage;
@property (strong, nonatomic) IBOutlet UILabel *bottomSetInfo;


- (void)configOBDCell:(EponInfoModelOBD *)model;

@property(nonatomic,weak)id <EponInfoCellOBDDelegate> delegate;
@end
