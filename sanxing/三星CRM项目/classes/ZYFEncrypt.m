////
////  ZYFEncrypt.m
////  三星CRM项目
////
////  Created by yufeng Zhu on 15/9/15.
////  Copyright (c) 2015年 ZYF. All rights reserved.
////
//
//#import "ZYFEncrypt.h"
//
//@implementation ZYFEncrypt
//
//static const char* encryptWithKeyAndType(const char *text,CCOperation encryptOperation,char *key)
//{
//    NSString *textString=[[NSString alloc]initWithCString:text encoding:NSUTF8StringEncoding];
//    //      NSLog(@"[[item.url description] UTF8String=%@",textString);
//    const void *dataIn;
//    size_t dataInLength;
//    
//    if (encryptOperation == kCCDecrypt)//传递decrypt 解码
//    {
//        //解码 base64
//        NSData *decryptData = [GTMBase64 decodeData:[textString dataUsingEncoding:NSUTF8StringEncoding]];//转utf-8并decode
//        dataInLength = [decryptData length];
//        dataIn = [decryptData bytes];
//    }
//    else  //encrypt
//    {
//        NSData* encryptData = [textString dataUsingEncoding:NSUTF8StringEncoding];
//        dataInLength = [encryptData length];
//        dataIn = (const void *)[encryptData bytes];
//    }
//    
//    
//    CCCryptorStatus ccStatus;
//    uint8_t *dataOut = NULL; //理解位type/typedef 缩写（效维护代码比：用int用long用typedef定义）
//    size_t dataOutAvailable = 0; //size_t  操作符sizeof返结类型
//    size_t dataOutMoved = 0;
//    
//    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
//    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
//    memset((void *)dataOut, 00, dataOutAvailable);//已辟内存空间buffer首 1 字节值设值 0
//    
//    //NSString *initIv = @"12345678";
//    const void *vkey = key;
//    const void *iv = (const void *) key; //[initIv UTF8String];
//    
//    //CCCrypt函数 加密/解密
//    ccStatus = CCCrypt(encryptOperation,//  加密/解密
//                       kCCAlgorithmDES,//  加密根据哪标准（des3desaes）
//                       kCCOptionPKCS7Padding,//  选项组密码算(des:每块组加密  3DES：每块组加三同密)
//                       vkey,  //密钥    加密解密密钥必须致
//                       kCCKeySizeDES,//   DES 密钥（kCCKeySizeDES=8）
//                       iv, //  选初始矢量
//                       dataIn, // 数据存储单元
//                       dataInLength,// 数据
//                       (void *)dataOut,// 用于返数据
//                       dataOutAvailable,
//                       &dataOutMoved);
//    
//    NSString *result = nil;
//    
//    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
//    {
//        //解密data数据改变utf-8字符串
//        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
//    }
//    else //encryptOperation==0  （加密程加密数据转base64）
//    {
//        //编码 base64
//        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
//        result = [GTMBase64 stringByEncodingData:data];
//    }
//    
//    return [result UTF8String];
//    
//}
//+(NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type key:(NSString*)aKey
//{
//    const char * contentChar =[content UTF8String];
//    char * keyChar =(char*)[aKey UTF8String];
//    const char *miChar;
//    miChar = encryptWithKeyAndType(contentChar, type, keyChar);
//    return  [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding];
//}
//
//@end
