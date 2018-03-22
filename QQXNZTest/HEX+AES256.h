//
//  HEX+AES256.h
//  Code+Encode
//
//  Created by 张世豫 on 16/2/22.
//  Copyright © 2016年 张世豫. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NSData (HEX_AES256)

-(NSString *)CodeBase64StrtoAES256toHex :(NSString *)BaseStr :(NSString *)AESKey;

-(NSData *)AES256EncryptWithKey:(NSData *)key;   //加密
-(NSData *)AES256DecryptWithKey:(NSData *)key;   //解密

@end
