//
// File:	   TrillSelectionViewController.m
//
// Abstract:   The view controller for page one of this sample.
//

#import "TrillSelectionViewController.h"
#import "TrillChartViewController.h"
#import "AboutViewController.h"
#import "Constants.h"
#import "Instrument.h"

@implementation TrillSelectionViewController

@synthesize notesView, myView, myView2, myView3, instrument, progressView, scrollView, targetViewController;

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	//NSLog(@"scrolling started");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate	{
	//NSLog(@"scrolling stopping");
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	//NSLog(@"scrolling done");
}

- (void) selectedNote:(NSInteger)theNoteIndex instrument:(Instrument *)theInstrument {
	
	if (targetViewController == nil) {
		targetViewController = [[TrillChartViewController alloc] initWithNibName:@"TrillChartViewController" 
                                                                        bundle:nil 
                                                                    instrument: theInstrument 
                                                                          note:theNoteIndex];
	}
	[[self navigationController] pushViewController:targetViewController animated:YES];
	[targetViewController release];
	targetViewController = nil;
}
 
- (void) initNotes {
		
	double width = (74 * ((instrument.maxTrillNote - instrument.minTrillNote)+1))+5;
	
	int startingNote = 29;
	
	if ([instrument.clef isEqualToString:@"TC"]) {			
		startingNote = 21;
	} 		
	
	notesView = [[TrillNotesView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 153.0)];
	notesView.backgroundColor = [UIColor clearColor];
	notesView.instrument = self.instrument;
	[notesView initNotes];
	notesView.delegate = self;
	//notesView.hidden = YES;
	notesView.alpha = 0;
	
	// a page is the width of the scroll view
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(32.0, 40.0 + AD_HEIGHT, 288.0, 153.0)];
	scrollView.pagingEnabled = NO;
	//scrollView.clipsToBounds = YES;
	scrollView.contentSize = CGSizeMake(width, 153.0);
	scrollView.showsHorizontalScrollIndicator = YES;
	scrollView.showsVerticalScrollIndicator = YES;
	//scrollView.scrollsToTop = YES;
	scrollView.delegate = self;		
	
	[scrollView addSubview:notesView];
	
	NSLog(@"Getting scroll position prefs");
	CFStringRef prefs = (CFStringRef)CFPreferencesCopyAppValue((CFStringRef)[self.instrument.name stringByAppendingString:@"2"], kCFPreferencesCurrentApplication);
	
	if (prefs) {
		NSString *scrollPrefs = (NSString *)prefs;
		CFRelease(prefs);

		// scroll to the start note
		[scrollView setContentOffset:CGPointMake([scrollPrefs doubleValue],0.0)];
		
	} else {
		
		// scroll to the start note
		[scrollView setContentOffset:CGPointMake((74*(startingNote-instrument.minTrillNote)),0)];
		
	}
	
	
	//create a view for rear blank
	myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, AD_HEIGHT-1, 420.0, 420.0)];
	//create an image view
	UIImageView *myImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"html/large_blank.png"]] autorelease];
	//add image view to view
	[myView addSubview:myImageView];
	//add view to window
	[self.view addSubview:myView];	
	
	[self.view addSubview:scrollView];
	
	//create a view for note clef
	myView2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 80.0 + AD_HEIGHT, 32.0, 113.0)];
	//create an image view
	UIImageView *myImageView2 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[[@"html/clefs/" stringByAppendingString: instrument.clef] stringByAppendingString:@".gif"]]] autorelease];
	//add image view to view
	[myView2 addSubview:myImageView2];
	//[self.view bringSubviewToFront:myImageView2];
	//add view to window
	myView2.hidden = YES;
	[self.view addSubview:myView2];	
	
	//create a view for top blank
	myView3 = [[UIView alloc] initWithFrame:CGRectMake(0.0, AD_HEIGHT, 32.0, 40.0)];
	//create an image view
	UIImageView *myImageView3 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"html/top_left_blank.gif"]] autorelease];
	//add image view to view
	[myView3 addSubview:myImageView3];
	//[self.view bringSubviewToFront:myImageView3];
	//add view to window
	myView3.hidden = YES;
	[self.view addSubview:myView3];	
	
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
	labelS.text = @"Tap the measure to see the trill fingering";
	[self.view addSubview:labelS];	
	[labelS release];
	
}

- (id)init
{
	self = [super initWithNibName:@"TrillSelectionViewController" bundle: nil];
	if (self)
	{
		// this will appear as the title in the navigation bar
		self.instrument = [Instrument currentInstrument];
		self.title = self.instrument.name;

		self.view.autoresizesSubviews = YES;
		
		//[self initNotes];
		
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
	NSString *t = [NSString stringWithFormat:@"%f",scrollView.contentOffset.x];
	CFPreferencesSetAppValue((CFStringRef)[instrument.name stringByAppendingString:@"2"], (CFStringRef)t, kCFPreferencesCurrentApplication);
	CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);	
	
	if (notesView != nil) {
		[notesView removeFromSuperview];
		[notesView release];
		notesView = nil;
	}
	if (myView != nil) {
		[myView removeFromSuperview];
		[myView release];
		myView = nil;
	}
	if (myView2 != nil) {
		[myView2 removeFromSuperview];
		[myView2 release];
		myView2 = nil;
	}
	if (myView3 != nil) {
		[myView3 removeFromSuperview];
		[myView3 release];
		myView3 = nil;
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
	myView2.hidden = NO;
	myView3.hidden = NO;
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
