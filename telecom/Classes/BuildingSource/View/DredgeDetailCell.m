//
//  DredgeDetailCell.m
//  telecom
//
//  Created by SD0025A on 16/6/22.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "DredgeDetailCell.h"
#import "FloorListDataModel.h"

@implementation DredgeDetailCell

- (void)awakeFromNib {
    self.view1.tag = 11;
    self.view2.tag = 12;
    self.view3.tag = 13;
    self.view4.tag = 14;
    self.view5.tag = 15;
    self.view21.tag = 21;
    self.view22.tag = 22;
    self.view23.tag = 23;
    self.view24.tag = 24;
    self.view31.tag = 31;
    self.view32.tag = 32;
    UITapGestureRecognizer *ges11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view1 addGestureRecognizer:ges11];
    UITapGestureRecognizer *ges12 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view2 addGestureRecognizer:ges12];
    UITapGestureRecognizer *ges13 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view3 addGestureRecognizer:ges13];
    UITapGestureRecognizer *ges14 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view4 addGestureRecognizer:ges14];
    UITapGestureRecognizer *ges15 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view5 addGestureRecognizer:ges15];
    UITapGestureRecognizer *ges21 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view21 addGestureRecognizer:ges21];
    UITapGestureRecognizer *ges22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view22 addGestureRecognizer:ges22];
    UITapGestureRecognizer *ges23 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view23 addGestureRecognizer:ges23];
    UITapGestureRecognizer *ges24 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view24 addGestureRecognizer:ges24];
    UITapGestureRecognizer *ges31 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view31 addGestureRecognizer:ges31];
    UITapGestureRecognizer *ges32 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view32 addGestureRecognizer:ges32];
}
- (void)configModel:(FloorListDataModel *)model
{
    if (model.ponLan.integerValue > 0 ) {
        self.label1.text = @"可开通";
        self.label1.textColor = [UIColor greenColor];
    }else{
        self.label1.text = @"不可开通";
        self.label1.textColor = [UIColor redColor];
    }
    if (model.ponAdsl.integerValue >0) {
        self.label3.text = @"可开通";
        self.label3.textColor = [UIColor greenColor];
    }else{
        self.label3.text = @"不可开通";
        self.label3.textColor = [UIColor redColor];
    }
    if (model.voice.integerValue >0) {
        self.label24.text = @"可开通";
        self.label24.textColor = [UIColor greenColor];
    }else{
        self.label24.text = @"不可开通";
        self.label24.textColor = [UIColor redColor];
    }
    if (model.ftth.integerValue >0) {
        self.label2.text = @"可开通";
        self.label2.textColor = [UIColor greenColor];
        self.label23.text = @"可开通";
        self.label23.textColor = [UIColor greenColor];
    }else{
        self.label2.text = @"不可开通";
        self.label2.textColor = [UIColor redColor];
        self.label23.text = @"不可开通";
        self.label23.textColor = [UIColor redColor];
    }
    if (model.ftto.integerValue >0) {
        self.label5.text = @"可开通";
        self.label5.textColor = [UIColor greenColor];
    }else{
        self.label5.text = @"不可开通";
        self.label5.textColor = [UIColor redColor];
    }
    if (model.gfCir.integerValue >0) {
        self.label4.text = @"可开通";
        self.label4.textColor = [UIColor greenColor];
        self.label21.text = @"可开通";
        self.label21.textColor = [UIColor greenColor];
        self.label22.text = @"可开通";
        self.label22.textColor = [UIColor greenColor];
        self.label31.text = @"可开通";
        self.label31.textColor = [UIColor greenColor];
        self.label32.text = @"可开通";
        self.label32.textColor = [UIColor greenColor];
    }else{
        self.label4.text = @"不可开通";
        self.label4.textColor = [UIColor redColor];
        self.label21.text = @"不可开通";
        self.label21.textColor = [UIColor redColor];
        self.label22.text = @"不可开通";
        self.label22.textColor = [UIColor redColor];
        self.label31.text = @"不可开通";
        self.label31.textColor = [UIColor redColor];
        self.label32.text = @"不可开通";
        self.label32.textColor = [UIColor redColor];
        
    }
}
//手势
- (void)tapView:(UITapGestureRecognizer *)ges
{
    [self.delegate tapView:ges indexPath:self.indexPath];
}

@end
