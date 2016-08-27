//
//  UserAndWanAndLANModel.m
//  telecom
//
//  Created by SD0025A on 16/4/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//WAN

#import "UserAndWanAndLANModel.h"

@implementation UserAndWanAndLANModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
- (CGFloat)configCellHeight
{
    CGSize size = [[self.wanRoute isEqualToString:@""] ? @" " :self.wanRoute boundingRectWithSize:CGSizeMake(APP_W-120, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size1 = [[self.wanRoom isEqualToString:@""] ? @" " :self.wanRoom boundingRectWithSize:CGSizeMake(APP_W-120, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size2 = [[self.wanNu isEqualToString:@""] ? @" " :self.wanNu boundingRectWithSize:CGSizeMake(APP_W-120, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size3 = [[self.wanDisk isEqualToString:@""] ? @" " :self.wanDisk boundingRectWithSize:CGSizeMake(APP_W-120, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size4 = [[self.wanPort isEqualToString:@""] ? @" " :self.wanPort boundingRectWithSize:CGSizeMake(APP_W-120, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size5 = [[self.wanTag isEqualToString:@""] ? @" " :self.wanTag boundingRectWithSize:CGSizeMake(APP_W-120, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size6 = [[self.wanProtocol isEqualToString:@""] ? @" " :self.wanProtocol boundingRectWithSize:CGSizeMake(APP_W-120, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size7 = [[self.wanV5 isEqualToString:@""] ? @" " :self.wanV5 boundingRectWithSize:CGSizeMake(APP_W-120, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size8 = [[self.wanChkLen isEqualToString:@""] ? @" " :self.wanChkLen boundingRectWithSize:CGSizeMake(APP_W-120, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size9 = [[self.wanLcas isEqualToString:@""] ? @" " :self.wanLcas boundingRectWithSize:CGSizeMake(APP_W-120, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size10 = [[self.wanVwanId isEqualToString:@""] ? @" " :self.wanVwanId boundingRectWithSize:CGSizeMake(APP_W-120, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size11 = [[self.wanPass isEqualToString:@""] ? @" " :self.wanPass boundingRectWithSize:CGSizeMake(APP_W-120, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    
    
    return size.height+size1.height+size2.height+size3.height+size4.height+size5.height+size6.height+size7.height+size8.height+size9.height+size10.height+size11.height+170;
}

@end
