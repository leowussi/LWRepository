//
//  UserAndWANAndLanTwoCell.m
//  telecom
//
//  Created by SD0025A on 16/4/15.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//LAN

#import "UserAndWANAndLanTwoCell.h"
#import "UserAndWANAndLANTwoModel.h"

@implementation UserAndWANAndLanTwoCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configModel:(UserAndWANAndLANTwoModel *)model
{
    self.label1.text = [model.lanRoute isEqualToString:@""] ?@" ":model.lanRoute;
    self.label2.text = [model.lanRoom isEqualToString:@""] ?@" ":model.lanRoom;
    self.label3.text = [model.lanNu isEqualToString:@""] ?@" ":model.lanNu;
    self.label4.text = [model.lanDisk isEqualToString:@""] ?@" ":model.lanDisk;
    self.label5.text = [model.lanPort isEqualToString:@""] ?@" ":model.lanPort;
    self.label6.text = [model.lanControl isEqualToString:@""] ?@" ":model.lanControl;
    self.label7.text = [model.lanTag isEqualToString:@""] ?@" ":model.lanTag;
    self.label8.text = [model.lanType isEqualToString:@""] ?@" ":model.lanType;
    self.label9.text = [model.lanQos isEqualToString:@""] ?@" ":model.lanQos;
    self.label10.text = [model.lanEletric isEqualToString:@""] ?@" ":model.lanEletric;
    self.label11.text = [model.lanVlanId isEqualToString:@""] ?@" ":model.lanVlanId;
    self.label12.text = [model.lanLink isEqualToString:@""] ?@" ":model.lanLink;
    self.label13.text = [model.lanUseful isEqualToString:@""] ?@" ":model.lanUseful;
    self.label14.text = [model.lanMaxLen isEqualToString:@""] ?@" ":model.lanMaxLen;
    self.label15.text = [model.lanPass isEqualToString:@""] ?@" ":model.lanPass;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
