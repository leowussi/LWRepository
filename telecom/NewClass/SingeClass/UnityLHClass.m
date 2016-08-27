//
//  UnityLH.m
//  UnityLH
//
//  Created by apple on 13-5-30.
//  Copyright (c) 2013年 UnityLH. All rights reserved.
//

#import "UnityLHClass.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation UnityLHClass
static UnityLHClass *unityObject = nil;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (UnityLHClass*)shareUnityClassObject
{
    if (unityObject == nil) {
        unityObject = [[UnityLHClass alloc] init];
    }
    return unityObject;
}

#pragma mark -系统控件的初始化
+(UILabel*)initUILabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor rect:(CGRect) rectText
{
    UILabel* label = [[UILabel alloc] initWithFrame:rectText];
    label.text = strTitle;
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:font];
    
    return label;
}
+(UILabel*)initUILabel:(NSString*)strTitle Font:(float)font Color:(UIColor*)textColor Rect:(CGRect) rectText
{
    UILabel* label = [[UILabel alloc] initWithFrame:rectText];
    label.text = strTitle;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:font];
    return label;
}


+(UILabel*)initUILab:(NSString*)strTitle font:(float)font color:(UIColor*)textColor rect:(CGRect) rectText
{
    UILabel* label = [[UILabel alloc] initWithFrame:rectText];
    label.text = strTitle;
    label.textColor = textColor;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
    return label;
    
}

+(UILabel*)initLabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor color:(UIColor*)backColor rect:(CGRect)rectText radius:(float )strRadius
{
    UILabel* label = [[UILabel alloc] initWithFrame:rectText];
    label.text = strTitle;
    label.textColor = textColor;
    label.backgroundColor = backColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = strRadius;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
    return label;
}

+(UIButton*)initButton:(CGRect)rectButton radius:(float )strRadius
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rectButton];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = strRadius;
    return button;
}

//ios 7 以下版本自适应高度
+(UILabel*)initAutomaticUILabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor rectX:(float) labelX rectY:(float)labelY rectWidth:(float)labelWid rectHeight:(float)labelHgh lines:(int)lines
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = strTitle;
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:font];
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(labelWid, labelHgh) lineBreakMode:NSLineBreakByWordWrapping];
    label.numberOfLines = lines;
    label.frame = CGRectMake(labelX, labelY, size.width, size.height);
    return label;
}
//ios 7 适配自适应高度
+(UILabel*)initAutomaticIOS7UILabel:(NSString*)strTitle font:(float)font color:(UIColor*)textColor rectX:(float) labelX rectY:(float)labelY rectWidth:(float)labelWid rectHeight:(float)labelHgh lines:(int)lines
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = strTitle;
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:font];
    label.numberOfLines = lines;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    //labelHgh 高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize size =CGSizeMake(labelWid,labelHgh);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName,nil];
    CGSize actualsize =[strTitle boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    label.frame = CGRectMake(labelX, labelY, actualsize.width, actualsize.height);
    return label;
}


+(UIImageView*)initUIImageView:(NSString*) imageName rect:(CGRect)rectImage
{
    UIImageView*  imageView = [[UIImageView alloc] initWithFrame:rectImage];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}
+(UIButton*)initButton:(CGRect)rectButton str:(NSString *)strName
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rectButton];
    [button setBackgroundImage:[UIImage imageNamed:strName] forState:UIControlStateNormal];
    return button;
}
#pragma mark 弹出提示框
+(void)showAlertView:(NSString*)str
{
    UIAlertView* alertDlg = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertDlg show];
}
#pragma mark 弹出提示框 YES+NO
+(void)showAlertViewYORN:(NSString*)str
{
    UIAlertView* alertDlg = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertDlg show];
}

//获取字符串的宽度
+(int)getWithFromStr:(NSString*)str font:(float)font
{
    CGSize titleSize = [str sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    return titleSize.width;
}
//根据字符串的宽度获取size
+ (int)getsize:(NSString *)str wid:(CGFloat)th font:(CGFloat)size
{
    CGSize constraint = CGSizeMake(th, 20000.0f);
    CGSize sizeStr = [str sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return sizeStr.height;
}

//判断是否是整形
+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否是浮点型
+ (BOOL)isPureFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否是手机号码是否合法
+ (BOOL)checkTel:(NSString *)str
{
    
    //1[0-9]{10}
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    //    NSString *regex = @"[0-9]{11}";
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}
//判断邮箱地址是否合法
+ (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

//判断身份证号码是否正确
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark －获取当前系统的时间
+(NSString*)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

+(UIImageView*)backgroundView:(CGRect)rect withStr:(NSString*)str
{
    UIImageView* image = [[UIImageView alloc]initWithFrame:rect];
    [image setImage:[UIImage imageNamed:str]];
    
    
    return image;
}

+(UIImageView*)fullLineView:(CGRect)rect   // 实线
{
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"03-02-line-cuxian.png"]];
    return imageView;
}

+(UIImageView*)imaginaryLineView:(CGRect)rect
{
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"03-0201-line-xuxian.png"]];
    return imageView;
    
}

@end
