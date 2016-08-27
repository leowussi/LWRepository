//
//  LQFoceList.m
//  telecom
//
//  Created by Sundear on 16/3/25.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "LQFoceList.h"

@implementation LQFoceList
-(void)setModel:(PglModel *)model{
    _model=model;
    NSString *str= model.focRange;
    CGFloat flot =  [str isEqualToString:@""] ? 20:[str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-96, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size.height;
    _RightViewHihgt = flot;
    _rowHihgt = flot+25*9;

}
@end
