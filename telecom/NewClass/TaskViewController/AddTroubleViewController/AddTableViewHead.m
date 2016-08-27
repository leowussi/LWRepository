//
//  AddTableViewHead.m
//  telecom
//
//  Created by Sundear on 16/2/18.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "AddTableViewHead.h"
#import "HWBProgressHUD.h"

@interface AddTableViewHead ()
@property(nonatomic,strong)TroubleBtn *selebtn;
@property(nonatomic,strong)TroubleBtn *selebtn1;
@property(nonatomic,strong)NSMutableArray *arr1;
@property(nonatomic,strong)NSMutableArray *arr2;
@property(nonatomic,copy)NSString *faultCategory;//隐患分类
@property(nonatomic,copy)NSString *faultLevel ;//隐患等级
@end

@implementation AddTableViewHead

//隐患分类
- (IBAction)btnClick:(UIButton *)sender {
    self.faultCategory = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    self.selebtn.selected=NO;
    sender.selected=YES;
    self.selebtn=sender;
    DLog(@"%@",self.faultCategory);
    if ([self.delegate respondsToSelector:@selector(YinHuanGroup:)]) {
        [self.delegate YinHuanGroup:self.faultCategory];
    }
}

//隐患等级
- (IBAction)GrowSelect:(UIButton *)sender {
    self.faultLevel= [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    self.selebtn1.selected=NO;
    sender.selected=YES;
    self.selebtn1=sender;
    if (sender.tag==1) {
       self.nomalBtn.selected =!sender.selected;
    }
    DLog(@"%@",self.faultLevel);
    if ([self.delegate respondsToSelector:@selector(YinHuanSelsct:)]) {
        [self.delegate YinHuanSelsct:self.faultLevel];
    }
}

//部门
- (IBAction)selectBm:(id)sender {
    self.arr1 = [NSMutableArray array];
    __weak typeof(self) LQself = self;
    httpGET1noPara(@"MyTask/GetDangerDictionaries", ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            LQself.arr1 = result[@"deptList"];
            if ([LQself.delegate respondsToSelector:@selector(BMbtnClick:)]) {
                 [LQself.delegate BMbtnClick:LQself.arr1];
            }
        
           
        }
    });
}
//专业
- (IBAction)selectZy:(id)sender {
    self.arr2 =  [NSMutableArray array];
    __weak typeof(self) LQself = self;
    httpGET1noPara(@"MyTask/GetDangerDictionaries", ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            LQself.arr2 = result[@"specList"];
            if ([LQself.delegate respondsToSelector:@selector(ZYbtnClick:)]) {
                [LQself.delegate ZYbtnClick:LQself.arr2];
            }
            
        }
    });
}
- (IBAction)YanZhen:(UIButton *)sender {
        __weak typeof(self) LQself = self;
        if ([LQself.delegate respondsToSelector:@selector(YanZhenBtnCick)]) {
            [LQself.delegate YanZhenBtnCick];
        }
}

@end
