//
//  PoliticalAndCompanyTransListModel.m
//  telecom
//
//  Created by SD0025A on 16/4/13.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "PoliticalAndCompanyTransListModel.h"

@implementation PoliticalAndCompanyTransListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (CGFloat)configHeight
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGSize expactSize = CGSizeMake(APP_W-90, MAXFLOAT);
    CGSize size1 = [self.delDept boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
   
    
    return size1.height;
    
    
}

@end
