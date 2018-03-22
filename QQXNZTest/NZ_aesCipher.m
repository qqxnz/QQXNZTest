//
//  TestFunc.m
//  Code+Encode
//
//  Created by 张世豫 on 16/2/22.
//  Copyright © 2016年 张世豫. All rights reserved.
//

#import "NZ_aesCipher.h"

@implementation NZ_aesCipher

+ (NZ_aesCipher *)sharedManager
{
    static NZ_aesCipher *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//总加密
-(NSString *)EncodeBase64StrtoAES256toHex :(NSString *)Str :(NSString *)AESKey{
    //1.字符串转Base64编码(字符串）
    NSData * strData = [Str dataUsingEncoding:NSUTF8StringEncoding];
    NSString * EncodeBaseStr = [strData base64EncodedStringWithOptions:0];
    
    //2.字符串转data AES256加密（Nsdata）
    NSData * AesData = [EncodeBaseStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData * keyData = [AESKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData * ResultData = [AesData AES256EncryptWithKey:keyData];
    
    //3.再次转成16进制（字符串）
    NSString * HexStr = [self convertDataToHexStr:ResultData];
    
    return HexStr;
}

//总解密
-(NSString *)DecodeHextoAES256toBase64Str :(NSString *)HexStr :(NSString *)AESKey{
    //1.16进制字符串转Data
    NSData * HexData = [self convertHexStrToData:HexStr];
    
    //2.AES256解密
    NSData * keyData = [AESKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData * DecodeData = [HexData AES256DecryptWithKey:keyData];
    
    //3.转成Base64编码（字符串）
    NSString *resultFromHex = [[NSString alloc] initWithData:DecodeData encoding:NSUTF8StringEncoding];
    if (resultFromHex == nil) {
        return HexStr;
    }else{
        NSData * DecodeBase64Data = [[NSData alloc]initWithBase64EncodedString:resultFromHex options:0];
        NSString * getBase64Str = [[NSString alloc]initWithData:DecodeBase64Data encoding:NSUTF8StringEncoding];
        
        return getBase64Str;
    }
    
}

//16进制->data
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}

//data->16进制
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


@end
