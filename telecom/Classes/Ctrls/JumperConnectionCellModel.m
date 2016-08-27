//
//  JumperConnectionCellModel.m
//  telecom
//
//  Created by SD0025A on 16/4/14.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JumperConnectionCellModel.h"

@implementation JumperConnectionCellModel
- (CGFloat)configHeight
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGSize expactSize = CGSizeMake(APP_W-20-155, MAXFLOAT);
    CGSize size1 = [self.num boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size2 = [self.linkNo boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size3 = [self.flag boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size4 = [self.routeInfo boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size5 = [self.startPortSpeed boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size6 = [self.ddf boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size7 = [self.endPortSpeed boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
    return 40 + size1.height+size2.height+size3.height+size4.height+size5.height+size6.height+size7.height;
    
    
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
