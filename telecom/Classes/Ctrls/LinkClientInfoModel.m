//
//  LinkClientInfoModel.m
//  telecom
//
//  Created by SD0025A on 16/3/31.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "LinkClientInfoModel.h"

@implementation LinkClientInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (CGFloat)configHeight
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGSize expactSize = CGSizeMake(APP_W-20-155, MAXFLOAT);
    CGSize size1 = [self.linkNo boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size2 = [self.cusName boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size3 = [self.cusAddress boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size4 = [self.contract boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size5 = [self.tel boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size6 = [self.startInfo boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size7 = [self.startCompany boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size8 = [self.startAddress boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size9 = [self.startContract boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size10 = [self.startTel boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size11 = [self.endInfo boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size12 = [self.endCompany boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size13 = [self.endAddress boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size14 = [self.endContract boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size15 = [self.endTel boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
    return 10 + size1.height+size2.height+size3.height+size4.height+size5.height+size6.height+size7.height+size8.height+size9.height+size10.height+size11.height+size12.height+size13.height+size14.height+size15.height;
    
}

@end
