//
//  YZWorkOrderHeaderView.m
//  telecom
//
//  Created by 锋 on 16/6/13.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZWorkOrderHeaderView.h"
#import "Masonry.h"

@implementation YZWorkOrderHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.backgroundColor = RGBCOLOR(235, 238, 243).CGColor;
        _button_siteName = [UIButton buttonWithType:UIButtonTypeCustom];
        _button_siteName.frame = CGRectMake(0, 0, kScreenWidth - 20, 40);
        [_button_siteName setTitle:@"金桥局" forState:UIControlStateNormal];
        _button_siteName.backgroundColor = [UIColor colorWithRed:46/255.0 green:141/255.0 blue:222/255.0 alpha:1];
        _button_siteName.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_button_siteName];
        
        
        _label_number = [[UILabel alloc] init];
        _label_number.font = [UIFont systemFontOfSize:11];
        _label_number.textAlignment = NSTextAlignmentCenter;
        _label_number.textColor = [UIColor whiteColor];
        _label_number.backgroundColor = [UIColor colorWithRed:241/255.0 green:143/255.0 blue:10/255.0 alpha:1];
        _label_number.layer.cornerRadius = 7.7;
        [_button_siteName addSubview:_label_number];
        _label_number.clipsToBounds = YES;
        [_label_number mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_button_siteName.titleLabel.mas_right);
            make.top.offset(4);
            make.width.offset(15);
            make.height.offset(15);
        }];
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.frame = CGRectMake(16, 8, 24, 24);
        imageLayer.contents = (id)[UIImage imageNamed:@"右"].CGImage;
        imageLayer.transform = CATransform3DMakeRotation(-M_PI/2, 0, 0, 1);
        
        [_button_siteName.layer addSublayer:imageLayer];

    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    CALayer *iamgeLayer = [_button_siteName.layer.sublayers lastObject];
    iamgeLayer.transform = CATransform3DMakeRotation(_isSelected ? M_PI/2 : -M_PI/2, 0, 0, 1);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
