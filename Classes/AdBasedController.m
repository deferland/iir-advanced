    //
//  AdBasedController.m
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 4/17/10.
//  Copyright 2010 ZWorkbench, Inc. All rights reserved.
//

#import "AdBasedController.h"


@implementation AdBasedController

@synthesize adViewController, adHolder;

#pragma mark DTImageViewDelegate methods


- (void)imageViewDidFinishLoading:(DTImageView *)imageView {
   adLoaded = YES;
   if (viewShowing) {
      [self.adViewController logAdImpression];
      imageView.center = CGPointMake(imageView.center.x, imageView.center.y - imageView.frame.size.height);
      [UIView beginAnimations: @"imageView" context: nil];
      imageView.center = CGPointMake(imageView.center.x, imageView.center.y + imageView.frame.size.height);   
      [UIView commitAnimations];
   }
}

- (void)imageView:(DTImageView *)imageView didFailLoadingWithError:(NSError *)error {
   if (viewShowing) {
      adViewController.imageView.image = [UIImage imageNamed:@"bannerIIR.png"];
   }
}


#pragma mark UIViewController methods

- (void) viewDidLoad {
   [super viewDidLoad];
   adLoaded = NO;
   self.adViewController = [[[AdViewController alloc] initWithNibName:@"AdViewController" bundle:[NSBundle mainBundle]] autorelease];
   self.adViewController.imageView.delegate = self;
   self.adViewController.loadViewFromBottom = NO;   
   [self.adHolder addSubview: self.adViewController.view];
}

- (void) viewWillAppear:(BOOL)animated {
   [super viewWillAppear: animated];
}

- (void)viewDidAppear:(BOOL)animated {
   [super viewDidAppear:animated];
   if (adLoaded) {
      [self.adViewController logAdImpression];
   } else {
      [self.adViewController loadAd];  
   }
   viewShowing = YES;
}

- (void) viewDidDisappear:(BOOL)animated {
   [super viewDidDisappear: animated];
   viewShowing = NO;
}

- (void) viewDidUnload {
   [super viewDidUnload];
   self.adViewController = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark lifecycle

- (void)dealloc {
   self.adViewController = nil;
   self.adHolder = nil;
    [super dealloc];
}


@end
