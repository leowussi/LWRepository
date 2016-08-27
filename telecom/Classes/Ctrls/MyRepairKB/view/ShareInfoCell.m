//
//  ShareInfoCell.m
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "ShareInfoCell.h"

@implementation ShareInfoCell

- (void)config:(ShareInfoModel *)model
{
    self.infoTitle.text = model.content;
    self.attachNum.text = model.fileCount;
    self.sharePerson.text = model.userId;
    self.shareDateAndTime.text = model.time;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)dealloc {
//    [_infoTitle release];
//    [_sharePerson release];
//    [_shareDateAndTime release];
//    [_attachNum release];
//    [super dealloc];
//}
@end
