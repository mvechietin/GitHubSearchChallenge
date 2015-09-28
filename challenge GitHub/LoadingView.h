//
//  LoadingView.h
//  challenge GitHub
//
//  Created by Matheus Vechietin on 26/09/15.
//  Copyright (c) 2015 Matheus Vechietin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoadingView : NSObject

- (void)hide;
- (BOOL)isAnimating;
- (id)initWithController:(UIViewController *) controller;
- (id)initWithView:(UIView *)controller;

/*!
 * Metodo apresenta o loading sem desabilitar o toque na view
 */
- (void)showWithouDisableView;

/*!
 * Metodo apresenta o loading desabilitando o toque na view
 */
- (void)show;

@end
