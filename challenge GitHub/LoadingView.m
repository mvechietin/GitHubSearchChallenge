//
//  LoadingView.m
//  challenge GitHub
//
//  Created by Matheus Vechietin on 26/09/15.
//  Copyright (c) 2015 Matheus Vechietin. All rights reserved.
//

#import "LoadingView.h"
#import "SVProgressHUD.h"

@interface LoadingView ()

@property (strong, nonatomic) UIView * view;

@end

@implementation LoadingView

@synthesize view;

- (id)initWithController:(UIViewController*) controller
{
    
    
    return self;
}

- (id)initWithView:(UIView *)controller
{
    
    
    return self;
}

- (void)showWithouDisableView {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:218/255.0 green:223/255.0 blue:225/255.0 alpha:1]];
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeNone];
}

- (void)show {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:218/255.0 green:223/255.0 blue:225/255.0 alpha:1]];
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
}

- (void)hide {
    [SVProgressHUD dismiss];
}

- (BOOL)isAnimating {
    return !view.hidden;
}


@end
