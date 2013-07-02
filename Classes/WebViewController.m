//
//  WebViewController.m
//  locationPOC
//
//  Created by jrtb on 8/21/08.
//  Copyright 2008 jrtb. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize flipDelegate, progressView, loadingLabelView, infoButtonDark, webView, instrument;

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	//NSLog(@"expected:%d, got:%d", UIWebViewNavigationTypeLinkClicked, navigationType);
	BOOL matchHTTP = ([[request.URL absoluteString] rangeOfString:@"instrument" options:NSCaseInsensitiveSearch].location != NSNotFound);

	BOOL matchS = ([[request.URL absoluteString] rangeOfString:@"&s" options:NSCaseInsensitiveSearch].location != NSNotFound);

    if (matchHTTP && !matchS) {
		NSLog([request.URL absoluteString]);
		
		NSRange range = [[request.URL absoluteString] rangeOfString:@"instrument"];
		int location = range.location;
		int length = range.length;
		
		NSString *instrumentString = [[request.URL absoluteString] substringFromIndex:location+length+1];
		
		NSLog(instrumentString);
		
		self.instrument = instrumentString;
		
		//NSString *newURL = [[NSString alloc] initWithFormat:@"index.html?instrument=%i", instrumentString];
		
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:newURL]];

        return true;
    } 
	
	return true;

}
	
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

		// setup webView
		webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		webView.hidden = YES;
		[webView setDelegate:self];
		webView.scalesPageToFit = NO;
		webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);		

		[self.view addSubview:webView];
		
		// important for view orientation rotation
		//webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);	
		self.view.autoresizesSubviews = YES;
		
		[progressView setTag:1];
		[loadingLabelView setTag:2];
		
		[self.view sendSubviewToBack:webView];
		[self.view bringSubviewToFront:infoButtonDark];
		
		NSLog(@"starting to load");
		[self loadURL:@"index"];
				
	}
	return self;
}

- (void)webViewDidFinishLoad:(UIWebView *) aView
{
	NSLog(@"finished loading");
	[[[[webView superview] superview] viewWithTag:1] removeFromSuperview];
	[[[[webView superview] superview] viewWithTag:2] removeFromSuperview];
	
	aView.hidden = NO;	
}

- (IBAction)homeButtonPressed:(id)sender {
	NSLog(@"home button pressed");
	if (self.instrument) {
		[self loadURL:self.instrument];
	} else {
		[self loadURL:@"index"];
	}
}

- (IBAction)aboutButtonPressed:(id)sender {
	NSLog(@"about button pressed");
	[self loadURL:@"about"];
}

- (IBAction)setupButtonPressed:(id)sender {
	NSLog(@"setup button pressed");
	[self loadURL:@"setup"];
}

- (void)loadURL:(NSString *)urlToLoad {
	// home
	NSString *templatePath = [[NSBundle mainBundle] pathForResource: urlToLoad ofType:@"html" inDirectory: @"html"];
	NSURL *templateUrl = [NSURL fileURLWithPath: templatePath];
	NSString *html = [NSString stringWithContentsOfFile: templatePath encoding: NSUTF8StringEncoding error: nil];
	[webView loadHTMLString: html baseURL: templateUrl];   
}

// Tells the root view, via a delegate, to flip over to the FlipSideView
- (IBAction)infoButtonPressed:(id)sender {
	[self.flipDelegate toggleView:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[webView release];
	[progressView release];
	[loadingLabelView release];
	[infoButtonDark release];
	[super dealloc];
}

-(void)viewDidAppear {

}	

// Called when the view is loading for the first time only
// If you want to do something every time the view appears, use viewWillAppear or viewDidAppear
- (void)viewDidLoad {

}


@end
