//
//  JumperConnectionCell.m
//  telecom
//
//  Created by SD0025A on 16/4/1.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JumperConnectionCell.h"
#import "JumperConnectionCellModel.h"

@implementation JumperConnectionCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configModel:(JumperConnectionCellModel *)model
{
    self.label1.text = model.num;
    self.label2.text = model.linkNo;
    self.label3.text = model.flag;
    self.label4.text = model.routeInfo;
    self.label5.text = model.startPortSpeed;
    self.label6.text = model.ddf;
    self.label7.text = model.endPortSpeed;
    self.label7.lineBreakMode = NSLineBreakByCharWrapping;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
