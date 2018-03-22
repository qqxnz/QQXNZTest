//
//  NZ_NetWorking.m
//  club
//
//  Created by mm on 2017/8/15.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "NZ_NetWorking.h"
#import "NZ_Data.h"
#import "NZ_aesCipher.h"


@implementation NZ_NetWorking

- (id)init {
    if (self=[super init]) {
        // Initialize self.
        
        self.timeOut = 10;
        
        self.headers = nil;
    }
    return self;
}


- (void)dealloc
{
    NSLog(@"NetWorking 释放");
}


-(void)get:(NSString *)url result:(void (^)(NSData *, NSURLResponse *, NSError *))result{
    
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSLog(@"%f",self.timeOut);
    
    [req setHTTPMethod:@"GET"];
    
    [req setTimeoutInterval:self.timeOut];
    
    if(self.headers != nil){
        [req setAllHTTPHeaderFields:self.headers];
    }
    
    NSURLSession *session  = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:req completionHandler:result];
    
    [task resume];
    
}



-(void)post:(NSString *)url body:(NSDictionary<NSString *,NSString *> *)body result:(void (^)(NSData *, NSURLResponse *, NSError *))result{

    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [req setHTTPMethod:@"POST"];
    
    [req setTimeoutInterval:self.timeOut];
    
    
    if(self.headers != nil){
        [req setAllHTTPHeaderFields:self.headers];
    }
    
    NSString *str = @"";
    
    if(body != nil){
        for(NSString * key in body){
            str = [str stringByAppendingFormat:@"%@=%@&",key,[body objectForKey:key]];
        }
    
    }
    
    [req setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSession *session  = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:req completionHandler:result];
    
    [task resume];
    


}


-(void)upload:(NSString *)url data:(NSData *)data result:(void (^)(NSData *, NSURLResponse *, NSError *))result{
    

    NSString *urlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *nsurl = [NSURL URLWithString:urlString];
    

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];

    request.HTTPMethod = @"POST";

    [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:data completionHandler:result] resume];
    
}
    

-(void)apiServerApi:(NSString *)url funcName:(NSString *)funcName key:(NSString *)key data:(NSDictionary *)data result:(void (^)(NSData *, NSURLResponse *, NSError *))result{
    
    NSString *body = @"";
    
    NSString * dataStr = [NZ_Data dictionaryToJson:data];
    
    NSString * words = [[NZ_aesCipher sharedManager] EncodeBase64StrtoAES256toHex:dataStr :key ];
    

    body = [body stringByAppendingFormat:@"func=%@&words=%@%@",funcName,key,words];
    
    
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [req setHTTPMethod:@"POST"];
    
    [req setTimeoutInterval:self.timeOut];

    if(self.headers != nil){
        [req setAllHTTPHeaderFields:self.headers];
    }
    
    [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSession *session  = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:req completionHandler:result];
    
    [task resume];
    
    
}



@end
