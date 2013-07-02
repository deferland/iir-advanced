//
//  RootViewController.m
//  IiR
//
//  Created by jrtb on 9/15/08.
//  Copyright 2008 jrtb. All rights reserved.
//

#import "RootViewController.h"
#import "WebViewController.h"
#import "PrefsViewController.h"

@implementation RootViewController

@synthesize webViewController;
@synthesize prefsViewController;

- (void)loadWebViewController {
	WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"MusicView" bundle:nil];
	self.webViewController = viewController;
	self.webViewController.flipDelegate = self;
	[viewController release];
}

- (void)loadPrefsViewController {
	PrefsViewController *viewController = [[PrefsViewController alloc] initWithNibName:@"PrefsView" bundle:nil];
	self.prefsViewController = viewController;
	self.prefsViewController.flipDelegate = self;
	[viewController release];
}

- (void)viewDidLoad {
	[self loadWebViewController]; // Don't load the prefs view unless / until necessary
	[self.view addSubview:webViewController.view];	
}


// This method is called when either of the subviews send a delegate message to us.
// It flips the displayed view from the whoever sent the message to the other.
- (void)toggleView:(id)sender {
	if (prefsViewController == nil) {
		[self loadPrefsViewController];
	}
	
	UIView *webLView = webViewController.view;
	UIView *prefsLView = prefsViewController.view;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:((webViewController == sender) ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
	
	if (webViewController == sender) {
		//change the frame of one to match the other
		prefsLView.frame = webLView.frame;
		[prefsViewController viewWillAppear:YES];
		[webViewController viewWillDisappear:YES];
		[webLView removeFromSuperview];
		[self.view addSubview:prefsLView];
		[webViewController viewDidDisappear:YES];
		[prefsViewController viewDidAppear:YES];
		
	} else {
		//change the frame of one to match the other
		webLView.frame = prefsLView.frame;
		[webViewController viewWillAppear:YES];
		[prefsViewController viewWillDisappear:YES];
		[prefsLView removeFromSuperview];
		[self.view addSubview:webLView];
		[prefsViewController viewDidDisappear:YES];
		[webViewController viewDidAppear:YES];
	}
	[UIView commitAnimations];
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
	//	[webViewController release];
	//	[prefsViewController release];
	[super dealloc];
}


@end
