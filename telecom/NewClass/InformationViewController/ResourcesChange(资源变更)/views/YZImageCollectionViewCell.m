//
//  YZImageCollectionViewCell.m
//  ResouceChanged
//
//  Created by 锋 on 16/4/27.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZImageCollectionViewCell.h"

@implementation YZImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView_upImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, self.frame.size.width - 8, self.frame.size.height - 8)];
        [self.contentView addSubview:_imageView_upImage];
        
        _button_delete = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button_delete setBackgroundImage:[UIImage imageNamed:@"paopao关闭"] forState:UIControlStateNormal];
        _button_delete.center = CGPointMake(self.frame.size.width - 8, 8);
        _button_delete.bounds = CGRectMake(0, 0, 23, 23);
        [self.contentView addSubview:_button_delete];
    }
    return self;
}

@end
