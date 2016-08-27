//
//  DetailView.m
//  telecom
//
//  Created by Sundear on 16/4/15.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "DetailView.h"
#import "MBProgressHUD+MJ.h"

@interface DetailView ()
/**
 *  归还按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *guihuanBtn;
/**
 *  借出和拒绝父控件
 */
@property (weak, nonatomic) IBOutlet UIView *backview;

- (IBAction)GUIHuanBtn:(id)sender;

- (IBAction)JieChuBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *wzType;
@property (weak, nonatomic) IBOutlet UILabel *wzName;
@property (weak, nonatomic) IBOutlet UILabel *wzBeiZhu;
@property (weak, nonatomic) IBOutlet UILabel *wzManger;
@property (weak, nonatomic) IBOutlet UILabel *wzCode;
@property (weak, nonatomic) IBOutlet UILabel *wzStates;
@property (weak, nonatomic) IBOutlet UILabel *buyPewrson;
@property (weak, nonatomic) IBOutlet UILabel *buyDate;
@property (weak, nonatomic) IBOutlet UILabel *Phonenumber;
@property (weak, nonatomic) IBOutlet UILabel *deparement;
@property (weak, nonatomic) IBOutlet UILabel *beizhu;
@end

@implementation DetailView
-(void)setModel:(GoodsModel *)Model{
    _Model = Model;
    self.wzType.text = Model.wzType;
    self.wzName.text = Model.wzName;
    self.wzBeiZhu.text = Model.wzRemark;
    self.wzManger.text = Model.wzManager;
    self.wzCode.text = Model.wzCode;
    self.wzStates.text = Model.wzStuats;
    DLLog(@"%@",UGET(U_USID));
   if([UGET(U_USID) isEqualToString:Model.userId]){//本账号属于物资管理员权限
       if ([Model.wzStuatsId isEqualToString:@"1"]&&[Model.wzApplyStuatsId isEqualToString:@"2"]) {
           self.guihuanBtn.hidden = NO;//显示归还按钮
           self.backview.hidden=  YES;
       }else if ([Model.wzStuatsId isEqualToString:@"3"]&&[Model.wzApplyStuatsId isEqualToString:@"1"]) {
           self.guihuanBtn.hidden = YES;//隐藏归还按钮
           self.backview.hidden=  NO;
       }else{
           self.guihuanBtn.hidden = YES;//隐藏归还按钮
           self.backview.hidden=  YES;
       }
   }else{//不是管理员
       self.guihuanBtn.hidden = YES;//归还隐藏
       self.backview.hidden=  YES;
   }
    self.buyPewrson.text = Model.borrowPerson;
    self.buyDate.text = Model.borrowDate;
    self.Phonenumber.text = Model.contactWay;
    self.deparement.text = Model.department;
    self.beizhu.text = Model.remark;
//    self.beizhu.font = [UIFont boldSystemFontOfSize:13];
    
}

- (IBAction)GUIHuanBtn:(id)sender {
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    par[URL_TYPE] = @"wzResource/WZReturn";
    par[@"resourceId"] = self.Model.resourceId;
    par[@"applyId"] = self.Model.applyId;
    httpPOST2(par, ^(id result) {
        [MBProgressHUD showSuccess:@"已归还"];
    }, ^(id result) {
        [MBProgressHUD showError:@"归还失败"];
    });
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.bolckk();
    });
}

- (IBAction)JieChuBtn:(id)sender {
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    par[URL_TYPE] = @"wzResource/WZGiving";
    par[@"resourceId"] = self.Model.resourceId;
    par[@"applyId"] = self.Model.applyId;
    httpPOST2(par, ^(id result) {
        [MBProgressHUD showSuccess:@"已借出"];
    }, ^(id result) {
        [MBProgressHUD showError:@"借出失败"];
    });
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.bolckk();
    });
    
    
}
/**
 *  拒绝按钮
 */

@end
