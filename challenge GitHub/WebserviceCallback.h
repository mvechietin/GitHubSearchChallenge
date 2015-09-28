//
//  WebserviceCallback.h
//  challenge GitHub
//
//  Created by Matheus Vechietin on 26/09/15.
//  Copyright (c) 2015 Matheus Vechietin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebserviceCallback <NSObject>

- (void)processData:(NSMutableDictionary *)data andType:(NSString *)tipo;

@end
