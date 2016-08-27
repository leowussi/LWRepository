//
//  DetailTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/8/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.leftLabel = [UnityLHClass initUILabel:@"隐患编号:" font:13.0 color:[UIColor grayColor] rect:CGRectMake(10, 10, 100, 20)];
        [self.contentView addSubview:self.leftLabel];
        
        self.leftLabel1 = [UnityLHClass initUILabel:@"当前状态:" font:13.0 color:[UIColor grayColor] rect:CGRectMake(10, 35, 100, 20)];
        [self.contentView addSubview:self.leftLabel1];
        
        self.leftLabel2 = [UnityLHClass initUILabel:@"提交时间:" font:13.0 color:[UIColor grayColor] rect:CGRectMake(10, 60, 100, 20)];
        [self.contentView addSubview:self.leftLabel2];
        
        self.leftLabel3 = [UnityLHClass initUILabel:@"隐患分类:" font:13.0 color:[UIColor grayColor] rect:CGRectMake(10, 85, 100, 20)];
        [self.contentView addSubview:self.leftLabel3];
        
        self.leftLabel4 = [UnityLHClass initUILabel:@"隐患等级:" font:13.0 color:[UIColor grayColor] rect:CGRectMake(10, 110, 100, 20)];
        [self.contentView addSubview:self.leftLabel4];
        
        self.leftLabel5 = [UnityLHClass initUILabel:@"隐患部位:" font:13.0 color:[UIColor grayColor] rect:CGRectMake(10, 135, 100, 20)];
        [self.contentView addSubview:self.leftLabel5];
        
        self.leftLabel6 = [UnityLHClass initUILabel:@"部       门:" font:13.0 color:[UIColor grayColor] rect:CGRectMake(10, 170, 100, 20)];
        [self.contentView addSubview:self.leftLabel6];
        
        self.leftLabel7 = [UnityLHClass initUILabel:@"专       业:" font:13.0 color:[UIColor grayColor] rect:CGRectMake(10, 195, 100, 20)];
        [self.contentView addSubview:self.leftLabel7];
        
        self.leftLabel8 = [UnityLHClass initUILabel:@"隐患现象:" font:13.0 color:[UIColor grayColor] rect:CGRectMake(10, 220, 100, 20)];
        [self.contentView addSubview:self.leftLabel8];
        
        
        
        
        
        
        self.contentLabel = [UnityLHClass initUILabel:@"20150819001" font:13.0 color:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0] rect:CGRectMake(70, 10, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.contentLabel];
        
        self.contentLabel1 = [UnityLHClass initUILabel:@"20150819001" font:13.0 color:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0] rect:CGRectMake(70, 35, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.contentLabel1];
        
        self.contentLabel2 = [UnityLHClass initUILabel:@"20150819001" font:13.0 color:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0] rect:CGRectMake(70, 60, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.contentLabel2];
        
        self.contentLabel3 = [UnityLHClass initUILabel:@"20150819001" font:13.0 color:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0] rect:CGRectMake(70, 85, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.contentLabel3];
        
        self.contentLabel4 = [UnityLHClass initUILabel:@"20150819001" font:13.0 color:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0] rect:CGRectMake(70, 110, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.contentLabel4];
        
        self.contentLabel5 = [UnityLHClass initUILabel:@"20150819001" font:13.0 color:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0] rect:CGRectMake(70, 135, kScreenWidth-40, 40)];
        self.contentLabel5.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel5];
        
        self.contentLabel6 = [UnityLHClass initUILabel:@"" font:13.0 color:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0] rect:CGRectMake(70, 170, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.contentLabel6];
        
        self.contentLabel7 = [UnityLHClass initUILabel:@"20150819001" font:13.0 color:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0] rect:CGRectMake(70, 195, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.contentLabel7];
        
        self.contentLabel8 = [UnityLHClass initUILabel:@"20150819001" font:13.0 color:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0] rect:CGRectMake(70, 220, kScreenWidth-20, 20)];
        self.contentLabel8.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel8];

        
    }
    return self;
}

-(void)setDic:(NSDictionary *)dic{
        _dic = dic;
    DLog(@"%@",dic);
        self.contentLabel.text = [[dic  objectForKey:@"dangerNum"] description];

        self.contentLabel1.text = [dic   objectForKey:@"dangerStatusName"];

        self.contentLabel2.text = [dic   objectForKey:@"commiteTime"];

        self.contentLabel3.text = [dic   objectForKey:@"dangerCategoryName"];

        self.contentLabel4.text = [dic   objectForKey:@"dangerLevelName"];
        self.contentLabel5.text = [NSString stringWithFormat:@"%@  %@",[dic   objectForKey:@"siteName"],[dic   objectForKey:@"nuName"]];

        self.contentLabel6.text = [dic   objectForKey:@"dangerRegionName"];
        self.contentLabel6.numberOfLines=0;
    
        self.contentLabel7.text = [dic   objectForKey:@"dangerSpecName"];
    
        self.contentLabel8.text = [dic   objectForKey:@"dangerContent"];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat High = [self sizeWithString:self.contentLabel5.text].height;
    self.contentLabel5.frame = CGRectMake(70, 137, kScreenWidth-100, High);
    self.leftLabel6.frame = CGRectMake(10, CGRectGetMaxY(self.contentLabel5.frame)+5, 100, 20);

    CGFloat contentLabel6High = [self sizeWithString:self.contentLabel6.text].height;
    self.contentLabel6.frame = CGRectMake(72, CGRectGetMaxY(self.contentLabel5.frame)+5, kScreenWidth-100, contentLabel6High) ;
    self.contentLabel7.frame = CGRectMake(70, CGRectGetMaxY(self.contentLabel6.frame)+5, kScreenWidth-20, 20) ;
    self.leftLabel7.frame = CGRectMake(10, CGRectGetMaxY(self.contentLabel6.frame)+5, 100, 20);
    self.leftLabel8.frame = CGRectMake(10, CGRectGetMaxY(self.contentLabel7.frame)+5, 100, 20);
    self.contentLabel8.frame = CGRectMake(70, CGRectGetMaxY(self.contentLabel7.frame)+5, kScreenWidth-100, [self sizeWithString:self.contentLabel8.text].height);
    
}
-(CGSize )sizeWithString:(NSString *)str{
    CGSize size= CGSizeMake(kScreenWidth-100, MAXFLOAT);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0]
                           };
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
}
@end
