//
//  LQrowHightModel.m
//  telecom
//
//  Created by Sundear on 16/3/23.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "LQrowHightModel.h"
#import "PglModel.h"

@implementation LQrowHightModel

-(NSMutableArray *)RightDownarray{
    if (_RightDownarray==nil) {
        _RightDownarray = [NSMutableArray array];
    }
    return _RightDownarray;
}
-(NSMutableArray *)RightDownViewHightarray{
    if (_RightDownViewHightarray==nil) {
        _RightDownViewHightarray = [NSMutableArray array];
    }
    return _RightDownViewHightarray;
}
-(void)setModel:(GjjxModel *)model{
    _model = model;
    NSString *str =[model.gRange stringByReplacingOccurrencesOfString:@"," withString:@"\\n"];
    CGFloat firstH = [str isEqualToString:@""] ? 20 : [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-96, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size.height;
    if (model.focList.count) {
         _HeaderViewHight = firstH+25*9+35+30;
    }else{
        _HeaderViewHight = firstH+25*9+35;
    }
   
    

        NSMutableArray *temparray = [NSMutableArray array];
        for (PglModel *FoceModel in model.focList) {
            NSString *str =[FoceModel.focRange stringByReplacingOccurrencesOfString:@"," withString:@"\\n"];
            CGFloat flot =  [str isEqualToString:@""] ? 20:[str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-96, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size.height;
            [temparray addObject:@(flot)];
            [_RightDownViewHightarray addObject:@(flot+25*9)];
        }
        
        _RightDownarray = temparray;
        _rightViewHight =firstH;
    
}


@end
