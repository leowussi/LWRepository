//
//  ZhDetailTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/9/18.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "ZhDetailTableViewCell.h"
#import "fashion.h"

@implementation ZhDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [UnityLHClass initUILabel:@"检查机房门窗（锁）、照明、地板、天花板是否完好。（月）" font:13.0 color:[UIColor blackColor] rect:CGRectMake(10, 10, kScreenWidth-40, 20)];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLable = [UnityLHClass initUILabel:@"2015/09/18  1机房" font:12.0 color:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0] rect:CGRectMake(10, 35, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.contentLable];
        
        self.statusLable = [UnityLHClass initUILabel:@"执行中" font:12.0 color:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-100, 35, 80, 20)];
        [self.contentView addSubview:self.statusLable];
        
        
        
        self.myTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 60, kScreenWidth-40, 20)];
        self.myTextField.placeholder = @"请输入数字";
        self.myTextField.font = [UIFont systemFontOfSize:12.0];
        self.myTextField.layer.borderColor = RGBCOLOR(233, 233, 233).CGColor;
        self.myTextField.layer.borderWidth = 0.5;
        self.myTextField.hidden = YES;
        [self.contentView addSubview:self.myTextField];
        
        self.remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 108, kScreenWidth-40, 20)];
        self.remarkLabel.textColor = [UIColor redColor];
        self.remarkLabel.font = [UIFont systemFontOfSize:12.0f];
        self.remarkLabel.hidden = YES;
        [self.contentView addSubview:self.remarkLabel];
        
        //
        UIImage *selectBtnImg = [UIImage imageNamed:@"rb_checked.png"];
        UIImage *selectBtnImg1 = [UIImage imageNamed:@"rb_normal.png"];
        
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectBtn setFrame:CGRectMake(15, 60, selectBtnImg.size.width/1.2, selectBtnImg.size.height/1.2)];
        [self.selectBtn setBackgroundColor:[UIColor clearColor]];
        [self.selectBtn setBackgroundImage:selectBtnImg forState:UIControlStateNormal];
        self.selectBtn.hidden = YES;
        [self.contentView addSubview:self.selectBtn];
        
        self.selectLable = [UnityLHClass initUILabel:@"执行中" font:12.0 color:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0] rect:CGRectMake(15+selectBtnImg.size.width/1.3, 60, 80, 20)];
        self.selectLable.hidden = YES;
        [self.contentView addSubview:self.selectLable];
        
        self.selectBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectBtn1 setFrame:CGRectMake(130, 60, selectBtnImg1.size.width/1.2, selectBtnImg1.size.height/1.2)];
        [self.selectBtn1 setBackgroundColor:[UIColor clearColor]];
        [self.selectBtn1 setBackgroundImage:selectBtnImg1 forState:UIControlStateNormal];
        self.selectBtn1.hidden = YES;
        [self.contentView addSubview:self.selectBtn1];
        
        self.selectLable1 = [UnityLHClass initUILabel:@"执行中" font:12.0 color:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0] rect:CGRectMake(130+selectBtnImg.size.width/1.3, 60, 80, 20)];
        self.selectLable1.hidden = YES;
        [self.contentView addSubview:self.selectLable1];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        
        self.dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dateBtn setFrame:CGRectMake(10, 60, 80, 20)];
        self.dateBtn.layer.borderColor = RGB(0x666666).CGColor;
        self.dateBtn.layer.borderWidth = 0.5;
        [self.dateBtn setTitle:dateString forState:UIControlStateNormal];
        [self.dateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.dateBtn setBackgroundColor:[UIColor clearColor]];
        self.dateBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        self.dateBtn.hidden = YES;
        [self.contentView addSubview:self.dateBtn];
        //
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter1 setDateFormat:@"HH:mm"];
        NSString *dateString1 = [formatter1 stringFromDate:[NSDate date]];
        
        self.dateBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dateBtn1 setFrame:CGRectMake(100, 60, 80, 20)];
        self.dateBtn1.layer.borderColor = RGB(0x666666).CGColor;
        self.dateBtn1.layer.borderWidth = 0.5;
        [self.dateBtn1 setTitle:dateString1 forState:UIControlStateNormal];
        [self.dateBtn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.dateBtn1 setBackgroundColor:[UIColor clearColor]];
        self.dateBtn1.titleLabel.font = [UIFont systemFontOfSize:13.0];
        self.dateBtn1.hidden = YES;
        [self.contentView addSubview:self.dateBtn1];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter2 setDateFormat:@"HH:mm:ss"];
        NSString *dateString2 = [formatter2 stringFromDate:[NSDate date]];
        
        self.dateBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dateBtn2 setFrame:CGRectMake(100, 60, 80, 20)];
        self.dateBtn2.layer.borderColor = RGB(0x666666).CGColor;
        self.dateBtn2.layer.borderWidth = 0.5;
        [self.dateBtn2 setTitle:dateString2 forState:UIControlStateNormal];
        [self.dateBtn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.dateBtn2 setBackgroundColor:[UIColor clearColor]];
        self.dateBtn2.titleLabel.font = [UIFont systemFontOfSize:13.0];
        self.dateBtn2.hidden = YES;
        [self.contentView addSubview:self.dateBtn2];
        
        self.upPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.upPhotoBtn setFrame:CGRectMake(10, 60, 80, 20)];
        self.upPhotoBtn.layer.borderColor = RGB(0x666666).CGColor;
        self.upPhotoBtn.layer.borderWidth = 0.5;
        [self.upPhotoBtn setTitle:@"附件信息" forState:UIControlStateNormal];
        [self.upPhotoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.upPhotoBtn setBackgroundColor:[UIColor clearColor]];
        self.upPhotoBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        self.upPhotoBtn.hidden = YES;
        [self.contentView addSubview:self.upPhotoBtn];   
    }
    return self;
}


- (void)cellButt:(NSArray*)arr withInt:(NSInteger)index withFrame:(float)recY
{
    
    UIImage *selectBtnImg = [UIImage imageNamed:@"rb_checked.png"];
    UIImage *selectBtnImg1 = [UIImage imageNamed:@"rb_normal.png"];
    
    
    for (int i = 0; i< 2; i++) {  ///(30+i%3*100, 20+i/3*87, 55, 55)
        
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.selectBtn setFrame:CGRectMake(10+120*i, recY, selectBtnImg.size.width/1.3, selectBtnImg.size.height/1.3)];
        
        //        [self.selectBtn setBackgroundImage:selectBtnImg forState:UIControlStateNormal];
        
        if (i == 0) {
            [self.selectBtn setBackgroundImage:selectBtnImg forState:UIControlStateNormal];
        }else{
            
            [self.selectBtn setBackgroundImage:selectBtnImg1 forState:UIControlStateNormal];
        }
        
        
        self.selectBtn.tag = index*10+10+i;
        [self.selectBtn addTarget:self action:@selector(faceImageButt:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.selectBtn];
        
        UILabel* lab = [UnityLHClass initUILabel:@"正常" font:12.0 color:[UIColor blackColor] rect:CGRectMake((10+selectBtnImg.size.width/1.3)+120*i, recY-3, 80, 20)];
        [self.contentView addSubview:lab];
        
    }
}


- (void)faceImageButt:(UIButton*)sender
{
    NSInteger na = sender.tag/10;
    
    NSLog(@"22 == %d",na);
    NSLog(@"sender.tag == %d",sender.tag);
    
    
    
    UIButton* butt =  (UIButton*)[self.contentView viewWithTag:na*10];
    UIButton* butt1 = (UIButton*)[self.contentView viewWithTag:na*10+1];
    
    
    NSArray* btnArr = [NSArray arrayWithObjects:butt,butt1, nil];
    
    for (UIButton* but in btnArr) {
        
        if ([sender isEqual:but]) {
            
            [but setBackgroundImage:[UIImage imageNamed:@"rb_checked.png"] forState:UIControlStateNormal];
        }else{
            
            [but setBackgroundImage:[UIImage imageNamed:@"rb_normal.png"] forState:UIControlStateNormal];
        }
    }
    
    [self.delegate selectButt:sender.tag];
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
