//
//  RecordCell.m
//  telecom
//
//  Created by liuyong on 15/7/20.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "RecordCell.h"

@implementation RecordCell

- (void)awakeFromNib
{
    self.fileScrollView.layer.borderWidth = 0.5;
    self.fileScrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.fileScrollView.layer.cornerRadius = 4;
    self.fileScrollView.showsHorizontalScrollIndicator = NO;
    self.fileScrollView.showsVerticalScrollIndicator = NO;
    
}

- (void)configCell:(NSDictionary *)dict
{
    
    self.constuctorLabel.text = dict[@"constructor"];
    self.timeLabel.text = dict[@"taskTime"];
        
        NSArray *fileIdArr = dict[@"fileList"];
        if (fileIdArr.count > 0) {
            for (int i=0;i<fileIdArr.count;i++) {
                UIImageView *fileImage = [[UIImageView alloc] initWithFrame:RECT((72+3)*i, 0, 72, 72)];
                fileImage.tag = 2050 + i;
                [fileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@/attachment/taskAppointmentFile/%@",ADDR_IP,ADDR_DIR,fileIdArr[i][@"fileId"]]]];
                fileImage.userInteractionEnabled = YES;
                [self.fileScrollView addSubview:fileImage];
                
                [fileImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDetail:)]];
            }
            self.fileScrollView.hidden = NO;
            self.fileScrollView.contentSize = CGSizeMake(75*fileIdArr.count, 0);
            
        }else{
            
            self.fileScrollView.hidden = YES;
            self.fileTitleLabel.hidden = YES;
        }
}

- (void)imageDetail:(UITapGestureRecognizer *)ges
{
    UIView *view = ges.view;
    NSInteger index = view.tag - 2050;
    if (self.delegate) {
        [self.delegate showDetailImageWithIndex:index fileIdDict:self.fileIdDict];
    }
}

+ (CGFloat)heightForCell:(NSDictionary *)dict
{
        if ([dict[@"fileList"] count] > 0) {
            return 160;
        }else{
            return 60;
        }
}

@end
