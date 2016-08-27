//
//  FrameModel.m
//  telecom
//
//  Created by Sundear on 16/3/1.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "FrameModel.h"

@implementation FrameModel
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.hight = 177+[self sizeWithString:[NSString stringWithFormat:@"%@\\%@",[dic   objectForKey:@"siteName"],[dic   objectForKey:@"nuName"]]].height+[self sizeWithString:[dic   objectForKey:@"nuName"]].height+[self sizeWithString:[dic   objectForKey:@"dangerContent"]].height;
  
}

-(CGSize )sizeWithString:(NSString *)str{
    CGSize size= CGSizeMake(kScreenWidth-100, MAXFLOAT);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0]
                          };
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
}
@end
