//
//  ZIChanTableViewCell.m
//  telecom
//
//  Created by Sundear on 16/4/11.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "ZIChanTableViewCell.h"

@interface ZIChanTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lei;
@property (weak, nonatomic) IBOutlet UILabel *xiang;
@property (weak, nonatomic) IBOutlet UILabel *mu;
@property (weak, nonatomic) IBOutlet UILabel *jie;
@property (weak, nonatomic) IBOutlet UILabel *zichanNumber;
@property (weak, nonatomic) IBOutlet UILabel *zichanDsc;
@property (weak, nonatomic) IBOutlet UILabel *ZhiZaoShang;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *MenberDesc;
@property (weak, nonatomic) IBOutlet UILabel *useDesc;



@end

@implementation ZIChanTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x+=5;
    frame.size.width-=10;
    [super setFrame:frame];
}
-(void)setModel:(ZiChanModel *)model{
    _model = model;
    self.lei.text = model.lei;
    self.xiang.text = model.xiang;
    self.mu.text = model.mu;
    self.jie.text = model.jie;
    self.zichanNumber.text = model.assetsNumber;
    self.zichanDsc.text = model.assetDes;
    self.ZhiZaoShang.text = model.manufacturerName;
    self.address.text = model.address;
    self.MenberDesc.text = model.mngDeptDes;
    self.useDesc.text = model.useDeptDes;

}
@end
