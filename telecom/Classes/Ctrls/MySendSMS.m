//
//  MySendSMS.m
//  telecom
//
//  Created by ZhongYun on 14-8-5.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MySendSMS.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface MySendSMS ()<MFMessageComposeViewControllerDelegate>
@property(nonatomic,retain)UIViewController* parentVC;
@end

@implementation MySendSMS

+ (MySendSMS*)shared
{
    static MySendSMS* instance = nil;
    if (!instance) {
        instance = [[MySendSMS alloc] init];
    }
    return instance;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
    switch ( result ) {
        case MessageComposeResultCancelled:
        {
            SEL sel = NSSelectorFromString(@"sendSmsCanncel");
            if ([self.parentVC respondsToSelector:sel]) {
                [self.parentVC performSelectorOnMainThread:sel withObject:nil waitUntilDone:YES];
            }
        }
            break;
        case MessageComposeResultFailed:// send failed
            break;
        case MessageComposeResultSent:
        {
            SEL sel = NSSelectorFromString(@"sendSmsSuccess");
            if ([self.parentVC respondsToSelector:sel]) {
                [self.parentVC performSelectorOnMainThread:sel withObject:nil waitUntilDone:YES];
            }
        }
            break;
        default:
            break;
    }
}

+ (void)sendSMS:(id)params
{
    if ([MFMessageComposeViewController canSendText])
    {
        if (iOSv7) {
            [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        }
        
        MySendSMS* SMSObj = [MySendSMS shared];
        
        MFMessageComposeViewController* vc = [[MFMessageComposeViewController alloc] init];
        vc.messageComposeDelegate = SMSObj;
        vc.recipients = @[params[@"mobile"]];
        vc.body = params[@"message"];
        
        //  添加文件;
        //        NSString* kUTTypePNG = @"Yawkey_business_dog";
        //        if ([MFMessageComposeViewController canSendAttachments] && [MFMessageComposeViewController isSupportedAttachmentUTI:kUTTypePNG]) {
        //            UIImage *myImage = [UIImage imageNamed:@"Yawkey_business_dog.png"];
        //            BOOL attached = [vc addAttachmentData:UIImagePNGRepresentation(myImage) typeIdentifier:kUTTypePNG filename:@"Yawkey_business_dog.png"];
        //        }
        
        SMSObj.parentVC = (UIViewController*)params[@"parent"];
        [SMSObj.parentVC presentModalViewController:vc animated:YES];
        [vc release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
    }
}

@end
