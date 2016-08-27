//
//  CellGDJ.m
//  telecom
//
//  Created by Sundear on 16/3/28.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "LQCellONU.h"
#import "LQBackView.h"
#import "OnuModel.h"

#define RightLabelWith (kScreenWidth-125)
#define PaddingW 2
#define PaddingH 5
#define LeftLbaelW (90-5)
#define LeftLbaelH 20
@interface LQCellONU()
@property(nonatomic,strong)UILabel *sheiBeiName;


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
@property(nonatomic,strong)UILabel *label11;
@property(nonatomic,strong)UILabel *label12;
@property(nonatomic,strong)UILabel *label13;
@property(nonatomic,strong)UILabel *label14;
@property(nonatomic,strong)UILabel *label15;
@property(nonatomic,strong)UILabel *label16;
@property(nonatomic,strong)UILabel *label17;
@property(nonatomic,strong)UILabel *label18;
@property(nonatomic,strong)UILabel *label19;
@property(nonatomic,strong)UILabel *label20;


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
@property(nonatomic,strong)UILabel *rightLabel11;
@property(nonatomic,strong)UILabel *rightLabel12;
@property(nonatomic,strong)UILabel *rightLabel13;
@property(nonatomic,strong)UILabel *rightLabel14;
@property(nonatomic,strong)UILabel *rightLabel15;
@property(nonatomic,strong)UILabel *rightLabel16;
@property(nonatomic,strong)UILabel *rightLabel17;
@property(nonatomic,strong)UILabel *rightLabel18;
@property(nonatomic,strong)UILabel *rightLabel19;
@property(nonatomic,strong)UILabel *rightLabel20;

@property(nonatomic,strong)UILabel *equmt;

@end

@implementation LQCellONU
+(instancetype)tableView:(UITableView *)tableView{
    static NSString *ID = @"LQCellONU";
    LQCellONU *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[LQCellONU alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        
        self.equmt = [[UILabel alloc]init];
        self.equmt.font = [UIFont systemFontOfSize:16];
        self.equmt.numberOfLines=0;
        self.equmt.textColor = [UIColor orangeColor];
        [self.contentView addSubview:self.equmt];
        
        self.leftView = [[LQBackView alloc]init];
        self.label1 = [self addLabelWithString:@"设  备   编  码:"];
        self.label2 = [self addLabelWithString:@"区              局:"];
        self.label3 = [self addLabelWithString:@"站              点:"];
        self.label4 = [self addLabelWithString:@"所  在   机  房:"];
        self.label5 = [self addLabelWithString:@"机  房   地  址:"];
        self.label6 = [self addLabelWithString:@"设 备  类 型:"];
        self.label7 = [self addLabelWithString:@"生 命  周 期:"];
        self.label8 = [self addLabelWithString:@"语音总端口:"];
        self.label9 = [self addLabelWithString:@"语音占用端口:"];
        self.label10 = [self addLabelWithString:@"语音可用端口:"];
        self.label11 = [self addLabelWithString:@"语音保留端口:"];
        self.label12 = [self addLabelWithString:@"ASDL总端口:"];
        self.label13 = [self addLabelWithString:@"ASDL占用端口:"];
        self.label14 = [self addLabelWithString:@"ASDL可用端口:"];
        self.label15 = [self addLabelWithString:@"ASDL保留端口:"];
        self.label16 = [self addLabelWithString:@"LAN总端口:"];
        self.label17 = [self addLabelWithString:@"LAN占用端口:"];
        self.label18 = [self addLabelWithString:@"LAN可用端口:"];
        self.label19 = [self addLabelWithString:@"LAN保留端口:"];
        self.label20 = [self addLabelWithString:@"覆 盖  范 围:"];
        
        [self.leftView addSubview:self.label1];[self.leftView addSubview:self.label2];[self.leftView addSubview:self.label3];[self.leftView addSubview:self.label4];[self.leftView addSubview:self.label5];[self.leftView addSubview:self.label6];[self.leftView addSubview:self.label7];[self.leftView addSubview:self.label8];[self.leftView addSubview:self.label9];[self.leftView addSubview:self.label10];[self.leftView addSubview:self.label11];[self.leftView addSubview:self.label12];[self.leftView addSubview:self.label13];[self.leftView addSubview:self.label14];[self.leftView addSubview:self.label15];[self.leftView addSubview:self.label16];[self.leftView addSubview:self.label17];[self.leftView addSubview:self.label18];[self.leftView addSubview:self.label19];[self.leftView addSubview:self.label20];
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
        self.rightLabel11 = [self addLabelWithString:nil];
        self.rightLabel12 = [self addLabelWithString:nil];
        self.rightLabel13 = [self addLabelWithString:nil];
        self.rightLabel14 = [self addLabelWithString:nil];
        self.rightLabel15 = [self addLabelWithString:nil];
        self.rightLabel16 = [self addLabelWithString:nil];
        self.rightLabel17 = [self addLabelWithString:nil];
        self.rightLabel18 = [self addLabelWithString:nil];
        self.rightLabel19 = [self addLabelWithString:nil];
        self.rightLabel20 = [self addLabelWithString:nil];
        [self.rightView addSubview:self.rightLabel1];[self.rightView addSubview:self.rightLabel2];[self.rightView addSubview:self.rightLabel3];[self.rightView addSubview:self.rightLabel4];[self.rightView addSubview:self.rightLabel5];[self.rightView addSubview:self.rightLabel6];[self.rightView addSubview:self.rightLabel7];[self.rightView addSubview:self.rightLabel8];[self.rightView addSubview:self.rightLabel9];
        [self.rightView addSubview:self.rightLabel10];[self.rightView addSubview:self.rightLabel11];[self.rightView addSubview:self.rightLabel12];[self.rightView addSubview:self.rightLabel13];[self.rightView addSubview:self.rightLabel14];[self.rightView addSubview:self.rightLabel15];[self.rightView addSubview:self.rightLabel16];[self.rightView addSubview:self.rightLabel17];[self.rightView addSubview:self.rightLabel18];[self.rightView addSubview:self.rightLabel19];[self.rightView addSubview:self.rightLabel20];
        [self.contentView addSubview:self.rightView];
        
        _jiaoZhengButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
-(void)setModel:(OnuModel *)model{
    _model = model;

    self.rightLabel1.text  = model.onuCode;
    self.rightLabel2.text  = model.onuRegion;
    self.rightLabel3.text  = model.onuSite;
    self.rightLabel4.text  = model.onuRoom;
    self.rightLabel5.text  = model.onuRoomAddress;
    self.rightLabel6.text  = model.onuType;
    self.rightLabel7.text  = model.onuLifecycle;
    
    self.rightLabel8.text  = model.onuVoicePortTotal;
    self.rightLabel9.text  = model.onuVoicePortTackup;
    self.rightLabel10.text  = model.onuVoicePortAvailable;
    self.rightLabel11.text  = model.onuVoicePortKeep;
    
    self.rightLabel12.text  = model.onuAdslPortTotal;
    self.rightLabel13.text  = model.onuAdslPortTackup;
    self.rightLabel14.text  = model.onuAsdlPortAvailable;
    self.rightLabel15.text  = model.onuAdslPortKeep;
    
    self.rightLabel16.text  = model.onuLanPortTotal;
    self.rightLabel17.text  = model.onuLanPortTackup;
    self.rightLabel18.text  = model.onuLanPortAvailable;
    self.rightLabel19.text  = model.onuLanPortKeep;
    NSString *str =[model.onuRange stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    self.rightLabel20.text  = str;
    
    self.equmt.text = model.onuName;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.sheiBeiName.frame=RECT(5, 0, 80, 35);
    self.equmt.frame =RECT(100, PaddingH, (kScreenWidth-115), [self orangeLabelHeightWithModel:self.equmt.text]);
    
    self.label1.frame=RECT(PaddingW, PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel1.frame=RECT(PaddingW, PaddingH, RightLabelWith, [self labelHeightWithModel:self.rightLabel1.text]+PaddingH);
    
    self.label2.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel1.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel2.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel1.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    
    self.label3.frame=RECT(PaddingW, CGRectGetMaxY(self.label2.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel3.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel2.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    
    self.label4.frame=RECT(PaddingW, CGRectGetMaxY(self.label3.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel4.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel3.frame) + PaddingH, RightLabelWith, [self labelHeightWithModel:self.rightLabel4.text]+PaddingH);
    
    self.label5.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel4.frame) + PaddingH, LeftLbaelW, LeftLbaelH+PaddingH);
    self.rightLabel5.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel4.frame) + PaddingH, RightLabelWith, [self labelHeightWithModel:self.rightLabel5.text]+PaddingH);
    
    self.label6.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel5.frame) + PaddingH, LeftLbaelW, LeftLbaelH+PaddingH);
    self.rightLabel6.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel5.frame) + PaddingH, RightLabelWith,LeftLbaelH);
    
    self.label7.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel6.frame) + PaddingH, LeftLbaelW, LeftLbaelH+PaddingH);
    self.rightLabel7.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel6.frame) + PaddingH, RightLabelWith, [self labelHeightWithModel:self.rightLabel7.text]+PaddingH);
    
    self.label8.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel7.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel8.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel7.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label9.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel8.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel9.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel8.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label10.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel9.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel10.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel9.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label11.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel10.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel11.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel10.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label12.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel11.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel12.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel11.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label13.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel12.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel13.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel12.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label14.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel13.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel14.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel13.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label15.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel14.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel15.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel14.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label16.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel15.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel16.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel15.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label17.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel16.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel17.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel16.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label18.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel17.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel18.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel17.frame) + PaddingH, RightLabelWith, LeftLbaelH);
    self.label19.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel18.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel19.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel18.frame) + PaddingH, RightLabelWith, LeftLbaelH);

    self.label20.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel19.frame) + PaddingH, LeftLbaelW, LeftLbaelH);
    self.rightLabel20.frame=RECT(PaddingW, CGRectGetMaxY(self.rightLabel19.frame) + PaddingH, RightLabelWith, [self labelHeightWithModel:self.rightLabel20.text]+PaddingH);
    
    CGFloat temp =CGRectGetMaxY(self.equmt.frame)>CGRectGetMaxY(self.sheiBeiName.frame)?CGRectGetMaxY(self.equmt.frame):CGRectGetMaxY(self.sheiBeiName.frame);
    self.leftView.frame =RECT(10, temp+PaddingH, 90, CGRectGetMaxY(self.rightLabel20.frame));
    self.rightView.frame =RECT(110, temp+PaddingH, RightLabelWith+5, CGRectGetMaxY(self.rightLabel20.frame));
    
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
