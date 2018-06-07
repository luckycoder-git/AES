//
//  YQAES128.m
//  SecurityCode
//
//  Created by WingChing_Yip on 2018/6/6.
//  Copyright © 2018年 ywc. All rights reserved.
//

#import "YQAES128.h"
#import "NSData+YQAES128.h"

//#define IV  @"偏移量 16位长度的字符串"
//#define  KEY  @"key值 16位长度的字符串"

@implementation YQAES128

/**
 *  加密
 *
 *  @param string 需要加密的string
 *
 *  @return 加密后的字符串
 */
+ (NSString *)AES128EncryptStrig:(NSString *)string key: (NSString *)key iv:(NSString *) iv{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesData = [data AES128EncryptWithKey:key iv:iv];
    return [aesData base64EncodedStringWithOptions:0];
//    return [YQAES128 convertDataToHexStr:aesData];
}

/**
 *  解密
 *
 *  @param string 加密的字符串
 *
 *  @return 解密后的内容
 */
+ (NSString *)AES128DecryptString:(NSString *)string key: (NSString *)key iv:(NSString *) iv{
//    NSData *data  = [YQAES128 convertHexStrToData:string];
    // base64 转 NSData
    NSData *data =  [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSData *aesData = [data AES128DecryptWithKey:key iv:iv];
    return [[NSString alloc] initWithData:aesData encoding:NSUTF8StringEncoding];
}

//16进制转换为NSData
+ (NSData*)convertHexStrToData:(NSString*)str {
    if (!str || [str length] ==0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc]initWithCapacity:[str length]*2];
    NSRange range;
    if ([str length] %2==0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [str length]; i +=2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc]initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc]initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location+= range.length;
        range.length=2;
    }
    //    NSLog(@"hexdata: %@", hexData);
    return hexData;
}

//NSData转换为16进制
+ (NSString*)convertDataToHexStr:(NSData*)data {
    if (!data || [data length] ==0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc]initWithCapacity:[data length]/2];
    
    [data enumerateByteRangesUsingBlock:^(const void*bytes,NSRange byteRange,BOOL*stop) {
        unsigned char *dataBytes = (unsigned  char*)bytes;
        for (NSInteger i =0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] ==2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

@end
