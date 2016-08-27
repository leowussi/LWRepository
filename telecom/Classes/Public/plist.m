//
//  PList.m
//  quanzhi
//
//  Created by ZhongYun on 14-1-8.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "PList.h"

static NSMutableDictionary* appPL = nil;
static NSMutableDictionary* userPL = nil;
static NSMutableDictionary* dataPL = nil;


#define PLIST_PATH      [NSString stringWithFormat:@"%@/Documents/appPL.plist", NSHomeDirectory()]
#define USER_TYPE       @"USER"
#define DATA_TYPE       @"DATA"

void initAppPL(void)
{
    if (!appPL) {
        NSString* appPLPath = PLIST_PATH;
        NSLog(@"%@", appPLPath);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:appPLPath]) {
            NSError *err;
            NSString *srcPL = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"appPL.plist"];
            [fileManager copyItemAtPath:srcPL toPath:appPLPath error:&err];
        }
        
        appPL = [[NSMutableDictionary alloc] initWithContentsOfFile:appPLPath];
        
        userPL = [appPL objectForKey:USER_TYPE];
        if (!userPL) {
            userPL = [[NSMutableDictionary alloc] init];
            [appPL setObject:userPL forKey:USER_TYPE];
        }

        dataPL = [appPL objectForKey:DATA_TYPE];
        if (!dataPL) {
            dataPL = [[NSMutableDictionary alloc] init];
            [appPL setObject:dataPL forKey:DATA_TYPE];
        }
    }
}

void USET(id k, id v)
{
    if (v) {
        [userPL setObject:v forKey:k];
    } else {
        [userPL removeObjectForKey:k];
    }
    BOOL successful = [appPL writeToFile:PLIST_PATH atomically:YES];
    if (!successful) {
        [appPL writeToFile:PLIST_PATH atomically:YES];
    }
}

id UGET(id k)
{
    return [userPL objectForKey:k];
}

id UGET_NO_NIL(id k)
{
    id res = UGET(k);
    return (res==nil ? @"" : [NSString stringWithFormat:@"%@", res]);
}

void DSET(id k, id v)
{
    [dataPL setObject:v forKey:k];
    [appPL writeToFile:PLIST_PATH atomically:YES];
}

id DGET(id k)
{
    return [dataPL objectForKey:k];
}

