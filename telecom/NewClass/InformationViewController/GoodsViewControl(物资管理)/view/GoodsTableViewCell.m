//
//  GoodsTableViewCell.m
//  telecom
//
//  Created by Sundear on 16/4/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "GoodsTableViewCell.h"


@interface GoodsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *admin;
@property (weak, nonatomic) IBOutlet UILabel *buyPerson;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *date;




@end


@implementation GoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(GoodsModel *)model{
    _model = model;
    self.type.text = model.wzType;
    self.name.text =model.wzName;
    self.admin.text = model.wzManager;
    self.buyPerson.text = model.borrowPerson;
    self.phoneNumber.text = model.contactWay;
    self.date.text = model.borrowDate;

}
@end
