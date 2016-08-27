//
//  TaskDetailInRequestSupportDetailCell.h
//  telecom
//
//  Created by SD0025A on 16/6/16.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskDetailInRequestSupportDetail;
@interface TaskDetailInRequestSupportDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
- (void)configModel:(TaskDetailInRequestSupportDetail *)model;
@end
