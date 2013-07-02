//
// File:	   AppDelegate.m
//
// Abstract:   The application delegate class used for installing our navigation controller.
//
// Version:    1.7
//
// Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc. ("Apple")
//             in consideration of your agreement to the following terms, and your use,
//             installation, modification or redistribution of this Apple software
//             constitutes acceptance of these terms.  If you do not agree with these
//             terms, please do not use, install, modify or redistribute this Apple
//             software.
//
//             In consideration of your agreement to abide by the following terms, and
//             subject to these terms, Apple grants you a personal, non - exclusive
//             license, under Apple's copyrights in this original Apple software ( the
//             "Apple Software" ), to use, reproduce, modify and redistribute the Apple
//             Software, with or without modifications, in source and / or binary forms;
//             provided that if you redistribute the Apple Software in its entirety and
//             without modifications, you must retain this notice and the following text
//             and disclaimers in all such redistributions of the Apple Software. Neither
//             the name, trademarks, service marks or logos of Apple Inc. may be used to
//             endorse or promote products derived from the Apple Software without specific
//             prior written permission from Apple.  Except as expressly stated in this
//             notice, no other rights or licenses, express or implied, are granted by
//             Apple herein, including but not limited to any patent rights that may be
//             infringed by your derivative works or by other works in which the Apple
//             Software may be incorporated.
//
//             The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
//             WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
//             WARRANTIES OF NON - INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
//             PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION
//             ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//
//             IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
//             CONSEQUENTIAL DAMAGES ( INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//             SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//             INTERRUPTION ) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION
//             AND / OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER
//             UNDER THEORY OF CONTRACT, TORT ( INCLUDING NEGLIGENCE ), STRICT LIABILITY OR
//             OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Copyright (C) 2008 Apple Inc. All Rights Reserved.
//

#import "AppDelegate.h"
#import "InstrumentListViewController.h"
#import "ACAboutViewController.h"
#import "MenuViewController.h"
#import "MessageBoardViewController.h"
#import "DTButton.h"

#import "DataSource.h"

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate {
	return (AppDelegate *)[AppDelegate sharedDelegate];
}


- (void) setUpTabBarController
{
	self.tabBarController = [[UITabBarController alloc] initWithNibName: nil bundle: nil];
	tabBarController.view.backgroundColor = [UIColor blackColor];
	tabBarController.delegate = self;
	
	// *** Home ***
	MenuViewController *menuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" 
                                                                                  bundle:nil];
	
	UINavigationController *menuNav = [[UINavigationController alloc] initWithRootViewController: menuViewController];
	[menuViewController release];
	menuNav.title = @"Main Menu";
	menuNav.tabBarItem.image = [UIImage imageNamed: @"HomeIcon.png"];
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
	menuNav.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	InstrumentListViewController *instrumentListViewController = [[InstrumentListViewController alloc] initWithNibName:@"InstrumentListViewController" bundle: nil];
   instrumentListViewController.view;
	instrumentListViewController.title = @"Instruments";
	instrumentListViewController.tabBarItem.image = [UIImage imageNamed: @"BrowseIcon.png"];
    

   MessageBoardViewController *messages = [[MessageBoardViewController alloc] initWithNibName: @"MessageBoardViewController" bundle: nil];
//#define LOCAL_MESSAGES 1
#ifdef LOCAL_MESSAGES
   messages.url = [NSURL URLWithString: @"http://172.16.1.4/phpBB3"];
#else
   NSURL *baseURL = [NSURL URLWithString: @"http://www.instrumentsinreach.com/"];
   messages.url = [NSURL URLWithString: [[[Instrument currentInstrument] cmsName] lowercaseString] relativeToURL: baseURL];
#endif
   messages.title = @"Message Board";
	messages.tabBarItem.image = [UIImage imageNamed: @"chat.png"];
	
	ACAboutViewController *aboutController = [[ACAboutViewController alloc] initWithNibName: @"ACAboutViewControllerView" bundle: nil];
	aboutController.title = @"About";
	aboutController.tabBarItem.image = [UIImage imageNamed: @"AboutIcon.png"];
	
	NSArray *subcontrollers = [[NSArray alloc] initWithObjects: menuNav, messages, instrumentListViewController, aboutController, nil];
	[menuNav release];
	[instrumentListViewController release];
   [messages release];
	[aboutController release];
	
	self.tabBarController.viewControllers = subcontrollers;
	[subcontrollers release];
	
	int instrumentCount = [[Instrument instrumentList] count];
	if ( [[[DataSource data] objectForKey:@"FirstRun"] intValue] == 1 && instrumentCount != 1 )
		self.tabBarController.selectedIndex = 2;
	else
		self.tabBarController.selectedIndex = 0;
	
	[[DataSource data] setObject:@"0" forKey:@"FirstRun"];
	
	[[DataSource source] saveData];
}

#define OK_BUTTON_WIDTH 160.0
- (UIButton *) firstTimeContinueButton {
   DTButton *button = [DTButton buttonWithType: UIButtonTypeCustom];
   button.frame = CGRectMake(160.0 - OK_BUTTON_WIDTH/2, 417.0, OK_BUTTON_WIDTH, 40.0);
   [button setTitle: @"Continue" forState: UIControlStateNormal];
   [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
   button.backgroundColor = [UIColor colorWithName: @"darkgreen"];
   [button addTarget: self action: @selector(hideSplash) forControlEvents: UIControlEventTouchUpInside];
   return button;
}

- (void) decorateNavigationController: (UINavigationController *)controller 
{
	controller.navigationBar.barStyle = UIBarStyleBlack;
	controller.navigationBar.translucent = NO;
	//controller.navigationBar.tintColor = [LookAndFeel primaryColor];
}

@end
