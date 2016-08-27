//
//  UserAndWanAndLANCell.m
//  telecom
//
//  Created by SD0025A on 16/4/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//WAN

#import "UserAndWanAndLANCell.h"
#import "UserAndWanAndLANModel.h"
@implementation UserAndWanAndLANCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configModel:(UserAndWanAndLANModel *)model
{
    self.label1.text = [model.wanRoute isEqualToString:@""] ?@"  ":model.wanRoute;
    self.label2.text = [model.wanRoom isEqualToString:@""] ?@"  ":model.wanRoom;
    self.label3.text = [model.wanNu isEqualToString:@""] ?@"  ":model.wanNu;
    self.label4.text = [model.wanDisk isEqualToString:@""] ?@"  ":model.wanDisk;
    self.label5.text = [model.wanPort isEqualToString:@""] ?@" ":model.wanPort;
    self.label6.text = [model.wanTag isEqualToString:@""] ?@"  ":model.wanTag;
    self.label7.text = [model.wanProtocol isEqualToString:@""] ?@"  ":model.wanProtocol;
    self.label8.text = [model.wanV5 isEqualToString:@""] ?@"  ":model.wanV5;
    self.label9.text = [model.wanChkLen isEqualToString:@""] ?@"  ":model.wanChkLen;
    self.label10.text = [model.wanLcas isEqualToString:@""] ?@"  ":model.wanLcas;
    self.label11.text = [model.wanVwanId isEqualToString:@""] ?@"  ":model.wanVwanId;
    self.label12.text = [model.wanPass isEqualToString:@""] ?@"  ":model.wanPass;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
