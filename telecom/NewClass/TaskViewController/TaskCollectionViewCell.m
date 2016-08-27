//
//  TaskCollectionViewCell.m
//  i YunWei
//
//  Created by 郝威斌 on 15/5/7.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "TaskCollectionViewCell.h"

@implementation TaskCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *img = [UIImage imageNamed:@"xzyh.png"];
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, img.size.width/2,img.size.height/2)];
        self.imgView.backgroundColor = [UIColor clearColor];
        self.imgView.layer.masksToBounds = YES;
        self.imgView.layer.cornerRadius = img.size.height/4;
        self.imgView.userInteractionEnabled = YES;
        self.imgView.image = img;
        
        [self.contentView addSubview:self.imgView];
        
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-10, img.size.height/2+5, img.size.width, 20)];
        self.titleLable.text = @"周期工作";
        self.titleLable.textAlignment = 1;
        self.titleLable.font = [UIFont systemFontOfSize:13.0];
        self.titleLable.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLable];

        
        
    }
    return self;
}

@end
