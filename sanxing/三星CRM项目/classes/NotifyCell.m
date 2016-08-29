//
//  NotifyCell.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/15.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "NotifyCell.h"

@interface NotifyCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation NotifyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"NotifyCell" owner:nil options:nil]lastObject];

    }
    return self;
}

- (void)setMessage:(ZYFSaleList *)message
{
    _message = message;
    for (ZYFAttributes *attr in message.attrArray) {
        if ([attr.myKey isEqualToString:@"new_name"]) {
            self.titleLabel.text = attr.myValueString;
        }else if ([attr.myKey isEqualToString:@"createdon"]){
//            self.timeLabel.text = attr.myDateTime;
        }else if ([attr.myKey isEqualToString:@"new_content"]){
            self.contentLabel.text = attr.myValueString;
        }
    }
    
    for (ZYFFormattedValue *format in message.formatValueArray) {
        self.timeLabel.text = format.myValueString;
    }
    [self setMsgStatus];
}

- (void)setMsgStatus
{
    for (ZYFAttributes *attr in self.message.attrArray) {
        if ([attr.myKey isEqualToString:@"new_status"]) {
            NSString * msgStatus = attr.pickList.value;
            if ([msgStatus isEqualToString:@"50"]) {
                //消息已读
                self.message.msgState = MSGMessageStateOpened;
            }else{
                //消息未读
                self.message.msgState = MSGMessageStateClosed;
            }
        }
    }
    if (self.message.msgState == MSGMessageStateClosed) {
        //表示message是否已经读取的label
        UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.contentView.center.y, 8, 8)];
        statusLabel.backgroundColor = [UIColor greenColor];
        [statusLabel.layer setMasksToBounds:YES];
        statusLabel.layer.cornerRadius = 4;
        [self.contentView addSubview:statusLabel];
    }else{
        
    }
}



@end
