//
// File:	   NoteSelectionViewController.m
//
// Abstract:   The view controller for page one of this sample.
//

#import "NoteSelectionViewController.h"
#import "FingeringChartViewController.h"
#import "AboutViewController.h"
#import "Constants.h"

#define SCROLL_VIEW_Y 80.0
#define CLEF_VIEW_Y (SCROLL_VIEW_Y + 40.0)

@implementation NoteSelectionViewController

@synthesize notesView, blankView, clefView, topBlank, instrument, noteIndex, progressView, scrollView, targetViewController;

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	//NSLog(@"scrolling started");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate	{
	//NSLog(@"scrolling stopping");
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	//NSLog(@"scrolling done");
}

- (void) selectedNote: (NSInteger) note {
   self.noteIndex = note;
	if (targetViewController == nil) {
		targetViewController = [[FingeringChartViewController alloc] initWithNibName:@"FingeringChartViewController" bundle:nil noteIndex:note];
	}
	[[self navigationController] pushViewController:targetViewController animated:YES];
	[targetViewController release];
	targetViewController = nil;
}
 
- (void) initNotes {
	
	double width = (44 * ((instrument.maxNote - instrument.minNote)+1))+5;
	
	int startingNote = 29;
	
	if (instrument.trebleClef) {			
		startingNote = 21;
	} 		
	
	notesView = [[NotesView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 153.0)];
	notesView.backgroundColor = [UIColor clearColor];
	notesView.instrument = self.instrument;
	[notesView initNotes];
	notesView.delegate = self;
	//notesView.hidden = YES;
	notesView.alpha = 0;
	
	// a page is the width of the scroll view
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(32.0, SCROLL_VIEW_Y, 288.0, 153.0)];
	scrollView.pagingEnabled = NO;
	//scrollView.clipsToBounds = YES;
	scrollView.contentSize = CGSizeMake(width, 153.0);
	scrollView.showsHorizontalScrollIndicator = YES;
	scrollView.showsVerticalScrollIndicator = YES;
	//scrollView.scrollsToTop = YES;
	scrollView.delegate = self;		
	
	[scrollView addSubview:notesView];
	
	NSLog(@"Getting scroll position prefs");
	CFStringRef prefs = (CFStringRef)CFPreferencesCopyAppValue((CFStringRef)instrument, kCFPreferencesCurrentApplication);
	
	if (prefs) {
		NSString *scrollPrefs = (NSString *)prefs;
		CFRelease(prefs);

		// scroll to the start note
		[scrollView setContentOffset:CGPointMake([scrollPrefs doubleValue],0.0)];
	} else {
		// scroll to the start note
		[scrollView setContentOffset:CGPointMake((44*(startingNote-instrument.minNote)),0)];
	}
	
	
	//create a view for rear blank
	blankView = [[UIView alloc] initWithFrame:CGRectMake(0.0, AD_HEIGHT, 420.0, 420.0 - AD_HEIGHT)];
	//create an image view
	UIImageView *myImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"html/large_blank.png"]] autorelease];
	//add image view to view
	[blankView addSubview:myImageView];
	//[self.view sendSubviewToBack:myImageView];
	//add view to window
	//myView.hidden = YES;
	[self.view addSubview:blankView];	
	
	[self.view addSubview:scrollView];
	
	//create a view for note clef
	clefView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CLEF_VIEW_Y, 32.0, 113.0)];
	//create an image view
	UIImageView *myImageView2 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[[@"html/clefs/" stringByAppendingString: self.instrument.clef] stringByAppendingString:@".gif"]]] autorelease];
	//add image view to view
	[clefView addSubview:myImageView2];
	//[self.view bringSubviewToFront:myImageView2];
	//add view to window
	clefView.hidden = YES;
	[self.view addSubview:clefView];	
	
	//create a view for top blank
	topBlank = [[UIView alloc] initWithFrame:CGRectMake(0.0, AD_HEIGHT, 32.0, 40.0)];
	//create an image view
	UIImageView *myImageView3 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"html/top_left_blank.gif"]] autorelease];
	//add image view to view
	[topBlank addSubview:myImageView3];
	//[self.view bringSubviewToFront:myImageView3];
	//add view to window
	topBlank.hidden = YES;
	[self.view addSubview:topBlank];	
	
	progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 100, 30.0, 30.0)];
	progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	progressView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
									 UIViewAutoresizingFlexibleRightMargin |
									 UIViewAutoresizingFlexibleTopMargin |
									 UIViewAutoresizingFlexibleBottomMargin);
	
	[self.view bringSubviewToFront:progressView];
	[self.view addSubview:progressView];
	[progressView startAnimating];	
	
	//tap a note to see the instrument fingering
	UILabel *labelS =  [[UILabel alloc] initWithFrame:CGRectMake(0.0, 230.0, 320.0, 25.0)];
	labelS.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:14];
	labelS.textColor = [UIColor blackColor];
	labelS.backgroundColor = [UIColor clearColor];
	labelS.textAlignment = UITextAlignmentCenter;
	labelS.numberOfLines = 1;
	labelS.text = @"Tap a note to see the instrument fingering";
	[self.view addSubview:labelS];	
	[labelS release];
	
   //UIImageView *bannerView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bannerIIR.png"]] autorelease];
	//bannerView.frame = CGRectMake(0.0, 480.0 - kTabBarHeight - kBannerHeight - kNavBarHeight, 320.0, kBannerHeight);
	
	//[self.view addSubview:bannerView];
   
}
 
- (id)init
{
	self = [super initWithNibName:@"NoteSelectionViewController" bundle: nil];
	if (self)
	{
		// this will appear as the title in the navigation bar
		self.instrument = [Instrument currentInstrument];
		self.title = self.instrument.name;
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//return YES;
}

- (void) releaseNotes
{
	NSLog(@"releaseNotesView");
	
	NSLog(@"Setting scroll prefs");
	NSString *t = [NSString stringWithFormat:@"%f",scrollView.contentOffset.x];
	CFPreferencesSetAppValue((CFStringRef)instrument, (CFStringRef)t, kCFPreferencesCurrentApplication);
	CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);	
	
	if (notesView != nil) {
		[notesView removeFromSuperview];
		[notesView release];
		notesView = nil;
	}
	if (blankView != nil) {
		[blankView removeFromSuperview];
		[blankView release];
		blankView = nil;
	}
	if (clefView != nil) {
		[clefView removeFromSuperview];
		[clefView release];
		clefView = nil;
	}
	if (topBlank != nil) {
		[topBlank removeFromSuperview];
		[topBlank release];
		topBlank = nil;
	}
	if (progressView != nil) {
		[progressView removeFromSuperview];
		[progressView release];
		progressView = nil;
	}
	if (scrollView != nil) {
		[scrollView removeFromSuperview];
		[scrollView release];
		scrollView = nil;
	}

}

- (void)dealloc
{
	[self releaseNotes];

	[instrument release];
	
	[super dealloc];
}

// Automatically invoked after -loadView
// This is the preferred override point for doing additional setup after -initWithNibName:bundle:
//
- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)addAction:(id)sender
{
	// the add button was clicked, handle it here
	//
}

- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear: animated];
	[self initNotes];	
}	

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear: animated];
	[progressView stopAnimating];
	//myView.hidden = NO;
	clefView.hidden = NO;
	topBlank.hidden = NO;
	if (!notesView.drawn)
		[notesView drawNotes];
	notesView.alpha = 1;
		
}

- (void)viewDidDisappear:(BOOL)animated
{
   [super viewDidDisappear: animated];
	notesView.alpha = 0;
	
	[self releaseNotes];
}

@end
