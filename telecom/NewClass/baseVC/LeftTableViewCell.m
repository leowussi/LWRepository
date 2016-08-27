//
//  LeftTableViewCell.m
//  i YunWei
//
//  Created by 郝威斌 on 15/5/13.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "LeftTableViewCell.h"
#import "fashion.h"
@implementation LeftTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization co
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth-60, 20)];
        self.titleLable.text = @"隐患";
        self.titleLable.numberOfLines = 0;
        self.titleLable.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:self.titleLable];
        
//        self.dataLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-190, 10, 200, 20)];
//        self.dataLable.text = @"2015/05/13 14:38:38";
//        self.dataLable.font = [UIFont systemFontOfSize:12.0];
//        self.dataLable.textColor = [UIColor grayColor];
//        [self.contentView addSubview:self.dataLable];
        
        self.contentLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, kScreenWidth-60, 20)];
        self.contentLable.text = @"无线网元无线网元无线网元无线网元";
        self.contentLable.font = [UIFont systemFontOfSize:12.0];
        self.contentLable.textColor = [UIColor colorWithRed:33.0/255.0 green:170.0/255.0 blue:234.0/255.0 alpha:1.0];
        [self.contentView addSubview:self.contentLable];
        
//        05-dian
        UIImage *dianImg = [UIImage imageNamed:@"yellow_point.png"];
        self.infoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-60, 30, dianImg.size.width/2, dianImg.size.height/2)];
        self.infoImgView.image = dianImg;
        [self.contentView addSubview:self.infoImgView];
        
    }
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
