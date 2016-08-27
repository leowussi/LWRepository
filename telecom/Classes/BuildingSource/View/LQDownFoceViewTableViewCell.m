//
//  LQDownFoceViewTableViewCell.m
//  telecom
//
//  Created by Sundear on 16/3/24.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "LQDownFoceViewTableViewCell.h"
#define  PaddingWith  2
#define  RightLabelWith (kScreenWidth-110)


@interface LQDownFoceViewTableViewCell ()
@property ( strong, nonatomic)   UILabel *labelDown1;
@property ( strong, nonatomic)   UILabel *labelDown2;
@property ( strong, nonatomic)   UILabel *labelDown3;
@property ( strong, nonatomic)   UILabel *labelDown4;
@property ( strong, nonatomic)   UILabel *labelDown5;
@property ( strong, nonatomic)   UILabel *labelDown6;
@property ( strong, nonatomic)   UILabel *labelDown7;
@property ( strong, nonatomic)   UILabel *labelDown8;

@property (strong, nonatomic)   UILabel *RightlabelDown1;
@property (strong, nonatomic)   UILabel *RightlabelDown2;
@property (strong, nonatomic)   UILabel *RightlabelDown3;
@property (strong, nonatomic)   UILabel *RightlabelDown4;
@property (strong, nonatomic)   UILabel *RightlabelDown5;
@property (strong, nonatomic)   UILabel *RightlabelDown6;
@property (strong, nonatomic)   UILabel *RightlabelDown7;
@property (strong, nonatomic)   UILabel *RightlabelDown8;
@property(nonatomic,strong)LQBackView *right;
@property(nonatomic,strong)LQBackView *left;
@end

@implementation LQDownFoceViewTableViewCell

+(instancetype)cellWithTableView:(UITableView *)table{
    static NSString *ID = @"LQDownFoceViewTableViewCell";
    LQDownFoceViewTableViewCell *cell =  [table dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[LQDownFoceViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.labelDown1 = [self addLabelWithString:@"光 缆  名 称:"];
        self.labelDown2 = [self addLabelWithString:@"光 缆  类 型:"];
        self.labelDown3 = [self addLabelWithString:@"总 纤  芯 数:"];
        self.labelDown4 = [self addLabelWithString:@"占   用   数:"];
        self.labelDown5 = [self addLabelWithString:@"损   坏   数:"];
        self.labelDown6 = [self addLabelWithString:@"可   用   数:"];
        self.labelDown7 = [self addLabelWithString:@"保   留   数:"];
        self.labelDown8 = [self addLabelWithString:@"覆 盖  范 围:"];
        self.left = [[LQBackView alloc]init];

        [self.left addSubview:self.labelDown1]; [self.left addSubview:self.labelDown2]; [self.left addSubview:self.labelDown3]; [self.left addSubview:self.labelDown4]; [self.left addSubview:self.labelDown5]; [self.left addSubview:self.labelDown6]; [self.left addSubview:self.labelDown7]; [self.left addSubview:self.labelDown8];
        [self.contentView addSubview:self.left];
        self.RightlabelDown1 = [self addLabelWithString:@""];
        self.RightlabelDown2 = [self addLabelWithString:@""];
        self.RightlabelDown3 = [self addLabelWithString:@""];
        self.RightlabelDown4 = [self addLabelWithString:@""];
        self.RightlabelDown5 = [self addLabelWithString:@""];
        self.RightlabelDown6 = [self addLabelWithString:@""];
        self.RightlabelDown7 = [self addLabelWithString:@""];
        self.RightlabelDown8 = [self addLabelWithString:@""];
        
        self.right =[[LQBackView alloc]init];
        [self.right addSubview:self.RightlabelDown1];
        [self.right addSubview:self.RightlabelDown2];[self.right addSubview:self.RightlabelDown3];[self.right addSubview:self.RightlabelDown4];[self.right addSubview:self.RightlabelDown5];[self.right addSubview:self.RightlabelDown6];[self.right addSubview:self.RightlabelDown7];[self.right addSubview:self.RightlabelDown8];
        [self.contentView addSubview:self.right];
        
        _jiaoZhengButton = [YZIndexButton buttonWithType:UIButtonTypeCustom];
        [_jiaoZhengButton setBackgroundImage:[UIImage imageNamed:@"资源矫正"] forState:UIControlStateNormal];
        [self.contentView addSubview:_jiaoZhengButton];
        [_jiaoZhengButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-19);
            make.bottom.offset(-24);
            make.width.offset(23);
            make.height.offset(23);
        }];
    }
    return self;

}
-(UILabel *)addLabelWithString:(NSString *)str{
    UILabel *label = [[UILabel alloc]init];
    label.text=str;
    label.font = [UIFont systemFontOfSize:12];
    return label;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.labelDown1.frame=RECT(PaddingWith, 0, 80, 20);
    self.labelDown2.frame=RECT(PaddingWith, 25, 80, 20);
    self.labelDown3.frame=RECT(PaddingWith, 50, 80, 20);
    self.labelDown4.frame=RECT(PaddingWith, 75, 80, 20);
    self.labelDown5.frame=RECT(PaddingWith, 100, 80, 20);
    self.labelDown6.frame=RECT(PaddingWith, 125, 80, 20);
    self.labelDown7.frame=RECT(PaddingWith, 150, 80, 20);
    self.labelDown8.frame=RECT(PaddingWith, 175, 80, 20);
    
    self.RightlabelDown1 .frame=RECT(PaddingWith, 0, RightLabelWith , 20);
    self.RightlabelDown2.frame=RECT(PaddingWith, 25, RightLabelWith , 20);
    self.RightlabelDown3.frame=RECT(PaddingWith, 50, RightLabelWith , 20);
    self.RightlabelDown4.frame=RECT(PaddingWith, 75, RightLabelWith , 20);
    self.RightlabelDown5.frame=RECT(PaddingWith, 100, RightLabelWith , 20);
    self.RightlabelDown6.frame=RECT(PaddingWith, 125, RightLabelWith , 20);
    self.RightlabelDown7.frame=RECT(PaddingWith, 150, RightLabelWith , 20);
    self.RightlabelDown8.frame=RECT(PaddingWith, 175, RightLabelWith , self.model.RightViewHihgt);
    
    self.RightlabelDown1.text = self.model.model.focName;
    self.RightlabelDown2.text =self.model.model.focType;
    self.RightlabelDown3.text =self.model.model.focFiberTotal;
    self.RightlabelDown4.text =self.model.model.focFiberTackup;
    self.RightlabelDown5.text =self.model.model.focFiberDestroy;
    self.RightlabelDown6.text =self.model.model.focFiberAvailable;
    self.RightlabelDown7.text =self.model.model.focFiberKeep;
    NSString *str =[self.model.model.focRange stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    self.RightlabelDown8.text =str;
    
    self.left.frame = RECT(10, 10, 80, self.model.rowHihgt-10);
    self.right.frame = RECT(100, 10, [UIScreen mainScreen].bounds.size.width-110, self.model.rowHihgt-10);
    DLog(@"%@%@",NSStringFromCGRect(self.right.frame),NSStringFromCGRect(self.left.frame));
}

@end
