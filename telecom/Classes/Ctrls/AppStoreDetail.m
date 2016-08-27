//
//  AppStoreDetail.m
//  telecom
//
//  Created by ZhongYun on 14-8-5.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "AppStoreDetail.h"
#import "UIImageView+WebCache.h"

@interface AppStoreDetail ()

@end

@implementation AppStoreDetail

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"子应用详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView* webImage = [[UIImageView alloc] initWithFrame:RECT(15, self.navBarView.ey+10, 60, 60)];
    webImage.backgroundColor = [UIColor clearColor];
    
    NSString* imgURL = format(@"http://%@/%@/%@", ADDR_IP, ADDR_DIR, self.dataRow[@"imgUrl"]);
    [webImage sd_setImageWithURL:[NSURL URLWithString:imgURL]
                placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    webImage.clipsToBounds = YES;
    webImage.tag = 50;
    [self.view addSubview:webImage];
    [webImage release];
    
    CGFloat pos_x = tagView(self.view, 50).ex+10;
    newLabel(self.view, @[@51, RECT_OBJ(pos_x, tagView(self.view, 50).fy+4, APP_W-pos_x-10, Font2), [UIColor blackColor], FontB(Font2), NoNullStr(self.dataRow[@"appName"])]);
    
    CGFloat pos_y = tagView(self.view, 51).ey+8;
    newLabel(self.view, @[@52, RECT_OBJ(pos_x, pos_y, APP_W-pos_x-10, Font4), [UIColor darkGrayColor], Font(Font4), format(@"版本号：v%@", NoNullStr(self.dataRow[@"currentVersion"]))]);
    
    pos_y = tagView(self.view, 52).ey+8;
    newLabel(self.view, @[@53, RECT_OBJ(pos_x, pos_y, APP_W-pos_x-10, Font4), [UIColor darkGrayColor], Font(Font4), format(@"发布时间：%@", NoNullStr(self.dataRow[@"releaseDate"]))]);
    
    pos_y = tagView(self.view, 53).ey+15;
    UILabel* desc = newLabel(self.view, @[@54, RECT_OBJ(15, pos_y, APP_W-15-10, Font3*20), [UIColor darkGrayColor], Font(Font3), format(@"版本描述：\n%@", NoNullStr(self.dataRow[@"releaseNote"]))]);
    desc.attributedText = getLineSpaceStr(desc.text, 5);
    [desc sizeToFit];
    
    CGFloat btn_w = 70, btn_h = 30;
    UIButton* btn = [[UIButton alloc] initWithFrame:RECT(APP_W-btn_w-15, tagView(self.view, 50).fy+10, btn_w, btn_h)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = RGB(0x007aff).CGColor;
    btn.layer.cornerRadius = 3;
    btn.titleLabel.font = Font(Font4);
    
    NSString* btnTitle = @"下载";
    if ([self.dataRow[V_STATE] intValue] == VSTATE_NONE) btnTitle = @"安装";
    if ([self.dataRow[V_STATE] intValue] == VSTATE_NEW) btnTitle = @"更新";
    if ([self.dataRow[V_STATE] intValue] == VSTATE_SAME) btnTitle = @"已最新";
    [btn setTitle:btnTitle forState:0];
    [btn setTitleColor:RGB(0x007aff) forState:0];
    [btn addTarget:self action:@selector(onUpdateBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn release];
    
    if ([self.dataRow[V_STATE] intValue] == VSTATE_SAME) {
        //btn.enabled = NO;
        [btn setTitleColor:[UIColor lightGrayColor] forState:0];
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}

- (void)onUpdateBtnTouched:(id)sender
{
    NSInteger appState = [self.dataRow[V_STATE] intValue];
    
    NSMutableDictionary* appVersion = UGET(U_VERION);
    if (appVersion == nil)
        appVersion = [NSMutableDictionary dictionary];
    
    if (appState==VSTATE_NONE || appState==VSTATE_NEW || appState==VSTATE_SAME) {
        NSURL* appUrl = [NSURL URLWithString:format(VERS_FMT, self.dataRow[@"downloadLocation"])];
        [[UIApplication sharedApplication] openURL:appUrl];
        NSLog(@"install APP:%@", appUrl);
        appVersion[self.dataRow[@"appLocation"]] = self.dataRow[@"currentVersion"];
    }
    
    USET(U_VERION, appVersion);
}

@end
