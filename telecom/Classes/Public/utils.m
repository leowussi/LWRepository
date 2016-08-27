//
//  utils.m
//  quanzhi
//
//  Created by ZhongYun on 14-1-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "utils.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/xattr.h>
#import <dlfcn.h>
#import "defines.h"
#import "MBProgressHUD.h"

@implementation UIButtonEx
@end

void getViews(UIView* aView, int indent, NSMutableString* outString)
{
    for (int i = 0; i < indent; i++) {
        [outString appendString:@"--"];
    }
    
    //if (!aView.hidden)
    {
        //[outString appendFormat:@"[%d] %@\n", indent, [[aView class] description]];
        [outString appendFormat:@"[%d] %@ %@ (%d)\n", indent, [[aView class] description],
         NSStringFromCGRect(aView.frame), aView.tag];
    }
    
    
    
    for (UIView *view in [aView subviews]) {
        getViews(view, indent+1, outString);
    }
}

void dumpView(UIView* aView)
{
    NSMutableString *outString = [[NSMutableString alloc] init];
    getViews(aView, 0, outString);
    CFShow(outString);
    [outString release];
}

void showAlert(id msg)
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[NSString stringWithFormat:@"%@", msg]
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

void showLoading(NSString* text)
{
    //和UIAlertView并用时，keyWindow是UIModalItemHostingWindow类型;
    UIWindow* win = nil; //[UIApplication sharedApplication].keyWindow;
    for (id tmp in [UIApplication sharedApplication].windows) {
        if ([tmp class] == [UIWindow class]) {
            win = tmp;
            break;
        }
    }
    
    UIView* m_waiting = [win viewWithTag:11887];
    if (!m_waiting) {
        m_waiting = [[UIView alloc] initWithFrame:RECT(0, 0, SCREEN_W, SCREEN_H)];
        m_waiting.tag = 11887;
        [win addSubview:m_waiting];
//        UIView* blackbg = [[UIView alloc] initWithFrame:m_waiting.bounds];
//        blackbg.backgroundColor = [UIColor blackColor];
//        blackbg.alpha = 0.3;
//        [m_waiting addSubview:blackbg];
//        [blackbg release];
        
        MBProgressHUD* progressHud = [[MBProgressHUD alloc] initWithFrame:CGRectMake((kScreenWidth-180)*0.5, (SCREEN_H-100)*0.5, 180, 100)];
        progressHud.tag = 11888;
        [m_waiting addSubview:progressHud];
        [progressHud release];
    }
    MBProgressHUD* progressHud = (MBProgressHUD*)[m_waiting viewWithTag:11888];
    progressHud.labelText = text;
    [progressHud show:YES];
}

void hideLoading()
{
    UIWindow* win = nil; //[UIApplication sharedApplication].keyWindow;
    for (id tmp in [UIApplication sharedApplication].windows) {
        if ([tmp class] == [UIWindow class]) {
            win = tmp;
            break;
        }
    }
    
    UIView* tagView = [win viewWithTag:11887];
    [tagView removeFromSuperview];
    [MBProgressHUD hideHUDForView:win animated:YES];
}

UIWindow* getWindow()
{
    UIWindow* win = nil; //[UIApplication sharedApplication].keyWindow;
    for (id tmp in [UIApplication sharedApplication].windows) {
        if ([tmp class] == [UIWindow class]) {
            win = tmp;
            break;
        }
    }
    return win;
}

UIImage* view2image(UIView* view)
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

UIViewController* getViewController(UIView* view)
{
    UIView* superView = view;
    while (superView)
    {
        UIResponder *nextResponder = [superView nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController *)nextResponder;
        else
            superView = superView.superview;
    }
    return nil;
}

CALayer* getLayer(UIView* view, NSString* name)
{
    for (int i = 0; i < view.layer.sublayers.count; i++) {
        CALayer* layer = (CALayer*)[view.layer.sublayers objectAtIndex:i];
        if ([layer.name isEqualToString:name]) {
            return layer;
        }
    }
    return nil;
}

NSString* date2str(NSDate* date, NSString* dateFormat)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:dateFormat];
    NSString* strDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    [locale release];
    return strDate;
}

NSDate* str2date(NSString* strDate, NSString* dateFormat)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
     NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *resdate = [dateFormatter dateFromString:strDate];
    [dateFormatter release];
    [locale release];
    return resdate;
}

void udefaultSet(NSString* name, NSString* value)
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

NSString* udefaultGet(NSString* name)
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:name];
}

void showShadow(UIView* view, CGSize size)
{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = size;
    view.layer.shadowOpacity = 0.4;
    view.layer.shadowRadius = 1;
}

void maskBorderLayer(UIView* view, UIRectCorner corners, CGSize radii, UIColor* border, UIColor* fill)
{
    //UIRectCorner corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                     byRoundingCorners:corners
                                                           cornerRadii:radii];
    //蒙版
    //CAShapeLayer *maskLayer = [CAShapeLayer layer];
    //maskLayer.path = [bezierPath CGPath];
    //maskLayer.fillColor = [[UIColor whiteColor] CGColor];
    //maskLayer.frame = tmpView.frame;
    //tmpView.layer.mask = maskLayer;
    
    //边框蒙版
    CAShapeLayer *maskBorderLayer = (CAShapeLayer*)getLayer(view, @"mask");
    if (!maskBorderLayer) {
        maskBorderLayer = [CAShapeLayer layer];
        maskBorderLayer.name = @"mask";
        [view.layer addSublayer:maskBorderLayer];
    }
    maskBorderLayer.path = [bezierPath CGPath];
    maskBorderLayer.fillColor = fill.CGColor; //填充色
    maskBorderLayer.strokeColor = border.CGColor;//边框色
    maskBorderLayer.lineWidth = 0.5; //边框宽度
}

int charNumber(NSString* txt)
{
    int strlength = 0;
    char* p = (char*)[txt cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[txt lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

NSString* stringByByteLength(NSString* txt, int byteCount)
{
    NSInteger txtCharNum = charNumber(txt);
    if (txtCharNum <= byteCount) {
        return txt;
    }
    NSInteger num = (txt.length<byteCount ? txt.length:byteCount);

    NSString* resStr = [txt substringToIndex:num];
    txtCharNum = charNumber(resStr);
    while (txtCharNum > byteCount) {
        num--;
        resStr = [txt substringToIndex:num];
        txtCharNum = charNumber(resStr);
    }
    
    return  format(@"%@...", resStr);
}

BOOL addSkipBackupAttributeToItemAtURL(NSString* path)
{
    if (![[NSFileManager defaultManager] fileExistsAtPath: path]) {
        return NO;
    }
    
    if (&NSURLIsExcludedFromBackupKey == nil) { // iOS <= 5.0.1
        const char* filePath = [path fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else { // iOS >= 5.1
        NSError *error = nil;
        NSURL* url = [NSURL fileURLWithPath:path];
        [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        return error == nil;
        
    }
}

UIColor* getColor(UIImage* image, int x, int y)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = image.CGImage;
    CGFloat width =  CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,        //每个颜色值8bit
                                                  width*4, //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit
                                                  colorSpace,
                                                  (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    unsigned char *imgdata = CGBitmapContextGetData(context);
    UIColor* resColor = COLOR(imgdata[1], imgdata[2], imgdata[3]);
    CGContextRelease(context);
    CGColorSpaceRelease( colorSpace );
    
    return resColor;    
}


BOOL isPhoneNumber(NSString* text)
{
    NSString *regex = @"[0-9]{11}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:text]) {
        return YES;
    }
    return NO;
}

BOOL isEmailAddress(NSString* text)
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:text]) {
        return YES;
    }
    return NO;
}

NSString* unicode2zh(NSString* unicodeStr)
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


NSString* id2json(id data)
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length]==0 || error)
        return @"";
    
    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return result;
}

void updateTableWithoutReload(UITableView* table)
{
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [table beginUpdates];
    [table endUpdates];
    [UIView setAnimationsEnabled:animationsEnabled];
}

UIImage* color2Image(UIColor* color)
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



CGFloat getTextHeight(NSString* text, UIFont* font, CGFloat width)
{
    UILabel* label = [[UILabel alloc] initWithFrame:RECT(0, 0, width, 5000)];
    label.font = font;
    label.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    label.numberOfLines = 0;
    label.text = text;
    [label sizeToFit];
    CGFloat h = label.frame.size.height;
    [label release];
    return h;
}

CGSize getTextSize(NSString* text, UIFont* font, CGFloat width)
{
    UILabel* label = [[UILabel alloc] initWithFrame:RECT(0, 0, width, 5000)];
    label.font = font;
    label.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    label.numberOfLines = 0;
    label.text = text;
    [label sizeToFit];
    CGSize size = label.frame.size;
    [label release];
    return size;
}

NSAttributedString* getLineSpaceStr(NSString* text, CGFloat lineSpace)
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [paragraphStyle release];
    return attributedString;
}

UIView* getParentView(UIView* view, Class parentClass)
{
    UIView* superView = view;
    while ( superView!=nil ) {
        if ( [superView isKindOfClass:parentClass] ) {
            return (UIView*)superView;
        }
        superView = superView.superview;
    }
    return nil;
}

UITableViewCell* parentCell(UIView* view)
{
    return parentView(view, UITableViewCell);
}

NSIndexPath* parentCellIndexPath(UIView* view)
{
    UITableViewCell* cell = parentView(view, UITableViewCell);
    if (cell) {
        UITableView* table = parentView(cell, UITableView);
        if (table) {
            return [table indexPathForCell:cell];
        }
    }
    return nil;
}

NSString* getMonthFirstDay(NSDate* theDate)
{
    return date2str(theDate, @"yyyy-MM-01");
}

NSString* getMonthLastDay(NSDate* theDate)
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:+1];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:theDate options:0];

    NSString* firstStr = date2str(newdate, @"yyyy-MM-01");
    NSDate* firstDay = str2date(firstStr, DATE_FORMAT);
    NSDate* currLastDay = [firstDay dateByAddingTimeInterval:-24*3600];
    [calendar release];
    [adcomps release];
    return date2str(currLastDay, DATE_FORMAT);
}


#if 0
//iOS5之前的系统
#define PRIVATE_PATH    "/System/Library/PrivateFrameworks/CoreTelephony.framework/CoreTelephony"
#else
//iOS5之后的系统
#define PRIVATE_PATH    "/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony"
#endif

int device_SignalLevel()
{
    void *libHandle = dlopen(PRIVATE_PATH, RTLD_LAZY);//获取库句柄
    int (*pfunc)() = (int(*)())dlsym(libHandle, "CTGetSignalStrength"); //获取指定名称的函数
    
    int level = -1;
    if(pfunc != NULL) {
        level = pfunc() - 113;
    }
    dlclose(libHandle); //关闭库
    return level;
}

NSString* device_IMSI()
{
    void *libHandle = dlopen(PRIVATE_PATH, RTLD_LAZY);
    int (*pfunc)() = dlsym(libHandle, "CTSIMSupportCopyMobileSubscriberIdentity");

    NSString* imsiString = @"";
    if(pfunc != NULL) {
        imsiString = (NSString*)pfunc(nil);
    }
    dlclose(libHandle);
    
    return imsiString;
}

NSString* device_IMSI_01()
{
    NSString *ret = [[NSString alloc]init];
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    [info release];
    if (carrier == nil) {
        return @"0";
    }
    NSString *code = [carrier mobileNetworkCode];
    if ([code isEqual:@""]) {
        return @"0";
    }
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        ret = @"中国移动";
    }
    if ([code isEqualToString:@"01"]|| [code isEqualToString:@"06"] ) {
        ret = @"中国联通";
    }
    if ([code isEqualToString:@"03"]|| [code isEqualToString:@"05"] ) {
        ret = @"中国电信";;
    }
    
    return ret;
}

NSString* device_PhoneNum()
{
    NSString *num = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    return num;
}
