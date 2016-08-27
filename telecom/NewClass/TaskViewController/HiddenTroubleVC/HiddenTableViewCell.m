//
//  HiddenTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/8/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "HiddenTableViewCell.h"
#import "fashion.h"

@interface HiddenTableViewCell()
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *safeLabel;
@property(strong,nonatomic)UILabel *nomalLabel;
@property(strong,nonatomic)UILabel *positionLabel;
@property(strong,nonatomic)UILabel *becomYesLabel;
@property(strong,nonatomic)UILabel *dataLabel;
@end


@implementation HiddenTableViewCell




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [UnityLHClass initUILabel:@"隐患编号" font:12.0 color:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0] rect:CGRectMake(10, 10, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.titleLabel];

        self.safeLabel = [UnityLHClass initUILabel:@"安全" font:12.0 color:RGBCOLOR(45, 255, 10) rect:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+ 5, 30, 20, 20)];
        [self.contentView addSubview:self.safeLabel];
        
        self.nomalLabel = [UnityLHClass initUILabel:@"一般" font:12.0 color:RGBCOLOR(45, 255, 10) rect:CGRectMake(CGRectGetMaxX(self.safeLabel.frame)+5, 30, 20, 20)];
        self.nomalLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.nomalLabel];

        
        self.positionLabel = [UnityLHClass initUILabel:@"衡冰" font:12.0 color:[UIColor blackColor] rect:CGRectMake(10,CGRectGetMaxY(self.nomalLabel.frame)+5, 20, 20)];
        self.positionLabel.numberOfLines = 0;
        [self.contentView addSubview:self.positionLabel];
        
        self.becomYesLabel = [UnityLHClass initUILabel:@"待确认" font:12.0 color:RGBCOLOR(249, 209, 117) rect:CGRectMake(CGRectGetMaxX(self.positionLabel.frame)+5,CGRectGetMaxY(self.nomalLabel.frame)+5, 20, 20)];
        [self.contentView addSubview:self.becomYesLabel];
        
        self.dataLabel = [UnityLHClass initUILabel:@"衡冰" font:12.0 color:RGBCOLOR(142, 142, 142) rect:CGRectMake(CGRectGetMaxX(self.becomYesLabel.frame)+5,CGRectGetMaxY(self.nomalLabel.frame)+5, 20, 20)];
        self.dataLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.dataLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame =CGRectMake(10, 10, 140, 20);
    self.safeLabel.frame =CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 10, 80, 20);
    self.nomalLabel.frame =CGRectMake(CGRectGetMaxX(self.safeLabel.frame), 10, 40, 20);
    self.positionLabel.frame =CGRectMake(10,CGRectGetMaxY(self.nomalLabel.frame),self.frame.size.width-50, 40);
    self.becomYesLabel.frame = CGRectMake(10,CGRectGetMaxY(self.positionLabel.frame), 80, 20);
    
    self.dataLabel.frame =CGRectMake(self.frame.size.width-150, CGRectGetMaxY(self.positionLabel.frame), 140, 20);
}
+(instancetype)table:(UITableView *)tableview{
    static NSString *identifier = @"hiddenCell";
    HiddenTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HiddenTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)setDict:(NSDictionary *)dict{
    DLog(@"%@",dict);
    _dict = dict;
    self.titleLabel.text = dict[@"dangerNum"];
    self.safeLabel.text = dict[@"dangerCategory"];//无参数
    self.nomalLabel.text = dict[@"dangerLevel"];
    NSString *str1 = dict[@"nuName"];
    NSString *str2 = dict[@"siteName"];
    if (![str1 isEqualToString:@""]) {
        self.positionLabel.text = str1;
    }else{
       self.positionLabel.text = str2;
    }
 
    self.becomYesLabel.text = dict[@"statusName"];
    self.dataLabel.text = dict[@"commiteTime"];

}

@end
