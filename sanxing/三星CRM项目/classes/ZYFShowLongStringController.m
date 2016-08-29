//
//  ZYFShowLongStringController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/25.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFShowLongStringController.h"

@interface ZYFShowLongStringController ()

@end

@implementation ZYFShowLongStringController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细内容";
    //    self.view.backgroundColor = [UIColor lightGrayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 1.1;
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.masksToBounds = YES;
    
    NSRange range;
    range.location = 0;
    range.length = 0;
    self.textView.selectedRange = range;
    
    self.textView.textColor = [UIColor grayColor];
    self.textView.font = [UIFont systemFontOfSize:18];
    
    NSLog(@"text ======%@",self.textString);
    self.textView.text = self.textString;
    
    if (self.editable) {
        self.textView.editable = YES;
        //设置键盘类型
        self.textView.keyboardType = self.keyType;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    }else{
        self.textView.editable = NO;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)save{
    if ([self.delegate respondsToSelector:@selector(showLongStringController:editString:)]) {
        [self.delegate showLongStringController:self editString:self.textView.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}




@end
