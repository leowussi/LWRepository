//
//  YZWorkOrderList.m
//  telecom
//
//  Created by 锋 on 16/6/15.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZWorkOrderList.h"

@implementation YZWorkOrderList

- (instancetype)initWithWorkOrderName:(NSString *)orderName workOrderNums:(NSString *)count
{
    self = [super init];
    if (self) {
        _workOrderName = orderName;
        _workOrderNums = count;
        _height_billContent = -25;
    }
    return self;
}

- (instancetype)initWithParserDictionary:(NSDictionary *)dict withFont:(UIFont *)font width:(CGFloat)width billTypeId:(NSInteger)typeId
{
    self = [super init];
    if (self) {
        _billTypeId = typeId;
        
        _billId = NoNullStr([dict objectForKey:@"billId"]);
        _billNo = NoNullStr([dict objectForKey:@"billNo"]);
        _status = NoNullStr([dict objectForKey:@"status"]);
        _createTime = [NoNullStr([dict objectForKey:@"createTime"]) componentsSeparatedByString:@" "][0];
        NSString *billContent = [[dict objectForKey:@"billContent"] stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
        billContent = [billContent stringByReplacingOccurrencesOfString:@"null" withString:@""];
        _height_billNo = [self calculateTextHeight:_billNo textWidth:width textFont:font];
        NSMutableArray *pArray = [NSMutableArray arrayWithCapacity:0];
        _billContent = [self adjustTextTypeset:billContent font:font array:pArray];

        _height_billContent = [self calculateAttributedStringHeight:_billContent textWidth:width textFont:font];

        for (NSMutableParagraphStyle *paragraphStyle in pArray) {
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        }
    }
    return self;
}

#pragma mark -- 调整文字的排版
- (NSMutableAttributedString *)adjustTextTypeset:(NSString *)str font:(UIFont *)font array:(NSMutableArray *)paragraphArray
{
    NSRange aRange = NSMakeRange(0, 0);
    
    NSRange range = NSMakeRange(0, 1);
    NSRange markRange;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font}];
    while (range.length == 1) {
        markRange.location = aRange.location + aRange.length;
        markRange.length = str.length - markRange.location;
        
        range = [str rangeOfString:@"-" options:NSCaseInsensitiveSearch range:markRange];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.headIndent = font.pointSize * (range.location - markRange.location);
        [paragraphArray addObject:paragraphStyle];

        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:markRange];
        
        aRange = [str rangeOfString:@"\n" options:NSCaseInsensitiveSearch range:markRange];
        if (aRange.length == 0) {
            break;
        }
    }
    
    
    return attributedString;
}

#pragma mark -- 计算文字的高度
- (CGFloat)calculateAttributedStringHeight:(NSAttributedString *)attributedString textWidth:(CGFloat)width textFont:(UIFont *)font
{
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:NULL];
    CGFloat height = ceilf(rect.size.height);
    if (height > font.pointSize * 8 + 2) {
        height = font.pointSize * 8 + 2;
    }
    return height < 20 ? 20 : height;
}

- (CGFloat)calculateTextHeight:(NSString *)text textWidth:(CGFloat)width textFont:(UIFont *)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    CGFloat height = ceilf(rect.size.height);
    return height;
}

@end
