//
//  LQLouYuButton.m
//  telecom
//
//  Created by Sundear on 16/3/17.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "LQLouYuButton.h"

@implementation LQLouYuButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textColor = RGBCOLOR(35, 143, 246);
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        [self setTitleColor:RGBCOLOR(35, 143, 246) forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, contentRect.size.width*0.8 , contentRect.size.height);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width*0.8, 15, contentRect.size.width*0.2 , contentRect.size.height-30);

}
//取消高亮效果
-(void)setHighlighted:(BOOL)highlighted{}
@end
