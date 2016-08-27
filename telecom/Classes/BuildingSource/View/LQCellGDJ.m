//
//  CellGDJ.m
//  telecom
//
//  Created by Sundear on 16/3/28.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "LQCellGDJ.h"
#import "LQBackView.h"

#define RightLabelWith (kScreenWidth-115)
#define PaddingW 2
#define PaddingH 5
#define LeftLbaelW (80-5)
#define LeftLbaelH 20
@interface LQCellGDJ()
@property(nonatomic,strong)UILabel *sheiBeiName;
@property(nonatomic,strong)UILabel *equmpName;

@property(nonatomic,strong)LQBackView *leftView;
@property(nonatomic,strong)UILabel *label1;
@property(nonatomic,strong)UILabel *label2;
@property(nonatomic,strong)UILabel *label3;
@property(nonatomic,strong)UILabel *label4;
@property(nonatomic,strong)UILabel *label5;
@property(nonatomic,strong)UILabel *label6;
@property(nonatomic,strong)UILabel *label7;
@property(nonatomic,strong)UILabel *label8;
@property(nonatomic,strong)UILabel *label9;
@property(nonatomic,strong)UILabel *label10;


@property(nonatomic,strong)LQBackView *rightView;
@property(nonatomic,strong)UILabel *rightLabel1;
@property(nonatomic,strong)UILabel *rightLabel2;
@property(nonatomic,strong)UILabel *rightLabel3;
@property(nonatomic,strong)UILabel *rightLabel4;
@property(nonatomic,strong)UILabel *rightLabel5;
@property(nonatomic,strong)UILabel *rightLabel6;
@property(nonatomic,strong)UILabel *rightLabel7;
@property(nonatomic,strong)UILabel *rightLabel8;
@property(nonatomic,strong)UILabel *rightLabel9;
@property(nonatomic,strong)UILabel *rightLabel10;

@end

@implementation LQCellGDJ
+(instancetype)tableView:(UITableView *)tableView{
    static NSString *ID = @"LQCellGDJ---";
    LQCellGDJ *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[LQCellGDJ alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.sheiBeiName = [[UILabel alloc]init];
        self.sheiBeiName.font = [UIFont systemFontOfSize:16];
        self.sheiBeiName.text = @"设备名称";
        [self.contentView addSubview:self.sheiBeiName];
        
        self.equmpName = [[UILabel alloc]init];
        self.equmpName.font = [UIFont systemFontOfSize:16];
        self.equmpName.textColor = [UIColor orangeColor];
        [self.contentView addSubview:self.equmpName];
        
        self.leftView = [[LQBackView alloc]init];
        self.label1 = [self addLabelWithString:@"区            局:"];
        self.label2 = [self addLabelWithString:@"站            点:"];
        self.label3 = [self addLabelWithString:@"设 备  类 别:"];
        self.label4 = [self addLabelWithString:@"设 备  类 型:"];
         self.label5 = [self addLabelWithString:@"所 在  机 房:"];
         self.label6 = [self addLabelWithString:@"机 房  地 址:"];
         self.label7 = [self addLabelWithString:@"端 子  总 数:"];
         self.label8 = [self addLabelWithString:@"可用端子数:"];
         self.label9 = [self addLabelWithString:@"占用端子数:"];
         self.label10 = [self addLabelWithString:@"保留端子数:"];
        [self.leftView addSubview:self.label1];[self.leftView addSubview:self.label2];[self.leftView addSubview:self.label3];[self.leftView addSubview:self.label4];[self.leftView addSubview:self.label5];[self.leftView addSubview:self.label6];[self.leftView addSubview:self.label7];[self.leftView addSubview:self.label8];[self.leftView addSubview:self.label9];[self.leftView addSubview:self.label10];
        [self.contentView addSubview:self.leftView];
        
        self.rightView = [[LQBackView alloc]init];
        self.rightLabel1 = [self addLabelWithString:nil];
        self.rightLabel2 = [self addLabelWithString:nil];
        self.rightLabel3 = [self addLabelWithString:nil];
        self.rightLabel4 = [self addLabelWithString:nil];
        self.rightLabel5 = [self addLabelWithString:nil];
        self.rightLabel6 = [self addLabelWithString:nil];
        self.rightLabel7 = [self addLabelWithString:nil];
        self.rightLabel8 = [self addLabelWithString:nil];
        self.rightLabel9 = [self addLabelWithString:nil];
        self.rightLabel10 = [self addLabelWithString:nil];
        [self.rightView addSubview:self.rightLabel1];[self.rightView addSubview:self.rightLabel2];[self.rightView addSubview:self.rightLabel3];[self.rightView addSubview:self.rightLabel4];[self.rightView addSubview:self.rightLabel5];[self.rightView addSubview:self.rightLabel6];[self.rightView addSubview:self.rightLabel7];[self.rightView addSubview:self.rightLabel8];[self.rightView addSubview:self.rightLabel9];
        [self.rightView addSubview:self.rightLabel10];
        [self.contentView addSubview:self.rightView];
        
        _jiaoZhengButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jiaoZhengButton setBackgroundImage:[UIImage imageNamed:@"资源矫正"] forState:UIControlStateNormal];
        [self.contentView addSubview:_jiaoZhengButton];
        
        [_jiaoZhengButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-19);
            make.bottom.offset(-22);
            make.width.offset(23);
            make.height.offset(23);
        }];
    }
    return self;
}
-(void)setModel:(GdjModel *)model{
    _model = model;
    self.rightLabel1.text = model.otRegion;
    self.rightLabel2.text =model.otSite;
    self.rightLabel3.text = model.otCategory;
    self.rightLabel4.text = model.otType;
    self.rightLabel5.text = model.otRoom;
    self.rightLabel6.text = model.otRoomAddress;
    self.rightLabel7.text = model.otPortTotal;
    self.rightLabel8.text = model.otPortAvailable;
    self.rightLabel9.text = model.otPortTakeup;
    self.rightLabel10.text = model.otPortKeep;
    self.equmpName.text = model.otName;
    self.equmpName.numberOfLines=0;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.sheiBeiName.frame=RECT(5, 0, 80, 35);
    self.equmpName.frame =RECT(100, PaddingH, (kScreenWidth-115), [self orangeLabelHeightWithModel:self.equmpName.text]);
    self.label1.frame=RECT(PaddingW, PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel1.frame=RECT(PaddingW, PaddingH, RightLabelWith, LeftLbaelH);
    self.label2.frame=RECT(PaddingW, CGRectGetMaxY(self.label1.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel2.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel1.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label3.frame=RECT(PaddingW, CGRectGetMaxY(self.label2.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel3.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel2.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label4.frame=RECT(PaddingW, CGRectGetMaxY(self.label3.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel4.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel3.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label5.frame=RECT(PaddingW, CGRectGetMaxY(self.label4.frame) + PaddingH, LeftLbaelW, LeftLbaelH+PaddingH);
    self.rightLabel5.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel4.frame) + PaddingH, RightLabelWith, [self labelHeightWithModel:self.rightLabel5.text]+PaddingH);
    
    self.label6.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel5.frame) + PaddingH, LeftLbaelW, LeftLbaelH+PaddingH);
    self.rightLabel6.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel5.frame) + PaddingH, RightLabelWith, [self labelHeightWithModel:self.rightLabel6.text]+PaddingH);
    
    self.label7.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel6.frame) + PaddingH, LeftLbaelW, LeftLbaelH+PaddingH);
    self.rightLabel7.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel6.frame) + PaddingH, RightLabelWith, LeftLbaelH+PaddingH);
    self.label8.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel7.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel8.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel7.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label9.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel8.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel9.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel8.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label10.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel9.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel10.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel9.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    
    self.leftView.frame =RECT(10, CGRectGetMaxY(self.equmpName.frame)+PaddingH, 80, CGRectGetMaxY(self.rightLabel10.frame));
    self.rightView.frame =RECT(100, CGRectGetMaxY(self.equmpName.frame)+PaddingH, RightLabelWith+5, CGRectGetMaxY(self.rightLabel10.frame));

}
-(UILabel *)addLabelWithString:(NSString *)str{
    UILabel *label = [[UILabel alloc]init];
    label.text=str;
    label.numberOfLines=0;
    label.font = [UIFont systemFontOfSize:12];
    return label;
}
-(CGFloat)labelHeightWithModel:(NSString *)str{
   return [str boundingRectWithSize:CGSizeMake(RightLabelWith, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size.height;
}
-(CGFloat)orangeLabelHeightWithModel:(NSString *)str{
    return [str boundingRectWithSize:CGSizeMake(RightLabelWith, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size.height;
}
@end
