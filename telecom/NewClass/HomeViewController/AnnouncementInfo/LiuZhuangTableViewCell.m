//
//  LiuZhuangTableViewCell.m
//  telecom
//
//  Created by Sundear on 16/1/18.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "LiuZhuangTableViewCell.h"

@interface LiuZhuangTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *one;

@property (weak, nonatomic) IBOutlet UILabel *two;

@property (weak, nonatomic) IBOutlet UILabel *three;

@property (weak, nonatomic) IBOutlet UILabel *four;

@end

@implementation LiuZhuangTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)tabcell:(UITableView *)tableview{
    static NSString *ID = @"LiuZhuangTableViewCell";
    LiuZhuangTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:@"LiuZhuangTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableview dequeueReusableCellWithIdentifier:ID];
    }
    return cell;
}


-(void)setModel:(NSDictionary *)model{
    _model = model;
    self.one.text = model[@"actionName"];
    self.two.text = model[@"operatorGroupName"];
    self.three.text = model[@"operatorTime"];
    self.four.text = model[@"operatorUserName"];
    [self.four setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
}

@end
