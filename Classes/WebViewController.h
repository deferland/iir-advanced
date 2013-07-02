//
//  WebViewController.h
//  locationPOC
//
//  Created by jrtb on 8/21/08.
//  Copyright 2008 jrtb. All rights reserved.
//

#import "RootViewController.h"

@interface WebViewController : UIViewController <UIWebViewDelegate> {
	id									flipDelegate;
	UIWebView							*webView;
	IBOutlet UIActivityIndicatorView	*progressView;
	IBOutlet UILabel					*loadingLabelView;
	IBOutlet UIButton					*infoButtonDark;
	NSString							*instrument;
}

@property (nonatomic,assign) id <MyFlipControllerDelegate>				flipDelegate;
@property (nonatomic,retain) UIWebView									*webView;
@property (nonatomic,retain) UIButton									*infoButtonDark;
@property (nonatomic,retain) UIActivityIndicatorView					*progressView;
@property (nonatomic,retain) UILabel									*loadingLabelView;
@property (nonatomic,retain) NSString									*instrument;

- (IBAction)infoButtonPressed:(id)sender;
- (IBAction)homeButtonPressed:(id)sender;
- (IBAction)aboutButtonPressed:(id)sender;
- (IBAction)setupButtonPressed:(id)sender;
- (void)loadURL:(NSString *)urlToLoad;

@end
