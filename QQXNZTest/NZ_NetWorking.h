//
//  NZ_NetWorking.h
//  club
//
//  Created by mm on 2017/8/15.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZ_NetWorking : NSObject

///请求超时时间
@property (nonatomic) NSTimeInterval timeOut;
///请求头
@property (nonatomic) NSDictionary<NSString *,NSString *> *headers;
///GET请求
-(void)get:(NSString *) url  result:(void (^)(NSData * data, NSURLResponse * response, NSError * error))result;
///POST请求
-(void)post:(NSString *) url body:(NSDictionary<NSString *,NSString *>*) body result:(void (^)(NSData * data, NSURLResponse * response, NSError * error))result;
///上传二进制数据
-(void)upload:(NSString *) url data:(NSData *) data result:(void (^)(NSData * data, NSURLResponse * response, NSError * error))result;
///与同步平台api接口对接
-(void)apiServerApi:(NSString *) url funcName:(NSString*) funcName key:(NSString*) key data:(NSDictionary*) data result:(void (^)(NSData * data, NSURLResponse * response, NSError * error))result;

@end
