//
// File:	   FingeringChartViewController.m
//
// Abstract:   The view controller for page two of this sample.

#import "NoteSelectionViewController.h"
#import "FingeringChartViewController.h"
#import "AboutViewController.h"
#import "Constants.h"

#define UP_SEGMENT 0
#define DOWN_SEGMENT 1

const CGFloat kScrollObjHeight2	= 360.0;
const CGFloat kScrollObjWidth2	= 240.0;

@implementation FingeringChartViewController

@synthesize instrument, noteIndex, segmentedControl, segmentBarItem, scrollView;
@synthesize rightView, leftView, rightView2, leftView2, scrollPosition;

- (void) scrollViewWillBeginDragging:(UIScrollView *)aScrollView {
	NSLog(@"scrolling started");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate	{
	NSLog(@"scrolling stopping");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
	NSLog(@"scrolling done");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil noteIndex: (NSInteger)note
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		
		self.instrument = [Instrument currentInstrument];
		self.noteIndex = note;
		
		scrollPosition = 0;
		
	}
	
	[self initImages];
	
	return self;
}

- (void) drawImages
{
	
	if (scrollView != nil) {
		[scrollView removeFromSuperview];
		[scrollView release];
		scrollView = nil;
	}
	
	// this will appear as the title in the navigation bar
	self.title = [self.instrument enharmonicLabelForIndex: self.noteIndex];
	
	// important for view orientation rotation
	self.view.autoresizesSubviews = YES;
	
	// a page is the width of the scroll view
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(42.0, 20.0, 240.0, 360.0)];
	// pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
	// if you want free-flowing scroll, don't set this property.
	scrollView.pagingEnabled = YES;
	scrollView.contentSize = CGSizeMake(240.0, 360.0);
	scrollView.showsHorizontalScrollIndicator = YES;
	scrollView.showsVerticalScrollIndicator = YES;
	//scrollView.scrollsToTop = YES;
	scrollView.delegate = self;		
	[scrollView setBackgroundColor:[UIColor whiteColor]];
	[scrollView setCanCancelContentTouches:NO];
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	scrollView.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	scrollView.scrollEnabled = YES;
	
	NSArray *fingeringCharts = [self.instrument noteFingeringChartsForIndex: self.noteIndex];
	for (int i=0; i< [fingeringCharts count]; i++) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[fingeringCharts objectAtIndex: i]];
		[imageView setContentMode:UIViewContentModeCenter];
		CGRect rect = imageView.frame;
		rect.size.height = kScrollObjHeight2;
		rect.size.width = kScrollObjWidth2;
		rect.origin.x = kScrollObjWidth2*i;
		imageView.frame = rect;
		imageView.tag = i+1;	// tag our images for later use when we place them in serial fashion
		[scrollView addSubview:imageView];
		[imageView release];
		
	}
	
	[scrollView setContentSize:CGSizeMake(( [fingeringCharts count] * kScrollObjWidth2), kScrollObjHeight2)];
	
	
	// place arrows to guide scrolling
	
	for (int i=1; i<[fingeringCharts count]; i++) {
		rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"html/right.png"]];
		rightView.frame = CGRectMake((kScrollObjWidth2*i)-34, (kScrollObjHeight2/2)-15.0, 24.0, 30.0);
		
		[scrollView addSubview:rightView];
		
		leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"html/left.png"]];
		leftView.frame = CGRectMake((kScrollObjWidth2*i)+10.0, (kScrollObjHeight2/2)-15.0, 24.0, 30.0);
		
		[scrollView addSubview:leftView];	
	}

	[scrollView setContentOffset:CGPointMake(0,0)];		
	
	[self.view addSubview:scrollView];
	
	
}	

- (void) initImages
{
	[self drawImages];
	
	// "Segmented" control to the right
	segmentedControl = [[UISegmentedControl alloc] initWithItems:
						[NSArray arrayWithObjects:
						 [UIImage imageNamed:@"up.png"],
						 [UIImage imageNamed:@"down.png"],
						 nil]];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 90, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	//segmentedControl.tintColor = [UIColor blackColor];
	
	defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
	
	segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
	segmentBarItem.style = UIBarStyleBlackOpaque;
	self.navigationItem.rightBarButtonItem = segmentBarItem;	
	
	if (self.noteIndex == instrument.minNote) {
		[self.segmentedControl setEnabled:NO forSegmentAtIndex:1];
	} else {
		if (self.noteIndex < instrument.minNote) {
			[self.segmentedControl setEnabled:NO forSegmentAtIndex:1];
		} else {
			[self.segmentedControl setEnabled:YES forSegmentAtIndex:1];
		}
	}		
	if (self.noteIndex == instrument.maxNote) {
		[self.segmentedControl setEnabled:NO forSegmentAtIndex:0];
	} else {
		if (self.noteIndex >= instrument.maxNote) {
			[self.segmentedControl setEnabled:NO forSegmentAtIndex:0];
		} else {
			[self.segmentedControl setEnabled:YES forSegmentAtIndex:0];
		}
	}		
	
}

- (BOOL) nextNoteIsEnharmonic:(int) index {
	int tmp = index%17; 
	return ( tmp == 2 || tmp == 5 || tmp == 8 || tmp == 12 || tmp == 15 );
}

- (BOOL) prevNoteIsEnharmonic:(int)index {
	int tmp = index%17; 
	return ( tmp == 3 || tmp == 6 || tmp == 9 || tmp == 13 || tmp == 16 );
}

- (void)segmentAction:(id)sender
{
	UISegmentedControl* segCtl = sender;
	// the segmented control was clicked, handle it here 
	
	//NSString *currentNoteString = [noteNames objectAtIndex:noteNum];
	
	if ([segCtl selectedSegmentIndex] == 1) {
		if (noteIndex > instrument.minNote) {
			if ([self prevNoteIsEnharmonic:noteIndex])
				noteIndex -=2;
			else
				noteIndex --;
		}
	} else {
		if (noteIndex < instrument.maxNote) {
			if ([self nextNoteIsEnharmonic:noteIndex])
				noteIndex += 2;
			else
				noteIndex ++;
		}
	}
	
	
	self.title = [instrument enharmonicLabelForIndex: noteIndex];
	
	[self.segmentedControl setEnabled: (noteIndex >= instrument.minNote) forSegmentAtIndex: DOWN_SEGMENT];
	[self.segmentedControl setEnabled: (noteIndex <= instrument.maxNote) forSegmentAtIndex: UP_SEGMENT];
	
	[self drawImages];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) releaseImages
{
	
	//[webView release];
	if (instrument != nil) {
		[instrument release];
		instrument = nil;
	}
	if (segmentedControl != nil) {
		[segmentedControl release];
		segmentedControl = nil;
	}
	if (segmentBarItem != nil) {
		[segmentBarItem release];
		segmentBarItem = nil;
	}
	if (scrollView != nil) {
		[scrollView removeFromSuperview];
		scrollView.delegate = nil;
		[scrollView release];
		scrollView = nil;
	}
	if (rightView != nil) {
		[rightView removeFromSuperview];
		[rightView release];
		rightView = nil;
	}
	if (leftView != nil) {
		[leftView removeFromSuperview];
		[leftView release];
		leftView = nil;
	}
	if (rightView2 != nil) {
		[rightView2 removeFromSuperview];
		[rightView2 release];
		rightView2 = nil;
	}
	if (leftView2 != nil) {
		[leftView2 removeFromSuperview];
		[leftView2 release];
		leftView2 = nil;
	}
}

- (void)dealloc
{
	[self releaseImages];
	
	[super dealloc];
}


- (void)viewWillAppear:(BOOL)animated
{
	// before we show this view make sure the segmentedControl matches the nav bar style
	if (self.navigationController.navigationBar.barStyle == UIBarStyleBlackTranslucent ||
		self.navigationController.navigationBar.barStyle == UIBarStyleBlackOpaque) 
	{
		segmentedControl.tintColor = [UIColor darkGrayColor];
	}
	else
	{
		segmentedControl.tintColor = defaultTintColor;
	}
}

@end
