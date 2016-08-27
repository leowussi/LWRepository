//
//  CheckTestListCell.m
//  telecom
//
//  Created by SD0025A on 16/4/19.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "CheckTestListCell.h"
#import "CheckTestListModel.h"
@implementation CheckTestListCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configModel:(CheckTestListModel *)model
{
    self.label1.text = model.dealDept;
    self.label2.text = model.action;
    self.label3.text = [NSString stringWithFormat:@"%@ %@",model.dealUser,model.dealRoom];
    self.label4.text = model.source;
    self.label5.text = model.desc;
    self.label6.text = model.actionTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
