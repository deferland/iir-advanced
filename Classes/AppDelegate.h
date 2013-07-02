
#import <UIKit/UIKit.h>

#import "ACTabbedAppDelegate.h"
#import "Instrument.h"

@class InstrumentListViewController;

@interface AppDelegate : ACTabbedAppDelegate
{
   
}

+ (AppDelegate *)sharedAppDelegate;
-(void) decorateNavigationController: (UINavigationController *)controller;

@end
