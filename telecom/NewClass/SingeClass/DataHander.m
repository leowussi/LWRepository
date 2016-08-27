//
//  DataHander.m
//  CaCaXian
//
//  Created by Nancy on 13-4-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "DataHander.h"
#import "AppDelegate.h"

@implementation DataHander

static DataHander* dataHander = nil;

+(DataHander *)sharedDataHander
{
    @synchronized(self){
        if (dataHander == nil) {
            dataHander = [[self alloc] init];
        }
    }
    return dataHander;
}

-(void)showDlg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!mbProgressHud)
        {
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            mbProgressHud = [[MBProgressHUD alloc] initWithView:appDelegate.window];
            [mbProgressHud setMinSize:CGSizeMake(100, 100)];
            [appDelegate.window addSubview:mbProgressHud];
        }
        mbProgressHud.dimBackground = YES;
        mbProgressHud.labelText = @"正在加载";
        [mbProgressHud show:YES];
    });
}
-(void)hideDlg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [mbProgressHud hide:YES];
        [mbProgressHud removeFromSuperview];
        [mbProgressHud release];
        mbProgressHud = nil;
    });
}
-(id)init{
    
    if(self = [super init])
    {
    }
    return self;
}


- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}
- (oneway void)release
{
    ///oneway用在分布式对象的API，这些API可以在不同的线程，甚至是不同的程序。oneway关键字只用在返回类型为void的消息定义中， 因为oneway是异步的，其消息预计不会立即返回。
}
- (id)autorelease
{
    return self;
}
-(void)dealloc
{
    mbProgressHud = nil;
    [super dealloc];
}
@end
