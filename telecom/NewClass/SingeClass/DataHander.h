//
//  DataHander.h
//  CaCaXian
//
//  Created by Nancy on 13-4-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>	
#import "MBProgressHUD.h"
	
@interface DataHander : NSObject
{
    MBProgressHUD* mbProgressHud;
}
@property(nonatomic,strong)NSString *strResgistureUser;//注册的账号记录
@property(nonatomic,strong)NSString* strUser;       //登陆账号
@property(nonatomic,strong)NSString* strPassd;      //登录密码
@property(nonatomic,strong)NSString* userID;        //用户ID
@property(nonatomic,strong)NSString* userName;      //用户名
@property(nonatomic,strong)NSString* CouponValue;   //用户所拥有的代金券
@property(nonatomic,strong)NSString* imgUrl;        //用户头像
@property(nonatomic,strong)NSData *imageData;
@property(nonatomic,assign)bool mesFlag;//是否有未读的站内消息
@property(nonatomic,strong)UIButton *myButton;//指向tabbar我的按钮
@property(nonatomic,assign)bool fashFre;//如为yes 则刷新界面，否则无新评论，不刷新。专栏。



+(DataHander *)sharedDataHander;

-(void)showDlg;
-(void)hideDlg;

////取消请求
//-(void)cancelRequest;
@end
