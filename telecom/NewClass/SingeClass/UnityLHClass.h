//
//  UnityLH.h
//  UnityLH
//  工具类
//  Created by apple on 13-5-30.
//  Copyright (c) 2013年 UnityLH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnityLHClass : NSObject

+ (UnityLHClass*)shareUnityClassObject;

//初始化系统控件
+(UILabel*)initUILabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor rect:(CGRect) rectText;

+(UILabel*)initUILabel:(NSString*)strTitle Font:(float)font Color:(UIColor*)textColor Rect:(CGRect) rectText;
+(UILabel*)initUILab:(NSString*)strTitle font:(float)font color:(UIColor*)textColor rect:(CGRect) rectText;

+(UILabel*)initLabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor color:(UIColor*)backColor rect:(CGRect)rectText radius:(float )strRadius;

+(UIButton*)initButton:(CGRect)rectButton radius:(float )strRadius;

+(UIImageView*)initUIImageView:(NSString*) imageName rect:(CGRect)rectImage;

+(UIButton*)initButton:(CGRect)rectButton str:(NSString*)strName;

+(int)getWithFromStr:(NSString*)str font:(float)font;
+ (int)getsize:(NSString *)str wid:(CGFloat)th font:(CGFloat)size;

+(void)showAlertView:(NSString*)str;

+(void)showAlertViewYORN:(NSString*)str;
+ (BOOL)isPureInt:(NSString *)string;

+ (BOOL)isPureFloat:(NSString *)string;

+ (BOOL)checkTel:(NSString *)str;

+ (BOOL) validateEmail: (NSString *) candidate;

//判断身份证是否正确
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//ios 7 以下自适应label高度
+(UILabel*)initAutomaticUILabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor rectX:(float) labelX rectY:(float)labelY rectWidth:(float)labelWid rectHeight:(float)labelHgh lines:(int)lines;
//ios 7 适配自适应label高度
+(UILabel*)initAutomaticIOS7UILabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor rectX:(float) labelX rectY:(float)labelY rectWidth:(float)labelWid rectHeight:(float)labelHgh lines:(int)lines;


+(NSString*)getCurrentTime;

+(UIImageView*)backgroundView:(CGRect)rect withStr:(NSString*)str;

+(UIImageView*)fullLineView:(CGRect)rect;  // 实线

+(UIImageView*)imaginaryLineView:(CGRect)rect;// imaginary 虚线





@end

