//
//  ZYFURLTableSearch.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRMHelper.h"

//表单查询
//#define kTableSearch kBaseUrl@"/api/Test/ceshi"
//主界面的接口
//#define kTableSearchMain @"http://100.100.100.68:61113/api/Test/GetFetchXml"
#define kTableSearchMain kBaseUrl@"/api/Test/GetFetchXml"


//主界面的接口
#define kTableSearchForm kBaseUrl@"/api/Test/GetAppForm"


#define kTableSearch kBaseUrl@"/api/Test/ceshi"

//查询list类型的接口
#define kList   kBaseUrl@"/api/Test/getfetchxml"

//查询lookup类型的接口
#define kLookup kBaseUrl@"/api/Test/GetXMLRecond"

//表单查询主界面icon
//#define kIcon @"http://100.100.100.68"
#define kIcon @"http://sxcrm.auxgroup.com"


@interface ZYFURLTableSearch : NSObject

@end
