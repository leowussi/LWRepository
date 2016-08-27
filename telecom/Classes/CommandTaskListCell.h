//
//  CommandTaskListCell.h
//  telecom
//
//  Created by SD0025A on 16/5/11.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommandTaskListModel;
@interface CommandTaskListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
- (void)configModel:(CommandTaskListModel *)model;
@end
