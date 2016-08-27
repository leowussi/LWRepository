//
//  UserAndWANAndLANTwoModel.m
//  telecom
//
//  Created by SD0025A on 16/4/15.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//LAN

#import "UserAndWANAndLANTwoModel.h"

@implementation UserAndWANAndLANTwoModel
- (CGFloat)configCellHeight
{
    CGSize size = [[self.lanRoute isEqualToString:@""] ? @" " :self.lanRoute boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size1 = [[self.lanRoom isEqualToString:@""] ? @" " :self.lanRoom boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size2 = [[self.lanNu isEqualToString:@""] ? @" " :self.lanNu boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size3 = [[self.lanDisk isEqualToString:@""] ? @" " :self.lanDisk boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size4 = [[self.lanPort isEqualToString:@""] ? @" " :self.lanPort boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size5 = [[self.lanControl isEqualToString:@""] ? @" " :self.lanControl boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size6 = [[self.lanTag isEqualToString:@""] ? @" " :self.lanTag boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size7 = [[self.lanType isEqualToString:@""] ? @" " :self.lanType boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size8 = [[self.lanQos isEqualToString:@""] ? @" " :self.lanQos boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size9 = [[self.lanEletric isEqualToString:@""] ? @" " :self.lanEletric boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size10 = [[self.lanVlanId isEqualToString:@""] ? @" " :self.lanVlanId boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size11 = [[self.lanLink isEqualToString:@""] ? @" " :self.lanLink boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size12 = [[self.lanUseful isEqualToString:@""] ? @" " :self.lanUseful boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size13 = [[self.lanMaxLen isEqualToString:@""] ? @" " :self.lanMaxLen boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size14 = [[self.lanPass isEqualToString:@""] ? @" " :self.lanPass boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    
    return size.height+size1.height+size2.height+size3.height+size4.height+size5.height+size6.height+size7.height+size8.height+size9.height+size10.height+size11.height+size12.height+size13.height+size14.height+190;
}

@end
