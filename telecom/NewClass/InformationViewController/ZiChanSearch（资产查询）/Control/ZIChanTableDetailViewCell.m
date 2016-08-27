//
//  ZIChanTableViewCell.m
//  telecom
//
//  Created by Sundear on 16/4/13.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "ZIChanTableDetailViewCell.h"


@interface ZIChanTableDetailViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;
@property (weak, nonatomic) IBOutlet UILabel *label9;
@property (weak, nonatomic) IBOutlet UILabel *label10;
@property (weak, nonatomic) IBOutlet UILabel *label11;
@property (weak, nonatomic) IBOutlet UILabel *label12;
@property (weak, nonatomic) IBOutlet UILabel *label13;
@property (weak, nonatomic) IBOutlet UILabel *label14;
@property (weak, nonatomic) IBOutlet UILabel *label15;
@property (weak, nonatomic) IBOutlet UILabel *label16;
@property (weak, nonatomic) IBOutlet UILabel *label17;
@property (weak, nonatomic) IBOutlet UILabel *label18;
@property (weak, nonatomic) IBOutlet UILabel *label19;
@property (weak, nonatomic) IBOutlet UILabel *label20;
@property (weak, nonatomic) IBOutlet UILabel *label21;
@property (weak, nonatomic) IBOutlet UILabel *label22;
@property (weak, nonatomic) IBOutlet UILabel *label23;
@property (weak, nonatomic) IBOutlet UILabel *label24;
@property (weak, nonatomic) IBOutlet UILabel *label25;
@property (weak, nonatomic) IBOutlet UILabel *label26;
@property (weak, nonatomic) IBOutlet UILabel *label27;
@property (weak, nonatomic) IBOutlet UILabel *label28;
@property (weak, nonatomic) IBOutlet UILabel *label29;

@end

@implementation ZIChanTableDetailViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

-(void)setModel:(ZiChanDetailModel *)model{
    _model =model;
    
    self.label1.text = [model.assetsNumber isEqualToString:@""]?@" ":model.assetsNumber;
    self.label2.text = [model.transOrgAsset isEqualToString:@""]?@" ":model.transOrgAsset;

    self.label3.text = [model.aktivDate isEqualToString:@""]?@" ":model.aktivDate;
    self.label4.text = [model.useDeptId isEqualToString:@""]?@" ":model.useDeptId;
    self.label5.text = [model.useDeptDes isEqualToString:@""]?@" ":model.useDeptDes;
    self.label6.text = [model.resId isEqualToString:@""]?@" ":model.resId;
    self.label7.text = [model.mngDeptId isEqualToString:@""]?@" ":model.mngDeptId;
    self.label8.text = [model.mngDeptDes isEqualToString:@""]?@" ":model.mngDeptDes;
    self.label9.text = [model.assetDes isEqualToString:@""]?@" ":model.assetDes;
    self.label10.text = [model.type isEqualToString:@""]?@" ":model.type;
    self.label11.text = [model.manufacturerName isEqualToString:@""]?@" ":model.manufacturerName;
    self.label12.text = [model.address isEqualToString:@""]?@" ":model.address;
    self.label13.text = [model.isTemp isEqualToString:@""]?@" ":model.isTemp;
    self.label14.text = [model.lei isEqualToString:@""]?@" ":model.lei;
    self.label15.text = [model.xiang isEqualToString:@""]?@" ":model.xiang;
    self.label16.text = [model.mu isEqualToString:@""]?@" ":model.mu;
    self.label17.text = [model.jie isEqualToString:@""]?@" ":model.jie;
    self.label18.text = [model.remark isEqualToString:@""]?@" ":model.remark;
    self.label19.text = [model.attachment isEqualToString:@""]?@" ":model.attachment;
    self.label20.text = [model.isScrapped isEqualToString:@""]?@" ":model.isScrapped;
    self.label21.text = [model.isUnuse isEqualToString:@""]?@" ":model.isUnuse;
    self.label22.text = [model.isExpansion isEqualToString:@""]?@" ":model.isExpansion;
    self.label23.text = [model.isRent isEqualToString:@""]?@" ":model.isRent;
    self.label24.text = [model.keeper isEqualToString:@""]?@" ":model.keeper;
    self.label25.text = [model.isExceed isEqualToString:@""]?@" ":model.isExceed;
    self.label26.text = [model.wbs isEqualToString:@""]?@" ":model.wbs;
    self.label27.text = [model.profitDeptId isEqualToString:@""]?@" ":model.profitDeptId;
    self.label28.text = [model.costDeptId isEqualToString:@""]?@" ":model.costDeptId;
    self.label29.text = [model.user isEqualToString:@""]?@" ":model.user;
    [self layoutIfNeeded];
    model.high = CGRectGetMaxY(self.label29.frame)+10;
}
@end
