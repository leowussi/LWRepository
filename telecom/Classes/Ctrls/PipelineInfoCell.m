//
//  PipelineInfoCell.m
//  telecom
//
//  Created by SD0025A on 16/4/7.
//  Copyright © 2016年 ZhongYun. All rights reserved.

//政企工单  流水信息 cell

#import "PipelineInfoCell.h"
#import "PoliticalAndCompanyTransListModel.h"
@implementation PipelineInfoCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)comfigModel:(PoliticalAndCompanyTransListModel *)model
{
    self.handleDepartment.text = model.delDept;
    self.handleStatus.text = model.action;
    self.handlePerson.text = model.dealUserName;
    self.agent.text = model.agencyName;
    self.source.text = model.source;
    self.handleDescrpection.text = model.actionDes;
    self.step.text =  model.step;
    self.timeLabel.text = model.actionTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
