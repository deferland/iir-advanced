//
// File:	   TrillChartViewController.m
//
// Abstract:   The view controller for page two of this sample.

#import "TrillSelectionViewController.h"
#import "TrillChartViewController.h"
#import "AboutViewController.h"
#import "Constants.h"

const CGFloat kScrollObjHeight	= 360.0;
const CGFloat kScrollObjWidth	= 240.0;

@implementation TrillChartViewController

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil instrument:(Instrument *)myInstrument note:(NSInteger)myNoteIndex
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.instrument = myInstrument;
		self.noteIndex = myNoteIndex;
		
		
		rightView = nil;
		leftView = nil;
		rightView2 = nil;
		leftView2 = nil;
		
		scrollPosition = 0;
		
	}
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
	self.title = [self.instrument trillLabelForIndex: self.noteIndex];
   NSLog(@"Title: %@ noteIndex: %d", self.title, self.noteIndex);
	
	// important for view orientation rotation
	//webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);	
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
	
	NSArray *fingeringCharts = [self.instrument trillFingeringChartsForIndex: self.noteIndex];
	
	UIImageView *imageView = nil;
	for (int i=0; i< [fingeringCharts count]; i++) {
		imageView = [[UIImageView alloc] initWithImage:[fingeringCharts objectAtIndex: i]];
		CGRect rect = imageView.frame;
		rect.size.height = kScrollObjHeight;
		rect.size.width = kScrollObjWidth;
		rect.origin.x = kScrollObjWidth*i;
		imageView.frame = rect;
		imageView.tag = i+1;	// tag our images for later use when we place them in serial fashion
		[scrollView addSubview:imageView];
		[imageView release];
	}
	
	[scrollView setContentSize:CGSizeMake(( [fingeringCharts count] * kScrollObjWidth), kScrollObjHeight)];
	//[self layoutScrollImages];	// now place the photos in serial layout within the scrollview
	
	// place arrows to guide scrolling
	for (int i=1; i<[fingeringCharts count]; i++) {
		rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"html/right.png"]];
		rightView.frame = CGRectMake((kScrollObjWidth*i)-34, (kScrollObjHeight/2)-15.0, 24.0, 30.0);
		
		[scrollView addSubview:rightView];
		
		leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"html/left.png"]];
		leftView.frame = CGRectMake((kScrollObjWidth*i)+10.0, (kScrollObjHeight/2)-15.0, 24.0, 30.0);
		
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
	
	if (self.noteIndex == instrument.minTrillNote) {
		[self.segmentedControl setEnabled:NO forSegmentAtIndex:1];
	} else {
		[self.segmentedControl setEnabled:YES forSegmentAtIndex:1];
	}		
	if (self.noteIndex == instrument.maxTrillNote) {
		[self.segmentedControl setEnabled:NO forSegmentAtIndex:0];
	} else {
		[self.segmentedControl setEnabled:YES forSegmentAtIndex:0];
	}		
	
}

- (void)segmentAction:(id)sender
{
	UISegmentedControl* segCtl = sender;
	// the segmented control was clicked, handle it here 
	
	if ([segCtl selectedSegmentIndex] == 1) {
		if (self.noteIndex > instrument.minTrillNote) {
			noteIndex--;
		}
	} else {
		if (noteIndex < instrument.maxTrillNote) {
			noteIndex++;
		}			
	}
	
	self.title = [self.instrument trillLabelForIndex: noteIndex];
	
	if (noteIndex == instrument.minTrillNote) {
		[self.segmentedControl setEnabled:NO forSegmentAtIndex:1];
	} else {
		[self.segmentedControl setEnabled:YES forSegmentAtIndex:1];
	}		
	if (noteIndex == instrument.maxTrillNote) {
		[self.segmentedControl setEnabled:NO forSegmentAtIndex:0];
	} else {
		[self.segmentedControl setEnabled:YES forSegmentAtIndex:0];
	}		
	
	
	[self drawImages];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//return YES;
}

- (void) releaseImages
{
	
	NSLog(@"removing trillpagetwocontroller elements");
	
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
	NSLog(@"removing trillpagetwocontroller");
	
	[self releaseImages];
	
	[super dealloc];
}

// Automatically invoked after -loadView
// This is the preferred override point for doing additional setup after -initWithNibName:bundle:
//
- (void)viewDidLoad
{
	// add our custom image button as the nav bar's custom right view
	//UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"email.png"]
	//								style:UIBarButtonItemStyleBordered target:self action:@selector(action:)];
	//self.navigationItem.rightBarButtonItem = addButton;
	//[addButton release];
}

- (void)action:(id)sender
{
	// the custom icon button was clicked, handle it here
	//
}

- (void)viewDidAppear:(BOOL)animated
{
	// do something here as our view re-appears
	
}

- (void)viewDidDisappear:(BOOL)animated
{
	[self releaseImages];
}


- (void)viewWillAppear:(BOOL)animated
{
	[self initImages];
	
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
