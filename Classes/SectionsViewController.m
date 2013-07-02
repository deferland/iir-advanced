//
//  SectionsAppDelegate.m
//  Sections
//
//  Created by Jeff LaMarche on 7/10/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "SectionsViewController.h"
#import "AboutViewController.h"
#import "NSDictionary-MutableDeepCopyOfArrays.h"
#import "MusicalTermTableCell.h"
#import "AdViewController.h"

@implementation SectionsViewController
@synthesize table;
@synthesize search;
@synthesize names;
@synthesize keys;
@synthesize allNames;


#pragma mark -
#pragma mark Custom Methods
- (void)resetSearch
{
	self.names = [self.allNames mutableDeepCopyOfArrays];
	//self.names = [self.allNames mutableDeepCopy];

	NSMutableArray *keyArray = [[NSMutableArray alloc] init];
	[keyArray addObjectsFromArray:[[self.allNames allKeys] sortedArrayUsingSelector:@selector(compare:)]];
	self.keys = keyArray;
	[keyArray release];
}
- (void)handleSearchForTerm:(NSString *)searchTerm
{
	NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
	[self resetSearch];
	
	//NSLog(@"getting this far?");
	
	for (NSString *key in self.keys)
	{
		// names
		NSMutableArray *array = [self.names valueForKey:key];
		NSMutableArray *toRemove = [[NSMutableArray alloc] init];

		for (NSDictionary *dict4 in array) 
		{
			
			for (id key2 in dict4) 
			{
				//NSLog(@"key: %@, value: %@", key, [dict2 objectForKey:key]);
				if ([(NSString *)key2 isEqualToString:@"name"]) {
					if ([[NSString stringWithString:(NSString *)[dict4 objectForKey:key2]] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound)
						//NSLog([NSString stringWithFormat:@"remove %@", itemName]);
						[toRemove addObject:dict4];
				}
			}
			
		}
		
		//for (NSString *name in array)
		//{
		//	if ([name rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound)
		//		[toRemove addObject:name];
		//}
		
		if ([array count] == [toRemove count])
			[sectionsToRemove addObject:key];
		
		[array removeObjectsInArray:toRemove];
		[toRemove release];
		
	}
	[self.keys removeObjectsInArray:sectionsToRemove];
	[sectionsToRemove release];
	[table reloadData];
}
#pragma mark -
#pragma mark UIViewController Methods

- (id)init
{
	if (self = [super initWithNibName:@"SectionsViewController" bundle: nil])
	{
		// init code
	}
	return self;
}

- (void)viewDidLoad {
   [super viewDidLoad];
   self.adViewController.loadViewFromBottom = YES;
	
	// this will appear as the title in the navigation bar
	self.title = @"Musical Terms";
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"sortednames" ofType:@"plist"];
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
	self.allNames = dict;
	
	[dict release];

	[self resetSearch];
	search.autocapitalizationType = UITextAutocapitalizationTypeNone;
	search.autocorrectionType = UITextAutocorrectionTypeNo;
}
 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {;
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[table release];
	[search release];
	[allNames release];
	[keys release];
	[names release];
	[super dealloc];
	
}
#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return ([keys count] > 0) ? [keys count] : 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	if ([keys count] == 0)
		return 0;
	NSString *key = [keys objectAtIndex:section];
	NSArray *nameSection = [names objectForKey:key];
	return [nameSection count];
}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];

	NSString *key = [keys objectAtIndex:section];	
	NSArray *nameSection = [names objectForKey:key];
	
	static NSString *sectionsTableIdentifier = @" sectionsTableIdentifier ";
	
	MusicalTermTableCell *cell = (MusicalTermTableCell *) [aTableView dequeueReusableCellWithIdentifier: sectionsTableIdentifier];
	if (cell == nil) {
		cell = [[[MusicalTermTableCell alloc] initWithReuseIdentifier: sectionsTableIdentifier] autorelease];
	}
	
	NSDictionary *dict2 = [[NSDictionary alloc] initWithDictionary:[nameSection objectAtIndex:row]];
	
	for (id key in dict2)
	{
		if ([(NSString *)key isEqualToString:@"name"]) {
			cell.termText = [NSString stringWithString:(NSString *)[dict2 objectForKey:key]];
		}
		if ([(NSString *)key isEqualToString:@"description"]) {
			cell.descriptionText = [NSString stringWithString:(NSString *)[dict2 objectForKey:key]];
		}
		if ([(NSString *)key isEqualToString:@"image"]) {
			cell.imageName = [NSString stringWithString:(NSString *)[dict2 objectForKey:key]];
		}
	}
	return cell;
	
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ([keys count] == 0)
		return @"";
	
	NSString *key = [keys objectAtIndex:section];
	return key;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   MusicalTermTableCell *cell = (MusicalTermTableCell *) [self tableView: tableView cellForRowAtIndexPath: indexPath];
   return [cell rowHeight];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{

	return keys;
}
#pragma mark -
#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[search resignFirstResponder];
	return indexPath;
}
#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	NSString *searchTerm = [searchBar text];
	[self handleSearchForTerm:searchTerm];
	[search resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm
{
	int length = [[searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length];

	if (length == 0 || searchTerm == nil)
	{	
		[self resetSearch];
		[table reloadData];
		return;
	}
	[self handleSearchForTerm:searchTerm];
		
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	search.text = @"";
	[self resetSearch];
	[table reloadData];
	[searchBar resignFirstResponder];
}

@end
