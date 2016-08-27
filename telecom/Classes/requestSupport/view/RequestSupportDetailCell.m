//
//  RequestSupportDetailCell.m
//  telecom
//
//  Created by SD0025A on 16/5/24.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "RequestSupportDetailCell.h"
#import "RequestSupportDetailModel.h"
@implementation RequestSupportDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)taskAction:(UIButton *)sender {
    [self.delegate taskDetailAction:self];
}

- (void)configModel:(RequestSupportDetailModel *)model
{
    self.label1.text = model.sceneType;
    self.label2.text = model.taskNo;
    self.label3.text = model.name;
    self.label4.text = model.taskCreatePeo;
    self.label5.text = model.oneType;
    self.label6.text = model.twoType;
    self.label7.text = model.account;
    self.label8.text = [NSString stringWithFormat:@"%@ ~ %@",model.taskBeginDate,model.taskEndDate];
    self.label9.text = model.remark;
    self.label10.text = model.status;
    
    
}
@end
