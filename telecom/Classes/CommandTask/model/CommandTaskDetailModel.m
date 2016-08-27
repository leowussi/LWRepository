//
//  CommandTaskDetailModel.m
//  telecom
//
//  Created by SD0025A on 16/5/16.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "CommandTaskDetailModel.h"

@implementation CommandTaskDetailModel
- (CGFloat)configHeight
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGSize expactSize = CGSizeMake(APP_W-100, MAXFLOAT);
    CGSize size1 = [self.sceneType boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size2 = [self.taskNo boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size3 = [self.taskContent boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size4 = [self.taskCreateDate boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size5 = [self.taskAppltReason boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size6 = [self.taskCreateOrg boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size7 = [self.taskCreatePeo boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
    CGSize size8 = [self.applyPeoPh boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size9 = [self.applyEmail boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size10 = [self.taskUrgent boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size11 = [self.taskType boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size12 = [self.taskBeginDate boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size13 = [self.taskEndDate boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size14 = [self.costTime boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
    CGSize size15 = [self.score boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size16 = [self.specialSkill boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size17 = [self.needPerNum boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
     CGFloat height1 = size1.height == 0 ? 14:size1.height;
     CGFloat height2 = size2.height == 0 ? 14:size2.height;
     CGFloat height3 = size3.height == 0 ? 14:size3.height;
     CGFloat height4 = size4.height == 0 ? 14:size4.height;
     CGFloat height5 = size5.height == 0 ? 14:size5.height;
     CGFloat height6 = size6.height == 0 ? 14:size6.height;
     CGFloat height7 = size7.height == 0 ? 14:size7.height;
     CGFloat height8 = size8.height == 0 ? 14:size8.height;
     CGFloat height9 = size9.height == 0 ? 14:size9.height;
     CGFloat height10 = size10.height == 0 ? 14:size10.height;
     CGFloat height11 = size11.height == 0 ? 14:size11.height;
     CGFloat height12 = size12.height == 0 ? 14:size12.height;
     CGFloat height13 = size13.height == 0 ? 14:size13.height;
     CGFloat height14 = size14.height == 0 ? 14:size14.height;
     CGFloat height15 = size15.height == 0 ? 14:size15.height;
     CGFloat height16 = size16.height == 0 ? 14:size16.height;
     CGFloat height17 = size17.height == 0 ? 14:size17.height;
    
    return 135+150 + height1+ height2+ height3+ height4+ height5+ height6+ height7+ height8+ height9+ height10+ height11+ height12+ height13+ height14+ height15+ height16+ height17;
    
}
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
