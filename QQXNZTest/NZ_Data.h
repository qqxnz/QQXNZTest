//
//  NZ_Data.h
//  QQXNZTest
//
//  Created by mm on 2017/8/21.
//  Copyright © 2017年 mm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZ_Data : NSObject

///json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

///字典转json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;



@end
