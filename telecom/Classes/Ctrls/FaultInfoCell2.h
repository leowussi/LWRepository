//
//  FaultInfoCell2.h
//  telecom
//
//  Created by liuyong on 15/11/6.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaultInfoCell2Delegate <NSObject>
- (void)showSharePersonInfoWithFaultInfoCell2:(UITapGestureRecognizer *)ges;
@end

@interface FaultInfoCell2 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *specInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptTimeInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftTimeInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *descInfoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sharePersonInfoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;
@property(nonatomic,weak)id <FaultInfoCell2Delegate> delegate;
- (void)configFaultInfoCell:(NSDictionary *)dict;
@end
