//
//  MessageBoardViewController.m
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 4/19/10.
//  Copyright 2010 ZWorkbench, Inc. All rights reserved.
//

#import "MessageBoardViewController.h"


@implementation MessageBoardViewController

@synthesize url;

- (void) viewWillAppear:(BOOL)animated {
   [super viewWillAppear: animated];
   loadingLabel.hidden = NO;
   [webView loadRequest: [NSURLRequest requestWithURL: self.url]];
}

#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
   [[self tabBarController] setSelectedIndex: 0];
}

#pragma mark UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   loadingView.hidden = NO;
   [activityIndicator startAnimating];
   return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   [activityIndicator stopAnimating];
   loadingLabel.hidden = YES;
   loadingView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
   [activityIndicator stopAnimating];
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message Servers Unavailable" 
                                                   message: @"The message board is temporarily unavailable.  Please try again in a few minutes." 
                                                  delegate: self 
                                         cancelButtonTitle: @"Ok" 
                                         otherButtonTitles: nil];
   [alert show];
   [alert release];
}

#pragma mark UIViewController methods

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
   [super dealloc];
}


@end
