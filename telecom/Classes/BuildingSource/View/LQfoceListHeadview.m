//
//  LQfoceListHeadview.m
//  telecom
//
//  Created by Sundear on 16/3/24.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "LQfoceListHeadview.h"
#import "LQBackView.h"

#define  PaddingWith  2
#define  LabelHight  20
#define  RightLabelWith (kScreenWidth-110)
@interface LQfoceListHeadview()
@property ( strong, nonatomic)   UILabel *equipName;
@property ( strong, nonatomic)   UILabel *lab;
/**
 *  存放左边外层view
 */
@property ( strong, nonatomic)   LQBackView *left1;

/**
 *  存放右上角view容器
 */
@property ( strong, nonatomic)   LQBackView *right1;
@property ( strong, nonatomic)   UILabel *Leftlabel1;
@property ( strong, nonatomic)   UILabel *Leftlabel2;
@property ( strong, nonatomic)   UILabel *Leftlabel3;
@property ( strong, nonatomic)   UILabel *Leftlabel4;
@property ( strong, nonatomic)   UILabel *Leftlabel5;
@property ( strong, nonatomic)   UILabel *Leftlabel6;
@property ( strong, nonatomic)   UILabel *Leftlabel7;
@property ( strong, nonatomic)   UILabel *Leftlabel8;
@property ( strong, nonatomic)   UILabel *Leftlabel9;

@property ( strong, nonatomic)   UILabel *label1;
@property ( strong, nonatomic)   UILabel *label2;
@property ( strong, nonatomic)   UILabel *label3;
@property ( strong, nonatomic)   UILabel *label4;
@property ( strong, nonatomic)   UILabel *label5;
@property ( strong, nonatomic)   UILabel *label6;
@property ( strong, nonatomic)   UILabel *label7;
@property ( strong, nonatomic)   UILabel *label8;
@property ( strong, nonatomic)   UILabel *label9;

@property(nonatomic,strong)UIView *right;
@property(nonatomic,strong)UIView *left;


@property(nonatomic,strong)UIImageView *imView;
@property(nonatomic,strong)UILabel *buttonLabel;
@end
@implementation LQfoceListHeadview

+ (instancetype)headCellWithTableView:(UITableView *)tableView
{
    static NSString *headIdentifier = @"headerLQfoceListHeadview";
    
    LQfoceListHeadview *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headIdentifier];
    if (headView == nil) {
        headView = [[LQfoceListHeadview alloc] initWithReuseIdentifier:headIdentifier];
        headView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        headView.clipsToBounds = YES;
    }
    
    return headView;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.equipName = [[UILabel alloc]init];
        self.equipName.textAlignment =NSTextAlignmentLeft;
        self.equipName.font = [UIFont systemFontOfSize:17];
        self.equipName.textColor = [UIColor orangeColor];
        [self.contentView addSubview:self.equipName];
        self.lab = [[UILabel alloc]init];
        self.lab.text = @"设备名称";
        self.lab.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.lab];
        self.Leftlabel1 = [self addLabelWithString:@"区           局:"];
        self.Leftlabel2 = [self addLabelWithString:@"站           点:"];
        self.Leftlabel3 = [self addLabelWithString:@"所 在  机 房:"];
        self.Leftlabel4 = [self addLabelWithString:@"机 房  地 址:"];
        self.Leftlabel5 = [self addLabelWithString:@"端 子  总 数:"];
        self.Leftlabel6 = [self addLabelWithString:@"可用端子数:"];
        self.Leftlabel7 = [self addLabelWithString:@"占用端子数:"];
        self.Leftlabel8 = [self addLabelWithString:@"保留端子数:"];
        self.Leftlabel9 = [self addLabelWithString:@"覆 盖  范 围:"];
        
        
        self.left1 = [[LQBackView alloc]init];
        self.left1.backgroundColor = RGBCOLOR(241, 241, 241);
        [self.left1 addSubview:self.Leftlabel1];[self.left1 addSubview:self.Leftlabel2];[self.left1 addSubview:self.Leftlabel3];
        [self.left1 addSubview:self.Leftlabel4];[self.left1 addSubview:self.Leftlabel5];[self.left1 addSubview:self.Leftlabel6];
        [self.left1 addSubview:self.Leftlabel7];[self.left1 addSubview:self.Leftlabel8];[self.left1 addSubview:self.Leftlabel9];
        
        [self.contentView addSubview:self.left1];
        //左边标签
        
        
        
        
        
        
        
        //右边边标签
        self.right1 = [[LQBackView alloc]init];
        self.right1.backgroundColor = RGBCOLOR(241, 241, 241);
        
        self.label2 = [self addLabelWithString:nil];
        [self.right1 addSubview:self.label2];
        self.label3 = [self addLabelWithString:nil];
        [self.right1 addSubview:self.label3];
        self.label4 = [self addLabelWithString:nil];
        [self.right1 addSubview:self.label4];
        self.label5 = [self addLabelWithString:nil];
        [self.right1 addSubview:self.label5];
        self.label6 = [self addLabelWithString:nil];
        [self.right1 addSubview:self.label6];
        self.label7 = [self addLabelWithString:nil];
        [self.right1 addSubview:self.label7];
        self.label8 = [self addLabelWithString:nil];
        [self.right1 addSubview:self.label8];
        self.label9 = [self addLabelWithString:nil];
        [self.right1 addSubview:self.label9];
        self.label1 = [self addLabelWithString:nil];
        [self.right1 addSubview:self.label1];
        [self.contentView addSubview:self.right1];
        
        self.imView = [[UIImageView alloc]init];
        self.imView.frame = CGRectZero;
        self.imView.contentMode = UIViewContentModeCenter;
        self.buttonLabel =  [[UILabel alloc]init];
        self.buttonLabel.text = @"配光缆";
        self.buttonLabel.textAlignment=NSTextAlignmentLeft;
        self.buttonView = [[UIView alloc]init];
        
        [self.buttonView addSubview:self.imView];
        [self.buttonView addSubview:self.buttonLabel];
        
        [self.buttonView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickView)]];
        [self.contentView addSubview:self.buttonView];
        
        
        _jiaoZhengButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jiaoZhengButton setBackgroundImage:[UIImage imageNamed:@"资源矫正"] forState:UIControlStateNormal];
        [self.contentView addSubview:_jiaoZhengButton];
        [_jiaoZhengButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-19);
            make.bottom.offset(-44);
            make.width.offset(23);
            make.height.offset(23);
        }];

 
 }
 return self;
 }
-(void)didClickView{
//    _model.opened =! _model.opened;
    if ([self.delegate respondsToSelector:@selector(HeadViewDidClick:)]) {
        [self.delegate HeadViewDidClick:self];
    }
}
- (void)setIsOpened:(BOOL)isOpened
{
    _isOpened = isOpened;
    self.imView.transform = _isOpened ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
}
//- (void)didMoveToSuperview
//{
//    self.imView.transform = _model.opened ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
//}

-(UILabel *)addLabelWithString:(NSString *)str{
    UILabel *label = [[UILabel alloc]init];
    label.text=str;
    label.font = [UIFont systemFontOfSize:12];
    return label;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.lab.frame = RECT(10, 0, 80, 25);
    self.equipName.frame=RECT(100, 0, kScreenWidth-110, 25);
    self.equipName.text=self.model.model.gName;
    self.left1.frame = RECT(10, 30, 80, (LabelHight+5)*9+ self.model.rightViewHight);//左上角边frame
    self.right1.frame =RECT(100, 30, [UIScreen mainScreen].bounds.size.width-110, self.left1.frame.size.height);
    
    self.label1.text = self.model.model.gRegion;
    self.label2.text =self.model.model.gSite;
    self.label3.text =self.model.model.gRoom;
    self.label4.text =self.model.model.gRoomAddress;
    self.label5.text =self.model.model.gTerminalsTotal;
    self.label6.text =self.model.model.gTerminalsAvailable;
    self.label7.text =self.model.model.gTerminalsTakeup;
    self.label8.text =self.model.model.gTerminalsKeep;
    NSString *str =[self.model.model.gRange stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    self.label9.text =str;
    self.label9.numberOfLines=0;
    self.Leftlabel1.frame=RECT(PaddingWith, 0, 80, 20);
    self.Leftlabel2.frame=RECT(PaddingWith, 25, 80, 20);
    self.Leftlabel3.frame=RECT(PaddingWith, 50, 80, 20);
    self.Leftlabel4.frame=RECT(PaddingWith, 75, 80, 20);
    self.Leftlabel5.frame=RECT(PaddingWith, 100, 80, 20);
    self.Leftlabel6.frame=RECT(PaddingWith, 125, 80, 20);
    self.Leftlabel7.frame=RECT(PaddingWith, 150, 80, 20);
    self.Leftlabel8.frame=RECT(PaddingWith, 175, 80, 20);
    self.Leftlabel9.frame=RECT(PaddingWith, 200, 80, 20);
    
    self.label1.frame=RECT(PaddingWith, 0, RightLabelWith , 20);
    self.label2.frame=RECT(PaddingWith, 25, RightLabelWith , 20);
    self.label3.frame=RECT(PaddingWith, 50, RightLabelWith , 20);
    self.label4.frame=RECT(PaddingWith, 75, RightLabelWith , 20);
    self.label5.frame=RECT(PaddingWith, 100, RightLabelWith , 20);
    self.label6.frame=RECT(PaddingWith, 125, RightLabelWith , 20);
    self.label7.frame=RECT(PaddingWith, 150, RightLabelWith , 20);
    self.label8.frame=RECT(PaddingWith, 175, RightLabelWith , 20);
    self.label9.frame=RECT(PaddingWith, 200, RightLabelWith , self.model.rightViewHight);
    if (_model.model.focList.count) {
        self.buttonView.frame = RECT(10, CGRectGetMaxY(self.right1.frame), kScreenWidth-20, 30);
        self.imView.frame = RECT(kScreenWidth-40, 5, 20, 20);
        self.imView.image = [UIImage imageNamed:@"p3.png"];
        self.buttonLabel.frame = RECT(PaddingWith, 0, 100, 30);
    }else{
        self.buttonView.frame = CGRectZero;
        self.imView.frame= CGRectZero;
        self.buttonLabel.frame=CGRectZero;
    }
    
}

@end
