//
//  PracticeMenuViewController.m
//  Simple Table
//

#import "PracticeMenuViewController.h"
#import "AudioLibraryMenuViewController.h"
#import "VideoLibraryMenuViewController.h"
#import "VideoPlaylistMenuViewController.h"
#import "AudioPlaylistMenuViewController.h"
#import "AboutViewController.h"
#import "Constants.h"
#import "EquipmentGuideViewController.h"
#import "UIFont+LookAndFeel.h"

@implementation PracticeMenuViewController

@synthesize listData, instrument, targetViewController4, bottomLevel;

#pragma mark Table view Controller Methods

- (id)init
{
	self = [self initWithNibName: @"PracticeMenuViewController" bundle: nil];
   return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   self.instrument = @"Audio Files";
   
   // this will appear as the title in the navigation bar
   if ([self.instrument isEqualToString:@"Saxophone"]) {
      self.title = @"Practice Resources";
   } else {
      self.title = self.instrument;
   }
   
   if ([self.instrument isEqualToString:@"Audio Files"] || [self.instrument isEqualToString:@"Videos"]) {
      self.bottomLevel = YES;
   } else {
      self.bottomLevel = NO;
   }
   
   // important for view orientation rotation
   self.view.autoresizesSubviews = YES;

	NSArray *array;
	
	if ([self.instrument isEqualToString:@"Audio Files"]) {
		array = [[NSArray alloc] initWithObjects:@"Get Audio Files", @"My playlist", nil];
	} else if ([self.instrument isEqualToString:@"Videos"]) {
		array = [[NSArray alloc] initWithObjects:@"Get Videos", @"My playlist", nil];
	}
	
	self.listData = array;
	[array release];
}

- (void)dealloc {
	
	if (targetViewController4 != nil) {
		[targetViewController4 release];
		targetViewController4 = nil;
	}
	
	[instrument release];
	[listData release];
	[super dealloc];

}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
				   reuseIdentifier:SimpleTableIdentifier] autorelease];
	}
	
	// Set up the cell
	
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [listData objectAtIndex:row];
	cell.textLabel.font = [UIFont menuFont];
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods


- (void)tableView:(UITableView *)tableView	didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];

	if (bottomLevel) {
		NSLog(@"BOTTOM");
	} else {
		NSLog(@"NOT BOTTOM");
	}			
	
	if (targetViewController4 == nil) {
		if (bottomLevel) {
			NSLog(@"click at bottomLevel");
			if ([self.instrument isEqualToString:@"Audio Files"]) {
				if (row == 0) {
					targetViewController4 = [[AudioLibraryMenuViewController alloc] initWithNibName:@"AudioLibraryMenuViewController" bundle:nil instrument: [self.listData objectAtIndex:row]];
					[[self navigationController] pushViewController:targetViewController4 animated:YES];
					[targetViewController4 release];
					targetViewController4 = nil;
				} else if (row == 1) {
					targetViewController4 = [[AudioPlaylistMenuViewController alloc] initWithNibName:@"AudioPlaylistMenuViewController" bundle:nil instrument: [self.listData objectAtIndex:row]];
					[[self navigationController] pushViewController:targetViewController4 animated:YES];
					[targetViewController4 release];
					targetViewController4 = nil;
				} else {
					
					NSString *rowValue = [listData objectAtIndex:row];
					
					NSString *message = [[NSString alloc] initWithFormat:@"You selected %@", rowValue];
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row Selected!"
																	message:message
																   delegate:nil
														  cancelButtonTitle:@"Yes I Did"
														  otherButtonTitles:nil];
					[alert show];
					
					[message release];
					[alert release];

				}
				
			} else if ([self.instrument isEqualToString:@"Videos"]) {
				
				if (row == 0) {
					targetViewController4 = [[VideoLibraryMenuViewController alloc] initWithNibName:@"VideoLibraryMenuViewController" bundle:nil instrument: [self.listData objectAtIndex:row]];
					[[self navigationController] pushViewController:targetViewController4 animated:YES];
					[targetViewController4 release];
					targetViewController4 = nil;
				} else if (row == 1) {
					targetViewController4 = [[VideoPlaylistMenuViewController alloc] initWithNibName:@"VideoPlaylistMenuViewController" bundle:nil];
               targetViewController4.instrument = [self.listData objectAtIndex:row];
					[[self navigationController] pushViewController:targetViewController4 animated:YES];
					[targetViewController4 release];
					targetViewController4 = nil;
				} else {
					
					NSString *rowValue = [listData objectAtIndex:row];
					
					NSString *message = [[NSString alloc] initWithFormat:@"You selected %@", rowValue];
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row Selected!"
																	message:message
																   delegate:nil
														  cancelButtonTitle:@"Yes I Did"
														  otherButtonTitles:nil];
					[alert show];
					
					[message release];
					[alert release];
					
				} 
			} else {
				
				NSString *rowValue = [listData objectAtIndex:row];
				
				NSString *message = [[NSString alloc] initWithFormat:@"You selected %@", rowValue];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row Selected!"
																message:message
															   delegate:nil
													  cancelButtonTitle:@"Yes I Did"
													  otherButtonTitles:nil];
				[alert show];
				
				[message release];
				[alert release];
				
			}
				
		} else {
			NSLog(@"click NOT at bottomLevel");
			targetViewController4 = [[PracticeMenuViewController alloc] initWithNibName:@"PracticeMenuViewController" bundle:nil instrument: [self.listData objectAtIndex:row]];
			[[self navigationController] pushViewController:targetViewController4 animated:YES];
			[targetViewController4 release];
			targetViewController4 = nil;
		}
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
