//
//  DesEncrypt.h
//  Fakid
//
//  Created by Peter Yuen on 6/30/14.
//
//

#import <Foundation/Foundation.h>
#import<CommonCrypto/CommonCryptor.h>



//预定义函数结构体，方便外部调用，具体在m文件实现，防止注入、hook攻击
typedef struct _desEncrypt{
    const char *(*encryptWithKeyAndType)(char *text,CCOperation operate,char *key);
    const char* (*encryptText)(const char *,char *);
    const char* (*decryptText)(const char *,char *);
}_desEncrypt;


@interface DesEncrypt : NSObject
{

}

+(_desEncrypt *)sharedDesEncrypt;

@end
