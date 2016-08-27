//
//  PublicModel.m
//  telecom
//
//  Created by Sundear on 16/3/29.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "PublicModel.h"
#import "GdjModel.h"
#import "OltModel.h"
#import "ObdModel.h"
#import "OnuModel.h"
#define RightLabelWith (kScreenWidth-115)

@implementation PublicModel
//计算gdj cell高度
-(void)setGDjMoedl:(GdjModel *)GDjMoedl{
    _GDjMoedl = GDjMoedl;
    CGFloat equmphight = [self orangeLabelHeightWithModel:GDjMoedl.otName];
    
    CGFloat jifang = [self labelHeightWithModel:GDjMoedl.otRoom] + [self labelHeightWithModel:GDjMoedl.otRoomAddress];
    _hight = equmphight+jifang +240;
}
//计算olt cell 高度
-(void)setOltModel:(OltModel *)OltModel{
    _OltModel = OltModel;
    CGFloat equmphight = [self orangeLabelHeightWithModel:OltModel.oltName];
    NSString *str =[OltModel.oltRange stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    CGFloat jifang = [self labelHeightWithModel:OltModel.oltRoom ] + [self labelHeightWithModel:OltModel.oltRoomAddress]+[self labelHeightWithModel:str];
    _hight = equmphight+jifang+360;
}
//计算obd cell 高度
-(void)setOBDModel:(ObdModel *)OBDModel{
    _OBDModel = OBDModel;
    CGFloat equmphight = [self orangeLabelHeightWithModel:OBDModel.obdName];
    NSString *str =[OBDModel.obdRange stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    CGFloat jifang = [self labelHeightWithModel:OBDModel.obdRoom ] + [self labelHeightWithModel:OBDModel.obdRoom]+[self labelHeightWithModel:str];
    _hight = equmphight+jifang+340;

}
//计算onu cell 高度
-(void)setONUModel:(OnuModel *)ONUModel{
    _ONUModel = ONUModel;
    CGFloat equmphight = [self orangeLabelHeightWithModel:ONUModel.onuName];
    NSString *str =[ONUModel.onuRange stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    CGFloat jifang = [self labelHeightWithModel:ONUModel.onuRoom ] + [self labelHeightWithModel:ONUModel.onuRoomAddress]+[self labelHeightWithModel:str];
    _hight = equmphight+jifang+510;

}
-(CGFloat)labelHeightWithModel:(NSString *)str{
    return [str boundingRectWithSize:CGSizeMake(RightLabelWith, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size.height;
}
-(CGFloat)orangeLabelHeightWithModel:(NSString *)str{
    return [str boundingRectWithSize:CGSizeMake(RightLabelWith, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size.height;
}
@end
