//
// File:	   InstrumentListController.m
//
// Abstract:   The application's main view controller (front page).

#import "InstrumentListViewController.h"

#import "MenuViewController.h"
#import "AboutViewController.h"

#import "InstrumentListCell.h"
#import "Constants.h"	// contains the dictionary keys
#import "AppDelegate.h"
#import "Instrument.h"

enum PageIndices
{
	kPageOneIndex	= 0
};

@implementation InstrumentListViewController

- (void) viewDidLoad {
   [super viewDidLoad];
   instruments = [Instrument instrumentList];
   [instruments retain];
   self.title = @"Instruments";
}

- (void) viewDidUnload {
   [instruments release];
}

- (void)dealloc
{
	[super dealloc];
}


#pragma mark UITableView delegates

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [Instrument setCurrentInstrumentName: [instruments objectAtIndex: indexPath.row]];
	[tableView reloadData];
}

#pragma mark UITableView datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [instruments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	InstrumentListCell *thisCell = (InstrumentListCell*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (thisCell == nil)
	{
		thisCell = [[[InstrumentListCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
	}
   NSString *selectedItem = (NSString *) [instruments objectAtIndex: indexPath.row];
   if ([selectedItem isEqualToString: [[Instrument currentInstrument] name]]) {
      thisCell.accessoryType = UITableViewCellAccessoryCheckmark;      
   } else {
      thisCell.accessoryType = UITableViewCellAccessoryNone;
   }
   
	// get the view controller's info dictionary based on the indexPath's row
	thisCell.nameLabel.text = selectedItem;
	
	return thisCell;
}

@end

