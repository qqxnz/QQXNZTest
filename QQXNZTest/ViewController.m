//
//  ViewController.m
//  QQXNZTest
//
//  Created by mm on 2017/8/21.
//  Copyright © 2017年 mm. All rights reserved.
//

#import "ViewController.h"

#import "NZ_Data.h"
#import "NZ_NetWorking.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:@"login" forKey:@"funcname"];
                                 
                                 
    [dic setValue:@"13123123" forKey:@"userid"];
//
//    
//    for (NSObject * key in dic) {
//        
//        NSLog(@"%@ --- %@",key,dic[key]);
//    
//    }
//    
//    
//    NSString *str = [NZ_Data dictionaryToJson:dic];
//    
//    
//
//    NSLog(@"%@", str);
//    
    
    
    
    
    
    NZ_NetWorking * net = [[NZ_NetWorking alloc] init];
    
    [net apiServerApi:@"http://127.0.0.1:8080/api.post" funcName:@"test" key:@"fe6d1fed11fa60277fb6a2f73efb8be2" data:dic result:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"%@",error);
        
        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",result);
        
        NSLog(@"%@",response);
        
        
        
    }];
    
    
    
    
    
    
    
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
