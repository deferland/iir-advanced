//
// File:	   EquipmentGuideViewController.h
//
// Abstract:   The view controller for page two of this sample.

#import <UIKit/UIKit.h>
#import "AdBasedController.h"

@interface EquipmentGuideViewController : AdBasedController
{
	UIWebView							*webView;
	NSString							*instrument;	
	NSString							*clef;	
	CGImageRef							image;
	UIBarButtonSystemItem				currentSystemItem;
}

@property (nonatomic,retain) UIWebView									*webView;
@property (nonatomic,retain) NSString									*instrument;
@property (nonatomic,retain) NSString									*clef;

- (void)loadURL:(NSString *)urlToLoad;

@end
