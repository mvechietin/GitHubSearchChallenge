//
//  Webservice.h
//  challenge GitHub
//
//  Created by Matheus Vechietin on 26/09/15.
//  Copyright (c) 2015 Matheus Vechietin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebserviceCallback.h"

@interface Webservice : NSObject

- (void)requestGetMethodWithUrl:(NSString *)url withParams:(NSDictionary *)params type:(NSString *)type andDelegate:(id<WebserviceCallback>)delegateCallBack;

@end
