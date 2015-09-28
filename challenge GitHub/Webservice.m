//
//  Webservice.m
//  challenge GitHub
//
//  Created by Matheus Vechietin on 26/09/15.
//  Copyright (c) 2015 Matheus Vechietin. All rights reserved.
//

#import "Webservice.h"
#import "AFNetworking.h"
#import "BetterNSLog.h"

@interface Webservice ()

@property (nonatomic, strong) id<WebserviceCallback> delegate;

@end

@implementation Webservice

- (void)requestGetMethodWithUrl:(NSString *)url withParams:(NSDictionary *)params type:(NSString *)type andDelegate:(id<WebserviceCallback>)delegateCallBack {
    
    //1
    NSString *escapedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *urlString = [NSURL URLWithString:escapedUrl];
    
    DLog(@"URL METHOD GET = %@", urlString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString];
    request.timeoutInterval = 15;
    [request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DLog(@"Response recebido com sucesso !");
        
        NSError *error = nil;
        [delegateCallBack processData:[NSJSONSerialization JSONObjectWithData:responseObject options:NSUTF8StringEncoding error:&error] andType:type];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DLog("%@", error.description);
        [delegateCallBack processData:nil andType:type];
    }];
    
    // 5
    [operation start];
}

@end
