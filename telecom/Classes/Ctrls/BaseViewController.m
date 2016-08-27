//
//  BaseViewController.m
//  telecom
//
//  Created by ZhongYun on 14-6-11.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
@interface BaseViewController ()
@end

@implementation BaseViewController

- (void)dealloc
{
    [_navBarView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
//                                                                    UITextAttributeFont : [UIFont systemFontOfSize:15]};
    self.view.backgroundColor = COLOR(248, 248, 248);

    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                                                    UITextAttributeFont : [UIFont fontWithName:@"Helvetica-Bold" size:15.0]};
    
    
    [self addNavigationLeftButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    tagViewEx(self.view, TAG_NAV_TITLE, UILabel).text = NoNullStr(self.title);
}
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIImageView *imageView = [UnityLHClass initUIImageView:@"back_btn" rect:CGRectMake(0, 7,navImg.size.width/1,navImg.size.height/1)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,44,44);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:imageView];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [leftButtonItem release];
}

-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hiddenBottomBar:(BOOL)hide
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CGRect rect = delegate.bottomBarView.frame;
    rect.origin.y = hide ? kScreenHeight : kScreenHeight - 49;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        rect.origin.y = rect.origin.y - 20;
    }
    
    [UIView animateWithDuration:0.1f animations:^(void) {
        delegate.bottomBarView.frame = rect;
    } completion:^(BOOL finished) {
    }];
}


- (void)onNavBackTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addIconTitleBtn
{
    UIImage* leftPic = [UIImage imageNamed:@"arrow_left.png"];
    UIButton* btnIcon = [[UIButton alloc] initWithFrame:RECT(0, 0, leftPic.size.width, NAV_H)];
    btnIcon.tag = TAG_NAV_LEFT;
    [btnIcon setBackgroundImage:leftPic forState:0];
    [btnIcon addTarget:self action:@selector(onNavBackTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView insertSubview:btnIcon atIndex:0];
    [btnIcon release];
    
    CGFloat x = btnIcon.fw;
    CGFloat ts = Font2;
    newLabel(self.navBarView, @[@(TAG_NAV_TITLE), RECT_OBJ(x, (self.navBarView.fh-ts)/2, (APP_W-x*2), ts), [UIColor whiteColor], FontB(ts), @""]).textAlignment = NSTextAlignmentCenter;
}

- (void)popToRootViewController
{
    NSArray* viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1) {
        UIViewController* vc = (UIViewController*)[viewControllers lastObject];
        [vc.navigationController popToRootViewControllerAnimated:YES];
    }
}

//- (void)addIconTitleBtn
//{
//    CGFloat titleWidth = getTextSize(self.title, FontB(Font2), APP_W).width;
//    CGFloat iconWidth = 30;
//    CGFloat btnWidth = 3 + iconWidth + 5 + titleWidth + 3;
//    
//    UIButton* btnIcon = [[UIButton alloc] initWithFrame:RECT(7, 0, btnWidth, NAV_H)];
//    //[btnIcon setBackgroundImage:color2Image(APP_COLOR) forState:0];
//    [btnIcon addTarget:self action:@selector(onBtnIconTouched:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navBarView insertSubview:btnIcon atIndex:0];
//    
//    UIImageView* iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"i_icon.png"]];
//    iconImg.frame = RECT(3, (btnIcon.fh-iconWidth)/2, iconWidth, iconWidth);
//    [btnIcon addSubview:iconImg];
//    [iconImg release];
//    
//    NSString* title = NoNullStr(self.title);
//    newLabel(btnIcon, @[@(TAG_TITLE), RECT_OBJ(iconImg.ex+5, (btnIcon.fh-Font2)/2, titleWidth, Font2), [UIColor whiteColor], FontB(Font2), title]);
//
//    [btnIcon release];
//}

// 是否支持屏幕旋转
- (BOOL)shouldAutorotate {
    return NO;
}
// 支持的旋转方向
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//UIInterfaceOrientationMaskAllButUpsideDown;
}


@end
