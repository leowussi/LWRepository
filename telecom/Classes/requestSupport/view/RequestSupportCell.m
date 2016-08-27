//
//  RequestSupportCell.m
//  telecom
//
//  Created by SD0025A on 16/5/24.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "RequestSupportCell.h"
#import "RequestSupportModel.h"

@implementation RequestSupportCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configModel:(RequestSupportModel *)model
{
    self.orderNo.text = model.taskNo;
    self.name.text = model.name;
    self.status.text = model.status;
    self.oneType.text = model.oneType;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
