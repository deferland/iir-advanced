//
//  MenuViewController.m
//  Simple Table
//

#import "MenuViewController.h"
#import "NoteSelectionViewController.h"
#import "TrillSelectionViewController.h"
#import "VideoCategoryMenuViewController.h"
#import "AboutViewController.h"
#import "Constants.h"
#import "SectionsViewController.h"
#import "PracticeMenuViewController.h"
#import "UIFont+LookAndFeel.h"
#import "Instrument.h"

@implementation MenuViewController

@synthesize contents, instrument;

#pragma mark UIViewController methods


- (void)viewDidLoad
{
   [super viewDidLoad];
   self.instrument = [Instrument currentInstrument];
   self.title = @"Main Menu";
   self.view.autoresizesSubviews = NO;

	if ([Instrument currentInstrument].maxTrillNote == 0 && [Instrument currentInstrument].minTrillNote == 0) {
		contents = [[NSArray alloc] initWithObjects:
                  @"NoteSelectionViewController", @"Fingering chart", 
                  @"SectionsViewController", @"Musical terms", 
                  @"PracticeMenuViewController", @"Audio Files", 
                  @"VideoCategoryMenuViewController", @"Videos", 
                  @"FileResourceBasedMenuController", @"Equipment Guide", 
                  nil];
	} else {
		contents = [[NSArray alloc] initWithObjects:
                  @"NoteSelectionViewController", @"Fingering chart", 
                  @"TrillSelectionViewController", @"Trill chart", 
                  @"SectionsViewController", @"Musical terms", 
                  @"PracticeMenuViewController", @"Audio Files", 
                  @"VideoCategoryMenuViewController", @"Videos", 
                  @"FileResourceBasedMenuController", @"Equipment Guide", 
                  nil];
	}
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.contents count]/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:SimpleTableIdentifier] autorelease];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	// Set up the cell
	
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [contents objectAtIndex:row*2 + 1];
	cell.textLabel.font = [UIFont menuFont];
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	
	Class cls = NSClassFromString([contents objectAtIndex:row*2]);
	
	UIViewController *viewController = [[cls alloc] init];
	[[self navigationController] pushViewController:viewController animated:YES];
   viewController.title = [contents objectAtIndex: row*2 + 1];
	[viewController release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark lifecycle



- (void)dealloc {
   self.contents = nil;
   self.instrument = nil;
	[super dealloc];
	
}




@end
