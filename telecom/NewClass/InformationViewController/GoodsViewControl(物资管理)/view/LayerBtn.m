//
//  LayerBtn.m
//  telecom
//
//  Created by Sundear on 16/4/29.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "LayerBtn.h"

@implementation LayerBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [self loadRiges];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if ([super initWithCoder:aDecoder]) {
        [self loadRiges];
    }
    return self;
}
-(void)loadRiges{
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds=YES;
    self.clipsToBounds = YES;
}
@end
