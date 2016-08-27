//
//  AttachDetailCell.m
//  telecom
//
//  Created by liuyong on 15/4/24.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AttachDetailCell.h"
#import "UIImageView+WebCache.h"

@implementation AttachDetailCell

- (void)config:(AttaFileDetailModel *)model
{
    NSString *imageLocation = model.downloadLocation;
    NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@%@",ADDR_IP,ADDR_DIR,imageLocation]];
    [self.imageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder@2x"]];
    
    self.imageName.text = model.fileName;
    self.uploadTime.text = model.uploadTime;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)dealloc {
//    [_attachImage release];
//    [_imageName release];
//    [_uploadTime release];
//    [super dealloc];
//}
@end
