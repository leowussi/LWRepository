//
//  TaskDetailInRequestSupportDetailCell.m
//  telecom
//
//  Created by SD0025A on 16/6/16.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "TaskDetailInRequestSupportDetailCell.h"
#import "TaskDetailInRequestSupportDetail.h"

@implementation TaskDetailInRequestSupportDetailCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configModel:(TaskDetailInRequestSupportDetail *)model
{
    self.label1.text = model.executivePerson;
    self.label2.text = model.executiveTime;
    self.label3.text = model.status;
    self.label4.text = model.remark;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
