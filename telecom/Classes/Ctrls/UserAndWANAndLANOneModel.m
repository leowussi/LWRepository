//
//  UserAndWANAndLANOneModel.m
//  telecom
//
//  Created by SD0025A on 16/4/15.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//用户

#import "UserAndWANAndLANOneModel.h"

@implementation UserAndWANAndLANOneModel
- (CGFloat)configCellHeight
{
    CGSize size = [[self.userRoute isEqualToString:@""] ? @" ":self.userRoute boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size1 = [[self.userRoom isEqualToString:@""] ? @" " :self.userRoom boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size2 = [[self.userEquip isEqualToString:@""]? @" " :self.userEquip boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size3 = [[self.userPort isEqualToString:@""] ? @" " :self.userPort boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size4 = [[self.userPortSpeed isEqualToString:@""] ? @" " :self.userPortSpeed boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size5 = [[self.userType isEqualToString:@""] ? @" " :self.userType boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size6 = [[self.userLink isEqualToString:@""] ? @" " :self.userLink boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size7 = [[self.userWlanId isEqualToString:@""] ? @" " :self.userWlanId boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size8 = [[self.userIp isEqualToString:@""] ? @" " :self.userIp boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size9 = [[self.userMask isEqualToString:@""] ? @" " :self.userMask boundingRectWithSize:CGSizeMake(APP_W-90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    
    return size.height+size1.height+size2.height+size3.height+size4.height+size5.height+size6.height+size7.height+size8.height+size9.height+135;
}

@end
