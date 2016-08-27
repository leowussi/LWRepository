//
//  AccessoryListCell.m
//  telecom
//
//  Created by SD0025A on 16/4/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "AccessoryListCell.h"
#import "AccessoryListModel.h"

@implementation AccessoryListCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(AccessoryListModel *)model{
    
    _model = model;
    if (model.isDelete == 1) {
        self.deleteBtn.hidden = NO;
    }else{
        self.deleteBtn.hidden = YES;
    }
    //给fileName添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
    [self.fileName addGestureRecognizer:tap];
    if (model.attachmentName) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.attachmentName];
        NSRange strRange = {0,[model.attachmentName length]};
        self.fileName.text = model.attachmentName;
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        self.fileName.textColor = [UIColor blueColor];
        self.fileName.attributedText = str;
        self.fileName.userInteractionEnabled = YES;
    }
    
    self.label2.text = [NSString stringWithFormat:@"  %@",model.attachmentType];
    self.label3.text = [NSString stringWithFormat:@"  %@",model.uploadTime];;
    self.label4.text = [NSString stringWithFormat:@"  %@",model.uploadUserName];;
    self.label5.text = [NSString stringWithFormat:@"  %@",model.attachmentDes];;
}
- (void)tapLabel:(UITapGestureRecognizer *)tap
{
    [self.delegate fileNameLabelWasTaped:self.model.attachmentName attachmentId:self.model.attachmentId];
    
}
- (IBAction)deleteBtnAction:(id)sender {
    //点击删除按钮
    [self.delegate deleteBtnWasClicked:self.model path:self.indexPath];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
