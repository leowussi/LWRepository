//
//  BMRequestManager.h
//  UnityLH
//
//  Created by apple on 13-5-28.
//  Copyright (c) 2013年 UnityLH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMBaseManager.h"

@interface BMRequestManager : BMBaseManager

+ (BMRequestManager*)shareBMRequestManager;

-(void)cleanRequest;

- (void)registerUser:(NSDictionary *)dataDic
                        success:(void (^)(id responseDic))success
                        failure:(void (^)(id errorString))failure;

-(void)loginUser:(NSDictionary *)dataDic
         success:(void (^)(id responseDic))success
         failure:(void (^)(id errorString))failure;
-(void)homePage:(NSDictionary *)dataDic
        success:(void (^)(id responseDic))success
        failure:(void (^)(id errorString))failure;

//首页  /Advertisement/GetBondTransferList
-(void)homPage:(NSDictionary *)dataDic
       success:(void (^)(id responseDic))success
       failure:(void (^)(id errorString))failure;




@end
