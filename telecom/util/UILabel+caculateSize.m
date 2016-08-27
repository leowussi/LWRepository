//
//  UILabel+caculateSize.m
//  tubu
//
//  Created by benny on 14-7-7.
//  Copyright (c) 2014年 augmentum. All rights reserved.
//

#import "UILabel+caculateSize.h"

@implementation UILabel (caculateSize)
- (CGSize)caculateSizeWithString
{
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text];
//    self.attributedText = attrStr;
//    NSRange range = NSMakeRange(0, attrStr.length);
//    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
//    
//    CGSize stringSize = [self.text boundingRectWithSize:self.bounds.size
//                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                     attributes:dic
//                                                        context:nil].size;
    CGSize maximumSize = CGSizeMake(self.frame.size.width, 9999);
    CGSize stringSize = [self.text sizeWithFont:self.font
                                          constrainedToSize:maximumSize
                                              lineBreakMode:self.lineBreakMode];
    return stringSize;
}

- (double)getTextHeight
{
    double dHeight = 0.0;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        NSDictionary *attributes = @{NSFontAttributeName:self.font};
        CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil];
        
        dHeight = ceil(rect.size.height);
    }
    else
    {
        CGSize size = [self.text sizeWithFont:self.font
                              constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                  lineBreakMode:NSLineBreakByWordWrapping];
        
        dHeight = ceil(size.height);
    }
    return dHeight;
}

- (double)getTextWidth
{
    double dWidth = 0.0;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        NSDictionary *attributes = @{NSFontAttributeName:self.font};
        CGRect rect = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
        
        dWidth = ceil(rect.size.width);
    }
    else
    {
        CGSize size = [self.text sizeWithFont:self.font
                            constrainedToSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                lineBreakMode:NSLineBreakByWordWrapping];
        
        dWidth = ceil(size.width);
    }
    return dWidth;
}
@end
