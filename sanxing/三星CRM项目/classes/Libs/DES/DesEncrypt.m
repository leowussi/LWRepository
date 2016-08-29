//
//  DesEncrypt.m
//  Fakid
//
//  Created by Peter Yuen on 6/30/14.
//
//

#import "DesEncrypt.h"
#import "GTMBase64.h"

static const char* encryptWithKeyAndType(const char *text,CCOperation encryptOperation,char *key)
{
    NSString *textString=[[NSString alloc]initWithCString:text encoding:NSUTF8StringEncoding];
    //      NSLog(@"[[item.url description] UTF8String=%@",textString);
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[textString dataUsingEncoding:NSUTF8StringEncoding]];//转utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [textString dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //理解位type/typedef 缩写（效维护代码比：用int用long用typedef定义）
    size_t dataOutAvailable = 0; //size_t  操作符sizeof返结类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 00, dataOutAvailable);//已辟内存空间buffer首 1 字节值设值 0
    
    //NSString *initIv = @"12345678";
    const void *vkey = key;
    const void *iv = (const void *) key; //[initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪标准（des3desaes）
                       kCCOptionPKCS7Padding,//  选项组密码算(des:每块组加密  3DES：每块组加三同密)
                       vkey,  //密钥    加密解密密钥必须致
                       kCCKeySizeDES,//   DES 密钥（kCCKeySizeDES=8）
                       iv, //  选初始矢量
                       dataIn, // 数据存储单元
                       dataInLength,// 数据
                       (void *)dataOut,// 用于返数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //解密data数据改变utf-8字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密程加密数据转base64）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    
    return [result UTF8String];
    
}

//
//static const char* encryptWithKeyAndType(const char *text,CCOperation encryptOperation,char *key)
//{
//    NSString *textString=[[NSString alloc]initWithCString:text encoding:NSUTF8StringEncoding];
////      NSLog(@"[[item.url description] UTF8String=%@",textString);
//    const void *dataIn;
//    size_t dataInLength;
//    
//    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
//    {
//        //解码 base64
//        NSData *decryptData = [GTMBase64 decodeData:[textString dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
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
//    /*
//     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
//     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
//     */
//    CCCryptorStatus ccStatus;
//    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
//    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
//    size_t dataOutMoved = 0;
//    
//    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
//    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
//    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
//    
//    NSString *initIv = @"12345678";
//    const void *vkey = key;
//    const void *iv = (const void *) [initIv UTF8String];
//    
//    //CCCrypt函数 加密/解密
//    ccStatus = CCCrypt(encryptOperation,//  加密/解密
//                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
//                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
//                       vkey,  //密钥    加密和解密的密钥必须一致
//                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
//                       iv, //  可选的初始矢量
//                       dataIn, // 数据的存储单元
//                       dataInLength,// 数据的大小
//                       (void *)dataOut,// 用于返回数据
//                       dataOutAvailable,
//                       &dataOutMoved);
//    
//    NSString *result = nil;
//    
//    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
//    {
//        //得到解密出来的data数据，改变为utf-8的字符串
//        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
//    }
//    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
//    {
//        //编码 base64
//        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
//        result = [GTMBase64 stringByEncodingData:data];
//    }
//    
//    return [result UTF8String];
//
//}

static const char* encryptText(const char* text, char *key)
{
    return encryptWithKeyAndType(text, kCCEncrypt, key);

//    return encryptWithKeyAndType(text, kCCEncrypt, "Cjh56*-9&#^HJHD&&@!DP0N##$%^&**())LLJGHDAQAZZ,,..///,nm1````1223-asdfdddc777&&*334");
}

static const char* decryptText(const char *text, char *key)
{
//    return encryptWithKeyAndType(text, kCCDecrypt, "Cjh56*-9&#^HJHD&&@!DP0N##$%^&**())LLJGHDAQAZZ,,..///,nm1````1223-asdfdddc777&&*334");
    return encryptWithKeyAndType(text, kCCDecrypt,key);

}

static _desEncrypt *_methodlist=NULL;

@implementation DesEncrypt



+(_desEncrypt *)sharedDesEncrypt
{
    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _methodlist=malloc(sizeof(_desEncrypt));
            _methodlist->encryptText=encryptText;
            _methodlist->decryptText=decryptText;
        });
    }
    return _methodlist;
}



-(void)dealloc
{
    _methodlist?free(_methodlist):0;
}


@end
