//
//  AccessoryListModel.m
//  telecom
//
//  Created by SD0025A on 16/4/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "AccessoryListModel.h"

@implementation AccessoryListModel
- (CGFloat)configHeight
{
    CGSize size = [self.attachmentName == nil ? @" " :self.attachmentName boundingRectWithSize:CGSizeMake(250, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size1 = [self.uploadUserName == nil ? @" " :self.uploadUserName boundingRectWithSize:CGSizeMake(250, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size2 = [self.attachmentType == nil ? @" " :self.attachmentType boundingRectWithSize:CGSizeMake(250, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size3 = [self.uploadTime == nil ? @" " :self.uploadTime boundingRectWithSize:CGSizeMake(250, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    CGSize size4 = [self.attachmentDes == nil ? @" " :self.attachmentDes boundingRectWithSize:CGSizeMake(250, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
   
    return size.height+40+size1.height+size2.height+size3.height+size4.height;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
