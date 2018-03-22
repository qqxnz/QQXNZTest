//
//  HEX+AES256.m
//  Code+Encode
//
//  Created by 张世豫 on 16/2/22.
//  Copyright © 2016年 张世豫. All rights reserved.
//

#import "HEX+AES256.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (HEX_AES256)

-(NSString *)CodeBase64StrtoAES256toHex :(NSString *)BaseStr :(NSString *)AESKey{
    NSData * strData = [BaseStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData * keyData = [AESKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData * ResultData = [strData AES256EncryptWithKey:keyData];
    NSString * HexStr = [self convertDataToHexStr:ResultData];
    return HexStr;
}


-(NSData *)AES256EncryptWithKey:(NSData *)key   //加密
{
    //對於塊加密算法，輸出大小總是等於或小於輸入大小加上一個塊的大小
    //所以在下邊需要再加上一個塊的大小
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key bytes], kCCKeySizeAES256,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);//釋放buffer
    return nil;
}


-(NSData *)AES256DecryptWithKey:(NSData *)key   //解密
{
    
    //同理，解密中，密鑰也是32位的
    const void * keyPtr2 = [key bytes];
    const char (*keyPtr)[32] = keyPtr2;
    
    //對於塊加密算法，輸出大小總是等於或小於輸入大小加上一個塊的大小
    //所以在下邊需要再加上一個塊的大小
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
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
    
    NSLog(@"hexdata: %@", hexData);
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
