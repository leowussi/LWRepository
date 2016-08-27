//
//  SelledPipelineInfoCell.m
//  telecom
//
//  Created by SD0025A on 16/5/20.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SelledPipelineInfoCell.h"
#import "SelledPinelineInfoModel.h"
@implementation SelledPipelineInfoCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)comfigModel:(SelledPinelineInfoModel *)model
{
    _model = model;
    self.label1.text = model.dealDept;
    self.label2.text = model.action;
    self.label3.text = model.dealUser;
    self.label4.text = model.source;
    self.label5.text = model.desc;
    self.label6.text = model.actionTime;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
