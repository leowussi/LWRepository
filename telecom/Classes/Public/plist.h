//
//  PList.h
//  quanzhi
//
//  Created by ZhongYun on 14-1-8.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

void initAppPL(void);

void USET(id k, id v);
id UGET(id k);
id UGET_NO_NIL(id k);

void DSET(id k, id v);
id DGET(id k);