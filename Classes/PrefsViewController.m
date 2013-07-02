//
//  PrefsViewController.m
//  locationPOC
//
//  Created by jrtb on 8/21/08.
//  Copyright 2008 jrtb. All rights reserved.
//

#import "PrefsViewController.h"

@implementation PrefsViewController

@synthesize flipDelegate, infoButtonLight, prefsLabelView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

// Tells the root view, via a delegate, to flip over to the FlipSideView
- (IBAction)infoButtonPressed:(id)sender {
	[self.flipDelegate toggleView:self];
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
}
 */


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
	[infoButtonLight release];
	[prefsLabelView release];
	[super dealloc];
}


@end
