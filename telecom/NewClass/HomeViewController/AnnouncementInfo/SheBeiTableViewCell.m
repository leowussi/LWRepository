//
//  SheBeiTableViewCell.m
//  telecom
//
//  Created by Sundear on 16/1/15.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SheBeiTableViewCell.h"


@interface SheBeiTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *shebei;
@property (weak, nonatomic) IBOutlet UILabel *banben;
@property (weak, nonatomic) IBOutlet UILabel *kaishi;
@property (weak, nonatomic) IBOutlet UILabel *jieshu;

@end

@implementation SheBeiTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+(instancetype)tabcell:(UITableView *)tableview{
    static NSString *ID = @"SheBeiTableViewCell";
    SheBeiTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:@"SheBeiTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableview dequeueReusableCellWithIdentifier:ID];
    }
    return cell;
}

-(void)setModel:(NSDictionary *)model{
    _model = model;
    self.shebei.text = model[@"deviceName"];
   self.banben.text=model[@"versionNo"];
    self.kaishi.text = model[@"planStartTime"];
    self.jieshu.text = model[@"planEndTime"];
}



@end
