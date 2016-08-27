//
//  CommandTaskDetailCell.m
//  telecom
//
//  Created by SD0025A on 16/5/16.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "CommandTaskDetailCell.h"
#import "CommandTaskDetailModel.h"
@implementation CommandTaskDetailCell

- (void)awakeFromNib {
    self.isShowBtn.selected = NO;
    self.moreView.hidden = YES;
}
- (IBAction)uploadBtn:(UIButton *)sender {
    [self.delegate uploadFile];
}

- (void)configModel:(CommandTaskDetailModel *)model
{
    self.label1.text = [model.sceneType isEqualToString:@""] ? @" ":model.sceneType;
    self.label2.text = [model.taskNo isEqualToString:@""] ? @" ":model.taskNo;
    self.label3.text = [model.taskContent isEqualToString:@""] ?@" ":model.taskContent;
    self.label4.text = [model.taskCreateDate isEqualToString:@""] ? @" ":model.taskCreateDate;
    self.label5.text = [model.taskAppltReason isEqualToString:@""] ?@"  ":model.taskAppltReason;
    self.label6.text = [model.taskCreateOrg isEqualToString:@""] ? @" ":model.taskCreateOrg;
    self.label7.text = [model.taskCreatePeo isEqualToString:@""] ? @" ":model.taskCreatePeo;
    self.label8.text = [model.applyPeoPh isEqualToString:@""] ? @" ":model.applyPeoPh;
    self.label9.text = [model.applyEmail isEqualToString:@""] ? @" ":model.applyEmail;
    self.label10.text = [model.taskUrgent isEqualToString:@""] ? @" ":model.taskUrgent;
    self.label11.text = [model.taskType isEqualToString:@""] ? @" ":model.taskType;
    self.label12.text = [model.taskBeginDate isEqualToString:@""] ? @" ":model.taskBeginDate;
    self.label13.text = [model.taskEndDate isEqualToString:@""] ? @" ":model.taskEndDate;
    self.label14.text = [model.costTime isEqualToString:@""] ? @" ":model.costTime;
    self.label15.text = [model.score isEqualToString:@""] ? @" ":model.score;
    self.label16.text = [model.specialSkill isEqualToString:@""] ? @" ":model.specialSkill;
    self.label17.text = [model.needPerNum isEqualToString:@""] ? @" ":model.needPerNum;
//    self.label3.text = model.attachmentList;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)isShowBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.isShowBtn.selected == YES) {
        self.moreView.hidden = NO;
    }else{
        self.moreView.hidden = YES;
    }
    [self.delegate showMoreView:self.moreView];
}
@end
