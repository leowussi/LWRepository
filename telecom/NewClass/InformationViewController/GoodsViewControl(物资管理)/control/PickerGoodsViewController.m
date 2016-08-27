//
//  PickerGoodsViewController.m
//  telecom
//
//  Created by Sundear on 16/4/18.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "PickerGoodsViewController.h"
#import "GoodsModel.h"
#import "MBProgressHUD+MJ.h"
#import "HWBProgressHUD.h"
#import "RootTAMViewController.h"
#import "RightViewController.h"
#import "LayerBtn.h"
#import "IQKeyboardManager.h"
@interface PickerGoodsViewController ()<UITextFieldDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *beizhu;
@property (weak, nonatomic) IBOutlet UILabel *manger;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *ststes;
@property (weak, nonatomic) IBOutlet UILabel *person;
@property (weak, nonatomic) IBOutlet UIButton *dateField;
@property (weak, nonatomic) IBOutlet UILabel *departMent;
@property (weak, nonatomic) IBOutlet UITextField *reMaek;
@property (weak, nonatomic) IBOutlet LayerBtn *commintBtn;
@property (weak, nonatomic) IBOutlet LayerBtn *guihuan;

@property(nonatomic,assign)BOOL tempBool;
@property(nonatomic,assign)BOOL commitBool;
@property(nonatomic,strong)NSString *tempStr;
@property (weak, nonatomic) IBOutlet UITextField *phone;

- (IBAction)commit:(id)sender;
- (IBAction)guihuan:(id)sender;

@end

@implementation PickerGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"物资申请";
    [self.view insertSubview:_baseScrollView atIndex:0];
    [self settitleWith:self.model];
    self.reMaek.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBegFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillEndFrame:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillBegFrame:(NSNotification *)note{
    if (!self.tempBool) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.25f];
        [UIView setAnimationCurve:7];
        if (kScreenHeight <= 480) {
            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -180);
        }else{
            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -80);
        }
        self.tempBool=YES;
        [UIView commitAnimations];
    }
   
}

-(void)keyboardWillEndFrame:(NSNotification *)note{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25f];
    [UIView setAnimationCurve:7];
    self.view.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
    self.tempBool = NO;
}

-(void)settitleWith:(GoodsModel *)model{
    if ([model.wzStuats isEqualToString:@"已借出"] ) {
        self.commintBtn.hidden=YES;

        [self.dateField setTitle:model.borrowDate forState:UIControlStateNormal];
        self.reMaek.text = model.remark;
        self.reMaek.userInteractionEnabled = NO;
        self.reMaek.borderStyle = UITextBorderStyleNone;
    }else{//未借出状态
        self.commintBtn.hidden=NO;
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        DLLog(@"%@",currentDateStr);
        [self.dateField setTitle:currentDateStr forState:UIControlStateNormal];
//        self.dateField.titleLabel.text = currentDateStr;

    }
    self.type.text = model.wzType;
    self.name.text = model.wzName;
    self.beizhu.text = model.wzRemark;
    self.manger.text = model.wzManager;
    self.number.text = model.wzCode;
    self.ststes.text = model.wzStuats;
    self.person.text = model.borrowPerson;
    self.phone.text = model.contactWay;
    self.departMent.text = model.department;
    
    
    if([UGET(U_USID) isEqualToString:model.userId]){//本账号属于物资管理员权限
        if ([model.wzStuatsId isEqualToString:@"1"]&&[model.wzApplyStuatsId isEqualToString:@"2"]) {
            self.guihuan.hidden = NO;//显示归还按钮
            self.commintBtn.hidden=  YES;
        }else {
            self.guihuan.hidden = YES;//显示归还按钮
            self.commintBtn.hidden= NO;
        }
    }
}


/**
 *  接口地址：	wzResource/AddWZApplyInfo.json
 接口说明：	申请物资
 入参
 accessToken	String
 operationTime	String
 resourceId	Integer
 remark	String
 */

- (IBAction)commit:(id)sender {
   
    if (self.commitBool) {
        HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
        //弹出框的类型
        hud.mode = HWBProgressHUDModeText;
        //弹出框上的文字
        hud.detailsLabelText = @"您已提交过申请，请等待管理员审核";
        //弹出框的动画效果及时间
        [hud showAnimated:YES whileExecutingBlock:^{
            //执行请求，完成
            sleep(1);
        } completionBlock:^{
            //完成后如何操作，让弹出框消失掉
            [hud removeFromSuperview];
        }];
    }else{
       
        if (![self validateMobile:_phone.text]) {
            [self showAlertWithTitle:@"提示" :@"手机号格式不正确" :@"确定" :nil];
            return;
        }
        
        NSMutableDictionary *par = [NSMutableDictionary dictionary];
        par[URL_TYPE] = @"wzResource/AddWZApplyInfo";
        par[@"resourceId"] = @(self.model.resourceId.intValue);
        par[@"remark"] = self.tempStr;
        par[@"contact"] = self.phone.text;
        httpPOSTAFN(par, ^(id result) {
            [MBProgressHUD showSuccess:@"申请成功，等待管理员批准"];
            self.commitBool=YES;
        }, ^(id result) {
            [MBProgressHUD showError:@"申请失败"];
            self.commitBool=NO;
        }, ^(id result) {
            
        });
        
    }
    
}

- (IBAction)guihuan:(id)sender {
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    par[URL_TYPE] = @"wzResource/WZReturn";
    par[@"resourceId"] = self.model.resourceId;
    par[@"applyId"] = self.model.applyId;
    httpPOSTAFN(par, ^(id result) {
        [MBProgressHUD showSuccess:@"归还成功"];
    }, ^(id result) {
        [MBProgressHUD showSuccess:@"归还失败"];
    }, ^(id result) {
        
    });
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 108) {
        return;
    }
    self.tempStr = textField.text;
}

-(void)leftAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
