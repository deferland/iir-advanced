#import "AboutViewController.h"
#import "Constants.h"

@implementation AboutViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		// this will appear as the title in the navigation bar
		self.title = @"About";
		
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 392.0)];
		scrollView.pagingEnabled = NO;
		scrollView.contentSize = CGSizeMake(320, 480.0);
		scrollView.showsVerticalScrollIndicator = YES;
		scrollView.scrollsToTop = YES;
		scrollView.delegate = self;		
		
		instructionsView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"screenIIR2.png" ofType:nil]]];
		
		[scrollView addSubview:instructionsView];
		
		instructionsView.userInteractionEnabled = NO;
		scrollView.userInteractionEnabled = YES;
		
		[self.view addSubview:scrollView];
		
		[self.view bringSubviewToFront:scrollView];
	}
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

// fetch objects from our bundle based on keys in our Info.plist
- (id)infoValueForKey:(NSString*)key
{
	if ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key])
		return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

// Automatically invoked after -loadView
// This is the preferred override point for doing additional setup after -initWithNibName:bundle:
//
- (void)viewDidLoad
{
	version.text = @"Version 1.0";
}

- (IBAction)dismissAction:(id)sender
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
	// do something here as our view re-appears
   NSLog(@"View appeared");
}

@end
