//
//  contentView.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/23.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "contentView.h"

@interface contentView ()

@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *content;


@end

@implementation contentView

- (instancetype)init
{
    if (self = [super init]) {
//            self = [[[NSBundle mainBundle]loadNibNamed:@"Content" owner:nil options:nil]lastObject];
//        UILabel *subjectLabel = [UILabel alloc]initWithFrame
    }
    return self;
}

- (void)showContent
{
    for (ZYFAttributes *attr in self.message.attrArray) {
        if ([attr.myKey isEqualToString:@"new_name"]) {
            self.subject.text = attr.myValueString;
        }else if ([attr.myKey isEqualToString:@"createdon"]){
            self.timeLabel.text = attr.myDateTime;
        }else if ([attr.myValueString isEqualToString:@"new_content"]){
            self.content.text = attr.myValueString;
        }
    }
}

@end
