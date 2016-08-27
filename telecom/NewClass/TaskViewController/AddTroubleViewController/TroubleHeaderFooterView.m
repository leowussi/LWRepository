//
//  TroubleHeaderFooterView.m
//  telecom
//
//  Created by Sundear on 16/2/18.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "TroubleHeaderFooterView.h"

@interface TroubleHeaderFooterView()
@property(nonatomic,strong)UIView *blueView;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *RoateImage;
@end

@implementation TroubleHeaderFooterView

+(instancetype)headerViewWithTableview:(UITableView *)tableview{
    static NSString *ID = @"header";
    TroubleHeaderFooterView *header = [tableview dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[TroubleHeaderFooterView alloc]initWithReuseIdentifier:ID];
    }
    return header;
}
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.blueView = [[UIView alloc]init];
        self.blueView.backgroundColor = RGBCOLOR(148, 219, 29);
        [self addSubview:self.blueView];
        
        self.backView = [[UIView alloc]init];
        self.backView.backgroundColor =RGBCOLOR(229, 229, 229);
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewDidClick:)];
        [self.backView addGestureRecognizer:ges];
        
        
        self.titleLabel = [[UILabel alloc]init];

        self.titleLabel.text = @"-----465444444444444444444444444444444444464-----";
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.backgroundColor = [UIColor redColor];
        [self bringSubviewToFront:self.titleLabel];
        
        [self.backView addSubview:self.textLabel];
        
        UIImage *image = [UIImage imageNamed:@"新增自定义任务-手动输入-箭头-上.png"];
        self.RoateImage = [[UIImageView alloc]initWithImage:image];
        self.RoateImage.contentMode=UIViewContentModeCenter;
        [self.backView addSubview:self.RoateImage];
        
        [self addSubview:self.backView];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.blueView.frame = CGRectMake(0, 0, 10, self.frame.size.height);
    self.backView.frame = CGRectMake(10, 0,self.frame.size.width-10 , self.frame.size.height);
    self.titleLabel.frame = CGRectMake(40, 0, 200, self.frame.size.height);
    
    self.RoateImage.frame = CGRectMake(self.frame.size.width-40, 0, 14, 14);
    
    DLog(@"%@,%@,%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(self.titleLabel.frame),NSStringFromCGRect(self.RoateImage.frame));
}

-(void)ViewDidClick:(TroubleHeaderFooterView *)header{
    DLog(@"-----------------------");
    //旋转图片
    
    //通知代理
    
}
@end
