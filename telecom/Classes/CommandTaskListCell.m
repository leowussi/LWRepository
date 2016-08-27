//
//  CommandTaskListCell.m
//  telecom
//
//  Created by SD0025A on 16/5/11.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "CommandTaskListCell.h"
#import "CommandTaskListModel.h"

@implementation CommandTaskListCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configModel:(CommandTaskListModel *)model
{
    self.label1.text = model.taskNo;
    self.label2.text = model.taskContent;
    self.label3.text = [NSString stringWithFormat:@"%@~%@",model.taskBeginDate,model.taskEndDate];
    self.label4.text = [NSString stringWithFormat:@"%@  %@",model.specName,model.taskUrgent];
    self.label5.text = model.tsAcceptPeo;
    if ([model.taskUrgent isEqualToString:@"重大"]) {
        self.contentView.backgroundColor = COLOR(255, 204, 255);
    }
    if ([model.taskUrgent isEqualToString:@"关键"]) {
        self.contentView.backgroundColor = COLOR(255, 255, 153);
    }
    if ([model.taskUrgent isEqualToString:@"严重"]) {
        self.contentView.backgroundColor = COLOR(204, 255, 255);
    }
    if ([model.taskUrgent isEqualToString:@"一般"]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
