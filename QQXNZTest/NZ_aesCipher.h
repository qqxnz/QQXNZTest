//
//  TestFunc.h
//  Code+Encode
//
//  Created by 张世豫 on 16/2/22.
//  Copyright © 2016年 张世豫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HEX+AES256.h"
@interface NZ_aesCipher : NSObject

+ (NZ_aesCipher *)sharedManager;

//总加密
-(NSString *)EncodeBase64StrtoAES256toHex :(NSString *)BaseStr :(NSString *)AESKey;

//总解密
-(NSString *)DecodeHextoAES256toBase64Str :(NSString *)HexStr :(NSString *)AESKey;
@end
