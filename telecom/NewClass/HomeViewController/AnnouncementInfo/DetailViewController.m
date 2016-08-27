//
//  DetailViewController.m
//  telecom
//
//  Created by Sundear on 16/1/14.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *first;
@property (weak, nonatomic) IBOutlet UILabel *second;
@property (weak, nonatomic) IBOutlet UILabel *three;
@property (weak, nonatomic) IBOutlet UILabel *four;
@property (weak, nonatomic) IBOutlet UILabel *five;
@property (weak, nonatomic) IBOutlet UILabel *six;
@property (weak, nonatomic) IBOutlet UILabel *seven;
@property (weak, nonatomic) IBOutlet UILabel *eight;
@property (weak, nonatomic) IBOutlet UILabel *nine;
@property (weak, nonatomic) IBOutlet UILabel *teen;
@property (weak, nonatomic) IBOutlet UILabel *teenone;
@property (weak, nonatomic) IBOutlet UILabel *teentwo;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setInfo];
    // Do any additional setup after loading the view from its nib.
}
-(void)setInfo{
    self.first.text = self.dic[@"wfSn"];
    self.second.text=self.dic[@"startTime"];
    self.three.text =self.dic[@"childSpec"];
    self.four.text = self.dic[@"manufacturerName"];
    self.five.text = self.dic[@"deviceType"];
    self.six.text = self.dic[@"deviceModel"];
    self.seven.text = self.dic[@"version"];
    self.eight.text = [self.dic[@"updateNu"] isEqualToString:@"0"] ? @"否":@"是";
    self.nine.text = self.dic[@"execuPerson"];
    switch ([self.dic[@"result"] intValue]) {
        case 0:
            self.teen.text =@"未升级";
            break;
        case 1:
            self.teen.text =@"升级成功";
            break;
        case 2:
            self.teen.text =@"升级失败";
            break;
        case 3:
            self.teen.text =@"取消升级";
            break;
    }
    self.teenone.text = self.dic[@"actualStartTime"];
    self.teentwo.text = self.dic[@"actualEndTime"];
}



@end
