//
//  MessageBoardViewController.h
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 4/19/10.
//  Copyright 2010 ZWorkbench, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdBasedController.h"

@interface MessageBoardViewController : AdBasedController <UIWebViewDelegate> {
   IBOutlet UIWebView *webView;
   IBOutlet UIView *loadingView;
   IBOutlet UIActivityIndicatorView *activityIndicator;
   IBOutlet UILabel *loadingLabel;
   NSURL *url;
}

@property (nonatomic, retain) NSURL *url;

@end
