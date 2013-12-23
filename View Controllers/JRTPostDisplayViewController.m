//
//  JRTPostDisplayViewController.m
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTPostDisplayViewController.h"

@interface JRTPostDisplayViewController () <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation JRTPostDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.postURL]];
}

#pragma mark - Web view delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

@end
