//
//  utils.h
//  quanzhi
//
//  Created by ZhongYun on 14-1-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

//#ifndef __OPTIMIZE__
//#define NSLOG(format, ...) NSLog(format, ## __VA_ARGS__)
//#else
//#define NSLOG(format, ...)
//#endif

#if 0
#define TEST_RGB(v, a)         v.backgroundColor = [UIColor yellowColor]; v.alpha=a
#else
#define TEST_RGB(v, a)
#endif

#define ULONG               unsigned long
#define UINT                unsigned int

#define NAV_H               44
#define TAB_H               49
#define APP_W               [UIScreen mainScreen].applicationFrame.size.width
#define APP_H               [UIScreen mainScreen].applicationFrame.size.height
#define SCREEN_W            [UIScreen mainScreen].bounds.size.width
#define SCREEN_H            [UIScreen mainScreen].bounds.size.height
#define SCREEN_S            [UIScreen mainScreen].scale
#define STATUS_H            [UIApplication sharedApplication].statusBarFrame.size.height

#define isBigScreen         (SCREEN_H > 480)

#define iOS_V               [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOSv6               (iOS_V >= 6.0)
#define iOSv7               (iOS_V >= 7.0)
#define iOSv8               (iOS_V >= 8.0)

#define TEXT_VIEW_PADDING   8

#define Font0               24
#define Font1               18
#define Font2               16
#define Font3               14
#define Font4               12

#define Font(s)             [UIFont fontWithName:@"STHeitiSC-Light" size:s]
#define FontB(s)            [UIFont fontWithName:@"STHeitiSC-Medium" size:s]
#define RECT(x,y,w,h)       CGRectMake(x,y,w,h)
#define RECT_OBJ(x,y,w,h)   NSStringFromCGRect(RECT(x,y,w,h))
#define COLOR(r,g,b)        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBRed              [UIColor redColor]
#define RGB(hex)            [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#define IMG2COLOR(x)        [UIColor colorWithPatternImage:[UIImage imageNamed:x]]
#define BTN_HIGHLIGHTED     RGB(0xf2f2f2)

#define ipath(r, s)         [NSIndexPath indexPathForRow:r inSection:s]

#define NOTIF_ADD(n, f)     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(f) name:n object:nil]
#define NOTIF_POST(n, o)    [[NSNotificationCenter defaultCenter] postNotificationName:n object:o]
#define NOTIF_REMV()        [[NSNotificationCenter defaultCenter] removeObserver:self]

#define trim(s)             [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define format(f, ...)      [NSString stringWithFormat:f, ## __VA_ARGS__]

#define NoNullKV(k,v)       (v!=nil ? k:@""):(v!=nil ? v:@"")
#define addDay(date, num)   [date dateByAddingTimeInterval:num*(24*3600)]
// ToDo: 拓展UIView通过中括号取SubView(类似NSArray, NSDictionary);


#define RELEASE(x)          {if(x){[x release]; x=nil;}}
#define mainThread(f, o)    [self performSelectorOnMainThread:@selector(f) withObject:o waitUntilDone:YES]
#define mainThreadEx(act,o) [act.target performSelectorOnMainThread:act.sel withObject:o waitUntilDone:YES]
#define tagView(v, t)       [v viewWithTag:t]
#define tagViewEx(v, t, c)  ((c*)[v viewWithTag:t])

#define DATE_FORMAT            @"yyyy-MM-dd"
#define TIME_FORMAT            @"HH:mm:ss"
#define DATE_TIME_FORMAT       @"yyyy-MM-dd HH:mm:ss"

//NSDictionaryOfVariableBindings()

#define TAG_BASE            100000
#define TAG(v)              (v>=TAG_BASE?v-TAG_BASE:v+TAG_BASE)

#define id2int(x)           [x intValue]
#define int2id(x)           [NSNumber numberWithInt:x]
#define act2id(x)           [NSValue valueWithPointer:&x]
#define id2act(x)           (*((Actor*)[x pointerValue]))
#define id2bool(x)          [x boolValue]
#define bool2id(x)          [NSNumber numberWithBool:x]
#define id2double(x)        [x doubleValue]
#define double2id(x)        [NSNumber numberWithDouble:x]
#define coordinate2id(x)    [NSValue valueWithPointer:&x]
#define id2coordinate(x)    (*((CLLocationCoordinate2D*)[x pointerValue]))
#define rect2id(x)          NSStringFromCGRect(x)
#define id2rect(x)          CGRectFromString(x)

#define NoNullStr(x)        (  ( x && (![x isEqual:[NSNull null]]) ) ? x : @""  )
#define colorByImage(x)     [UIColor colorWithPatternImage:[UIImage imageNamed:x]]
#define isNullStr(x)        ((x==nil) || [x isEqual:[NSNull null]] || (x.length==0))
#define FREE_TIMER(t)       {[t invalidate];t = nil;}


typedef struct{
    __unsafe_unretained id  target; // __unsafe_unretained for "ARC forbids Objective-C objects in struct"
    SEL sel;
} Actor;

static inline Actor ActorMake(id target, SEL sel) {
    Actor p; p.target = target; p.sel = sel; return p;
}
#define ACTOR(target, sel)    ActorMake(target, @selector(sel))

typedef void(^ResultBlock)(id result);

@interface UIButtonEx : UIButton
@property(nonatomic,retain)id info;
@end


//self.view.window for all view;
void dumpView(UIView* aView);

void showAlert(id msg);

void showLoading(NSString* text);
void hideLoading();
UIWindow* getWindow();

UIImage* view2image(UIView* view);
UIViewController* getViewController(UIView* view);
CALayer* getLayer(UIView* view, NSString* name);

NSString* date2str(NSDate* date, NSString* dateFormat);
NSDate* str2date(NSString* strDate, NSString* dateFormat);

void udefaultSet(NSString* name, NSString* value);
NSString* udefaultGet(NSString* name);

void showShadow(UIView* view, CGSize size);
void maskBorderLayer(UIView* view, UIRectCorner corners, CGSize radii, UIColor* border, UIColor* fill); //边框蒙版

int charNumber(NSString* txt);
NSString* stringByByteLength(NSString* txt, int byteCount);

BOOL addSkipBackupAttributeToItemAtURL(NSString* path);

UIColor* getColor(UIImage* image, int x, int y);

BOOL isPhoneNumber(NSString* text);
BOOL isEmailAddress(NSString* text);

NSString* unicode2zh(NSString* unicodeStr);
NSString* id2json(id data);

void updateTableWithoutReload(UITableView* table);

UIImage* color2Image(UIColor* color);

CGFloat getTextHeight(NSString* text, UIFont* font, CGFloat width);
CGSize getTextSize(NSString* text, UIFont* font, CGFloat width);
NSAttributedString* getLineSpaceStr(NSString* text, CGFloat lineSpace);

UIView* getParentView(UIView* view, Class parentClass);
#define parentView(v, className) (className*)getParentView(v, [className class])
UITableViewCell* parentCell(UIView* view);
NSIndexPath* parentCellIndexPath(UIView* view);


NSString* getMonthFirstDay(NSDate* theDate);
NSString* getMonthLastDay(NSDate* theDate);

int device_SignalLevel();
NSString* device_IMSI();
NSString* device_IMSI_01();
NSString* device_PhoneNum();