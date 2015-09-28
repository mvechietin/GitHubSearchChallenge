//
//  LoadWebPageViewController.m
//  challenge GitHub
//
//  Created by Matheus Vechietin on 26/09/15.
//  Copyright (c) 2015 Matheus Vechietin. All rights reserved.
//

#import "LoadWebPageViewController.h"
#import "LoadingView.h"

@interface LoadWebPageViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) LoadingView *loading;

@end

@implementation LoadWebPageViewController

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    self.loading = [[LoadingView alloc] initWithController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURL *htmlUrl = [NSURL URLWithString:self.stringURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:htmlUrl];
    
    [self.loading show];
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Web View Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loading hide];
}

@end
