//
//  SelledPipelineInfoCell.h
//  telecom
//
//  Created by SD0025A on 16/5/20.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelledPinelineInfoModel;
@interface SelledPipelineInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (nonatomic,strong) SelledPinelineInfoModel *model;
- (void)comfigModel:(SelledPinelineInfoModel *)model;
@end
