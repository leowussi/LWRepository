//
//
//  Created by yufeng Zhu on 14-5-19.
//  Copyright (c) 2014年 project. All rights reserved.
//

#import "ZYFHttpTool.h"
#import "AFNetworking.h"
#import "CRMHelper.h"
#import "Reachability.h"
#import "ZYFDisplayCols.h"
#import "ZYFAttributes.h"
#import "ZYFSaleList.h"
#import "GDataXMLNode.h"
#import "ZYFForm.h"
#import "ZYFGroup.h"

@interface ZYFHttpTool()

@property (nonatomic,strong) NSMutableArray *mutableArray;
@property (nonatomic,strong) ZYFForm *form;

@end

@implementation ZYFHttpTool

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [[self class]setupAFNManager:mgr];
    
    // 2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
        for (IWFormData *formData in formDataArray) {
            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)putWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [[self class]setupAFNManager:mgr];
    
    [mgr PUT:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [[self class]setupAFNManager:mgr];
    
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.securityPolicy.allowInvalidCertificates = YES;
    [[self class]setupAFNManager:mgr];
    
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (NSString *)getlegalFileNameWithString: (NSString *)url
{
    //去掉文件名种带@“/”的部分，并讲文件名截取到长度为20个字符
    url = [url stringByReplacingOccurrencesOfString:@"/" withString:@"m"];
    if (url.length > 20) {
        url = [url substringFromIndex:url.length - 20];
    }
    return url;
}



+ (void)getWithURLCache:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSString *resultString = [[self class]getlegalFileNameWithString:url];
    //    NSString *resultString = @"";
    
    //如果当前网络不可用
    if ( ! [[self class]isEnableNetWork]) {
        ZYFLog(@"11111%@",resultString);
        NSString *filePath = [CRMHelper createFilePathWithFileName:resultString];
        NSArray *localSaleArray = [NSArray arrayWithContentsOfFile:filePath];
        
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSData *data in localSaleArray) {
            ZYFSaleList *sale = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [mutableArray addObject:sale];
        }
        success(mutableArray);
        return;
    }
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [[self class]setupAFNManager:mgr];
    
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves   error:nil];
             ZYFDisplayCols *displayCols = [ZYFDisplayCols displayColWithDict:dictionary];
             // 2、解析Entity
             NSArray *entityarray = dictionary[@"Entitys"];
             
             NSMutableArray *saleArray = [NSMutableArray array];
             NSMutableArray *localSaleArray = [NSMutableArray array];
             
             for (NSDictionary *dict in entityarray) {
                 //构造每个实体(Entity)的模型
                 ZYFSaleList *saleList = [ZYFSaleList saleListWithDict:dict displayCols:displayCols];
                 
                 NSData *localSaleData = [NSKeyedArchiver archivedDataWithRootObject:saleList];
                 
                 [saleArray addObject:saleList];
                 //存在本地
                 [localSaleArray addObject:localSaleData];
             }
             success(saleArray);
             
             ZYFLog(@"22222%@",resultString);
             
             NSString *filePath = [CRMHelper createFilePathWithFileName:resultString];
             if([localSaleArray writeToFile:filePath atomically:YES]){
                 NSLog(@"writeToFile sucess") ;
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)getWithURLCacheXML:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSString *resultString = [[self class]getlegalFileNameWithString:url];
    
    //如果当前网络不可用
    if ( ! [[self class]isEnableNetWork]) {
        ZYFLog(@"11111%@",resultString);
        NSString *filePath = [CRMHelper createFilePathWithFileName:resultString];
        NSArray *localSaleArray = [NSArray arrayWithContentsOfFile:filePath];
        
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSData *data in localSaleArray) {
            ZYFSaleList *sale = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [mutableArray addObject:sale];
        }
        success(mutableArray);
        return;
    }
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [[self class]setupAFNManager:mgr];
    
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves   error:nil];
             // xml部分
             NSString *formString = dictionary[@"Form"];
             NSArray *groupArray = [[self class]XmlData:formString];
             //             ZYFDisplayCols *displayCols = [ZYFDisplayCols displayColWithDict:dictionary];
             //page部分
             NSString *page = dictionary[@"Page"];
             //more部分
             NSString *more = dictionary[@"More"];
             
             // 2、解析Entity
             NSArray *entityarray = dictionary[@"Entitys"];
             //解析xml部分的form
             
             NSMutableArray *saleArray = [NSMutableArray array];
             NSMutableArray *localSaleArray = [NSMutableArray array];
             
             for (NSDictionary *dict in entityarray) {
                 //构造每个实体(Entity)的模型
                 ZYFSaleList *saleList = [ZYFSaleList saleListWithDict:dict groupArray:groupArray];
                 saleList.page = page.integerValue;
                 saleList.more = more.boolValue;
                 if (groupArray) {
                     saleList.groupArray = groupArray;
                 }
                 
                 NSData *localSaleData = [NSKeyedArchiver archivedDataWithRootObject:saleList];
                 
                 [saleArray addObject:saleList];
                 //存在本地
                 [localSaleArray addObject:localSaleData];
             }
             success(saleArray);
             
             ZYFLog(@"22222%@",resultString);
             
             NSString *filePath = [CRMHelper createFilePathWithFileName:resultString];
             if([localSaleArray writeToFile:filePath atomically:YES]){
                 NSLog(@"writeToFile sucess") ;
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (NSArray *)XmlData:(NSString *)formString
{
    // 加载整个XML数据
    NSError *error = [[NSError alloc]init];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithXMLString:formString encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        ZYFLog(@"error = %@",error);
    }
    
    // 获得文档的根元素 -- Group元素
    GDataXMLElement *root = doc.rootElement;
    // 获得根元素里面的所有元素
    NSArray *elements = [root elementsForName:@"Group"];
    NSArray *listElements = [root elementsForName:@"List"];
    
    // 遍历所有的video元素
    NSMutableArray *groupArray = [NSMutableArray array];
    for (GDataXMLElement *groupElement in elements) {
        ZYFGroup *group = [[ZYFGroup alloc]init];
        group.name = [[groupElement attributeForName:@"name"] stringValue];
        group.ID = [[groupElement attributeForName:@"id"] stringValue];
        group.cols = [groupElement elementsForName:@"Cols"];
        
        //如果是list类型的数据
        if (listElements) {
            for (GDataXMLElement *element in listElements) {
                group.leftList = [[[element elementsForName:@"Left"]objectAtIndex:0] stringValue];
                group.rightList = [[[element elementsForName:@"Right"]objectAtIndex:0] stringValue];
                NSArray *relateElements = [element elementsForName:@"RelateEntity"] ;
                NSMutableArray *relateEntityArray = [NSMutableArray array];
                
                for (GDataXMLElement *relateElement in relateElements) {
                    ZYFRelateEntity *relateEntity = [[ZYFRelateEntity alloc]init];
                    
                    relateEntity.name = [[relateElement attributeForName:@"name"]stringValue];
                    relateEntity.type = [[relateElement attributeForName:@"type"]stringValue];
                    relateEntity.scheamname = [[relateElement attributeForName:@"scheamname"]stringValue];
                    relateEntity.logicalname = [[relateElement attributeForName:@"logicalname"]stringValue];
                    relateEntity.formxml = [[relateElement attributeForName:@"formxml"]stringValue];
                    [relateEntityArray addObject:relateEntity];
                }
                
                group.relateEntityOfListArray = relateEntityArray;
            }
        }
        
        NSMutableArray *formArray = [NSMutableArray array];
        for (GDataXMLElement *formElement in group.cols) {
            ZYFForm *form = [[ZYFForm alloc]init];
            // 取出元素的属性
            form.ColsKey = [[[formElement elementsForName:@"ColsKey"]objectAtIndex:0] stringValue];
            form.ColsGroup = [[[formElement elementsForName:@"ColsGroup"]objectAtIndex:0] stringValue];
            form.ColsType = [[[formElement elementsForName:@"ColsType"]objectAtIndex:0] stringValue];
            form.ColsName = [[[formElement elementsForName:@"ColsName"]objectAtIndex:0] stringValue];
            form.ColsEdit = [[[formElement elementsForName:@"ColsEdit"]objectAtIndex:0] stringValue];
            
            GDataXMLElement *relateElement = [[formElement elementsForName:@"RelateEntity"]objectAtIndex:0] ;
            
            ZYFRelateEntity *relateEntity = [[ZYFRelateEntity alloc]init];
            
            relateEntity.type = [[relateElement attributeForName:@"type"]stringValue];
            relateEntity.scheamname = [[relateElement attributeForName:@"scheamname"]stringValue];
            relateEntity.logicalname = [[relateElement attributeForName:@"logicalname"]stringValue];
            relateEntity.formxml = [[relateElement attributeForName:@"formxml"]stringValue];
            
            form.relateEntity = relateEntity;
            
            [formArray addObject:form];
        }
        group.formArray = formArray;
        [groupArray addObject:group];
    }
    return (NSArray *)groupArray;
}

+ (BOOL) isEnableNetWork {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}
//设置setCredential，requestSerializer，responseSerializer
+ (void)setupAFNManager:(AFHTTPRequestOperationManager*)mgr
{
//    [mgr setCredential:[[self class]getCredient]];
    mgr.requestSerializer = [[self class]getJsonRequestSerializer];
    mgr.requestSerializer.timeoutInterval = 15.0;
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
}

+ (AFJSONRequestSerializer *)getJsonRequestSerializer
{
    AFJSONRequestSerializer *afJsonRequestSerializer = [[AFJSONRequestSerializer alloc] init];
    [afJsonRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return afJsonRequestSerializer;
}

+ (NSURLCredential *)getCredient
{
    NSString *account = [ZYFUserDefaults objectForKey:ZYFAccountKey];
    NSString *passwd = [ZYFUserDefaults objectForKey:ZYFPwdKey];
    NSURLCredential *credential =  [NSURLCredential credentialWithUser:[@"auxgroup\\" stringByAppendingString:account] password:passwd
                                                           persistence:NSURLCredentialPersistenceForSession];
    return credential;
}

@end

/**
 *  用来封装文件数据的模型
 */
@implementation IWFormData

@end
