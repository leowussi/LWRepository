//
//  ZYFUrlClientInformation.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/9/22.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRMHelper.h"

@interface ZYFUrlClientInformation : NSObject

//行销客户
#define kClientInformation kBaseUrl@"/api/test/getfetchxml?formxml=myactive_account"
//联系人
#define kContact kBaseUrl@"/api/test/getfetchxml?formxml=active_contact"
//项目登记
#define kNewProject kBaseUrl@"/api/test/getfetchxml?formxml=active_new_project"



@end
