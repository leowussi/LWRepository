//
//  SelledFaultListDetailModel.m
//  telecom
//
//  Created by SD0025A on 16/4/19.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SelledFaultListDetailModel.h"

@implementation SelledFaultListDetailModel
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
- (CGFloat)configSiteHeight
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGSize expactSize = CGSizeMake(APP_W-20-155, MAXFLOAT);
    CGSize size = [self.site boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize contentSize = [self.workContent boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    return size.height+contentSize.height;
    
    
}

@end
