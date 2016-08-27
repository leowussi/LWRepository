//
//  SXABaseViewController.h
//  ShanXiApple
//
//  Created by chenliang on 14-1-8.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseScrollView.h"
#import "fashion.h"
#import "AppDelegate.h"
#import "UnityLHClass.h"
#import "BMRequestManager.h"

@interface SXABaseViewController : UIViewController
{
    BaseScrollView *_baseScrollView;
}
@property(nonatomic,strong)UIButton *backBtn;
@property (nonatomic , assign) BOOL    isStoreImg;

//添加title
-(void)addMessageAndSaoSao:(NSString *)str;
-(void)addTitle :(NSString *)str;
-(void)addMiddleTitle :(NSString *)str;
-(void)addLeftTitle :(NSString *)str;
-(void)addNavTitle :(NSString *)str;
-(void)addLeftNavTitle :(NSString *)str;
-(void)addMiddleImageView;
-(void)addLeftMiddleImageView;
//添加左边按钮
- (void)addNavigationLeftButton;
- (void)addNavigationLeftButton:(NSString *)str;
-(void)addNavLeftButton:(NSString *)str;
- (void)addNavigationRightButton:(NSString *)str;
- (void)addNavigationRightButtonForStr:(NSString *)str;
- (void)addNavigationRightButtonForStr:(NSString *)str WithImage:(NSString *)imageName;
-(void)addSearchBar;
-(void)addLeftSearchBar;
- (void)addMidSearchBar;


-(void)SetSearchBarWithPlachTitle:(NSString *)str;
/**
 *  添加搜索框
 */
-(UIView *)SetsSearchBarWithPlachTitle:(NSString *)str;
/**
 *  搜索框搜索内容交给之类实现
 */
-(void)searchBtn;
/**
 *  添加导航栏上的搜索框
 */
-(UIView *)addSearchBarWithTitle:(NSString *)string;
/**
 *  搜索框搜索内容交给之类实现
 */
-(void)searchAction:(NSString *)string;
//左边按钮点击事件
- (void)leftAction;
- (void)rightAction;
- (void)hiddenBottomBar:(BOOL)hide;
//自适应(UILabel)高度
- (float)heightForCellWithWid:(NSString *)str width:(float)wid;

- (float)AutomaticIOS7UILabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor  rectWidth:(float)labelWid rectHeight:(float)labelHgh lines:(int)lines;

// 背景图
- (void)backViewcolour;

- (BOOL)validateMobile:(NSString *)mobileNum;
-(BOOL)isValidateEmail:(NSString *)email;

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;


// 自适应UILabel的高
- (CGSize)labelHight:(NSString*)str withSize:(CGFloat)newFloat withWide:(CGFloat)newWide;

- (CGSize)labelHight:(NSString*)str;

-(void)navigl:(NSString *)str;

// 获取手机IP
- (NSString *)getIPAddress;

//检测设备类型
- (NSString *) platformString;

-(void)showAlertWithTitle:(NSString *)title :(NSString *)messageStr :(NSString *)cancelBtn :(NSString *)otherBtn ;
@end
