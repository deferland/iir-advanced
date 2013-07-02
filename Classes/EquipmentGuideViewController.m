//
// File:	   EquipmentGuideViewController.m
//
// Abstract:   The view controller for page two of this sample.

#import "EquipmentGuideViewController.h"
#import "AboutViewController.h"
#import "Constants.h"

@implementation EquipmentGuideViewController

@synthesize webView, instrument, clef;


- (void)loadURL:(NSString *)urlToLoad {
		 
	NSLog(@"loadInstrument");		
	NSString *htmPath = [[NSBundle mainBundle] pathForResource:urlToLoad ofType:nil inDirectory: @"html"];
	NSString *fileURLString = [[NSURL fileURLWithPath:htmPath] absoluteString];
	NSString *params = @"";
	NSURL *fileURL = [NSURL URLWithString:[fileURLString stringByAppendingString:params]];
	[webView loadRequest:[NSURLRequest requestWithURL:fileURL]];			
	
}

- (void) viewDidLoad {
   [super viewDidLoad];
   
   // this will appear as the title in the navigation bar
   self.title = self.instrument;
   
   // important for view orientation rotation
   self.view.autoresizesSubviews = YES;
   
   self.webView = [[[UIWebView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)] autorelease];
   
   [self.view addSubview:webView];
   
   if ([self.instrument isEqualToString:@"Professional Saxophones"]) {
      [self loadURL:@"test.html"];
   } 			
   
}

- (void)dealloc
{
   self.webView = nil;
   self.instrument = nil;
   self.clef = nil;
	
	[super dealloc];
}

- (void)action:(id)sender
{
	// the custom icon button was clicked, handle it here
	//
}

@end
