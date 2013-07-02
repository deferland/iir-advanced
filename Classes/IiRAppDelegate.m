//
//  IiRAppDelegate.m
//  IiR
//
//  Created by jrtb on 9/15/08.
//  Copyright jrtb 2008. All rights reserved.
//

#import "IiRAppDelegate.h"
#import "RootViewController.h"

@implementation IiRAppDelegate

@synthesize window;
@synthesize rootViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	[window addSubview:[rootViewController view]];
	[window makeKeyAndVisible];
}


- (void)dealloc {
	[rootViewController release];
	[window release];
	[super dealloc];
}


@end
