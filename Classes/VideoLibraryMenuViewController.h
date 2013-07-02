//
//  VideoLibraryMenuViewController.h
//  Simple Table
//

#import <UIKit/UIKit.h>

#import "LibraryMenuViewController.h"

@interface VideoLibraryMenuViewController : LibraryMenuViewController <UIWebViewDelegate>
{   
	NSMutableArray			*urlArray;
	NSMutableArray			*categoryArray;
	NSString				*category;
   UIWebView *mediaWebView;
}

@property (nonatomic, retain) NSString                  *category;
@property (nonatomic, retain) NSMutableArray              *urlArray;
@property (nonatomic, retain) NSMutableArray              *categoryArray;
@property (nonatomic, retain) UIWebView *mediaWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil instrument:(NSString *)instrumentString category: (NSString *)category;
- (IBAction)loadVideo;

- (void) playAudio:(UIButton *)sender;

@end
