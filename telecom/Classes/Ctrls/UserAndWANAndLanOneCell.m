//
//  UserAndWANAndLanOneCell.m
//  telecom
//
//  Created by SD0025A on 16/4/15.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//User

#import "UserAndWANAndLanOneCell.h"
#import "UserAndWANAndLANOneModel.h"
@implementation UserAndWANAndLanOneCell

- (void)awakeFromNib {
    
}
- (void)configModel:(UserAndWANAndLANOneModel *)model
{
    self.label1.text = [model.userRoute isEqualToString:@""] ? @" ":model.userRoute;
    self.label2.text = [model.userRoom isEqualToString:@""] ? @" ":model.userRoom;
    self.label3.text = [model.userEquip isEqualToString:@""] ? @" ":model.userEquip;
    self.label4.text = [model.userPort isEqualToString:@""] ? @" ":model.userPort;
    self.label5.text = [model.userPortSpeed isEqualToString:@""] ?@" ":model.userPortSpeed;
    self.label6.text = [model.userType isEqualToString:@""] ? @" ":model.userType;
    self.label7.text = [model.userLink isEqualToString:@""] ? @" ":model.userLink;
    self.label8.text = [model.userWlanId isEqualToString:@""] ? @" ":model.userWlanId;
    self.label9.text = [model.userIp isEqualToString:@""] ? @" ":model.userIp;
    self.label10.text = [model.userMask isEqualToString:@""] ? @" ":model.userMask;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
