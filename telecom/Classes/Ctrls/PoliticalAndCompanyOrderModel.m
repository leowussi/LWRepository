//
//  PoliticalAndCompanyOrderModel.m
//  telecom
//
//  Created by SD0025A on 16/3/30.
//  Copyright © 2016年 ZhongYun. All rights reserved.


#import "PoliticalAndCompanyOrderModel.h"

@implementation PoliticalAndCompanyOrderModel
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
- (CGFloat)configHeight
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGSize expactSize = CGSizeMake(APP_W-120, MAXFLOAT);
    CGSize size = [self.cusName boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
    return size.height;
    
}

@end
