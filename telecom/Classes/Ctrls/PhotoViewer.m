//
//  PhotoViewer.m
//  telecom
//
//  Created by ZhongYun on 15-4-7.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "PhotoViewer.h"
#import "UIImageView+WebCache.h"

@interface PhotoViewer ()
@property (nonatomic,retain)NSDictionary* imgInfo;
@end

@implementation PhotoViewer

- (void)dealloc
{
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:RECT(0, 0, SCREEN_W, SCREEN_H)];
    
    
    if ([self.imgInfo[@"path"] rangeOfString:@"http"].location == NSNotFound) {
        imageView.image = [UIImage imageWithContentsOfFile:self.imgInfo[@"path"]];
    } else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imgInfo[@"path"]]
                     placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
    imageView.tag = 1001;
    imageView.backgroundColor = [UIColor blackColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView release];
    
    UIView* bottom_bg = [[UIView alloc] initWithFrame:RECT(0, SCREEN_H-NAV_H, APP_W, NAV_H)];
    bottom_bg.tag = 1002;
    bottom_bg.backgroundColor = [UIColor blackColor];
    bottom_bg.alpha = 0.3;
    [self.view addSubview:bottom_bg];
    [bottom_bg release];
    
    UIImage* leftPic = [UIImage imageNamed:@"arrow_left.png"];
    UIButton* btnIcon = [[UIButton alloc] initWithFrame:RECT(0+10, SCREEN_H-NAV_H, leftPic.size.width, NAV_H)];
    btnIcon.tag = 1003;
    [btnIcon setBackgroundImage:leftPic forState:0];
    [btnIcon addTarget:self action:@selector(onNavBtnBackTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnIcon];
    [btnIcon release];
    
    UIImage* delPic = [UIImage imageNamed:@"nav_del.png"];
    UIButton* btnDel = [[UIButton alloc] initWithFrame:RECT(SCREEN_W-delPic.size.width-10, SCREEN_H-delPic.size.height, delPic.size.width, delPic.size.height)];
    btnDel.tag = 1004;
    [btnDel setBackgroundImage:delPic forState:0];
    [btnDel addTarget:self action:@selector(onNavBtnDelTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDel];
    [btnDel release];
}

- (void)onNavBtnBackTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onNavBtnDelTouched:(id)sender
{
    NOTIF_POST(DEL_SELECTED_PHOTO, self.imgInfo);
    [self.navigationController popViewControllerAnimated:YES];
}

+ (void)showPhoto:(id)imgInfo Parent:(UIViewController*)parentVC
{
    PhotoViewer* vc = [[PhotoViewer alloc] init];
    vc.imgInfo = imgInfo;
    [parentVC.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIImage* leftPic = [UIImage imageNamed:@"arrow_left.png"];
    UIImage* delPic = [UIImage imageNamed:@"nav_del.png"];
    
    tagView(self.view, 1001).frame = RECT(0, 0, SCREEN_W, SCREEN_H);
    tagView(self.view, 1002).frame = RECT(0, SCREEN_H-NAV_H, APP_W, NAV_H);
    tagView(self.view, 1003).frame = RECT(0+10, SCREEN_H-NAV_H, leftPic.size.width, NAV_H);
    tagView(self.view, 1004).frame = RECT(SCREEN_W-delPic.size.width-10, SCREEN_H-delPic.size.height, delPic.size.width, delPic.size.height);
}


@end
