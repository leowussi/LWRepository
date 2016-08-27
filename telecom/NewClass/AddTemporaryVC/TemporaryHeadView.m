//
//  TemporaryHeadView.m
//  telecom
//
//  Created by 郝威斌 on 15/7/27.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "TemporaryHeadView.h"

@implementation TemporaryHeadView

- (id)initWithFrame:(CGRect)aRect {
    self = [super initWithFrame:aRect];
    if(self != nil){
        self.backgroundColor=[UIColor grayColor];
        
        self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 25)];
        self.leftView.backgroundColor = RGBCOLOR(122, 228, 0);
        [self addSubview:self.leftView];
        
        self.label1= [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 180, 25)];
        self.label1.textColor = [UIColor blackColor];
        [self addSubview:self.label1];
    
        UIImage *downImg = [UIImage imageNamed:@"新增自定义任务-手动输入-箭头-下"];
        self.imgView= [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-60, 10, downImg.size.width/1.5, downImg.size.height/1.5)];
        self.imgView.image = downImg;
        [self addSubview:self.imgView];
        
        self.bgBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [self addSubview:self.bgBtn];
        
        
    }
    return self;
}
//-(void)setOpen:(BOOL)open{
//    _open = open;
//    UIImage *downImg1 = [UIImage imageNamed:@"新增自定义任务-手动输入-箭头-下"];
//    UIImage *downImg = [UIImage imageNamed:@"新增自定义任务-手动输入-箭头-上"];
//    self.imgView.image = open ? downImg1 : downImg;
//}


@end
