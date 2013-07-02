
#import "FileResourceBasedMenuController.h"
#import "FileResourceViewController.h"
#import "UIFont+LookAndFeel.h"

@implementation FileResourceBasedMenuController

@synthesize items, tableView, fileMenuItem;

- (id) init {
   #ifdef SAXOPHONE
      NSString *rootDir = [[NSBundle mainBundle] pathForResource: @"ResourcesMenu_saxophone" ofType: nil];
   #endif
   #ifdef FLUTE
      NSString *rootDir = [[NSBundle mainBundle] pathForResource: @"ResourcesMenu_flute" ofType: nil];
   #endif
   #ifdef TROMBONE
      NSString *rootDir = [[NSBundle mainBundle] pathForResource: @"ResourcesMenu_trombone" ofType: nil];
   #endif	
   #ifdef TRUMPET
      NSString *rootDir = [[NSBundle mainBundle] pathForResource: @"ResourcesMenu_trumpet" ofType: nil];
   #endif
   #ifdef CLARINET
      NSString *rootDir = [[NSBundle mainBundle] pathForResource: @"ResourcesMenu_clarinet" ofType: nil];
   #endif
   FileResourceMenuItem *resourcesMenuItem = [[FileResourceMenuItem alloc] initWithPath: rootDir];
   resourcesMenuItem.title = @"Resources";
   self = [self initWithFileMenuItem: resourcesMenuItem];
   [resourcesMenuItem release];
   return self;
}

- (id) initWithFileMenuItem: (FileResourceMenuItem *) myFileMenuItem {
	if (self = [self initWithNibName: @"FileResourceBasedMenuController" bundle: nil]) {
		self.fileMenuItem = myFileMenuItem;
		self.items = [NSMutableArray array];
		NSFileManager *fileMgr = [NSFileManager defaultManager];
		NSEnumerator *dirEnum = [[fileMgr directoryContentsAtPath: self.fileMenuItem.path] objectEnumerator];
		NSString *file;
		while (file = [dirEnum nextObject]) {
			FileResourceMenuItem *menuItem = [[FileResourceMenuItem alloc] initWithPath: [self.fileMenuItem.path stringByAppendingPathComponent: file]];
			if (menuItem.controllerClass) {
				[self.items addObject: menuItem];            
			}
			[menuItem release];
		}
      [self.items sortUsingSelector: @selector(compare:)];
		self.tabBarItem = [UITabBarItem itemNamed: self.fileMenuItem.title];
		self.title = self.fileMenuItem.title;
	}
	return self;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.items count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	FileResourceMenuItem *cellItem = [self.items objectAtIndex: indexPath.row];
	UITableViewCellStyle style;
	NSString *cellIdentifier;
	if (cellItem.description) {
		style = UITableViewCellStyleSubtitle;
		cellIdentifier = @"ACMenuControllerCellSubtitle";
	} else {
		style = UITableViewCellStyleDefault;
		cellIdentifier = @"ACMenuControllerCellDefault";
	}
	
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle: style reuseIdentifier: cellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.textLabel.text = cellItem.title;      
   cell.textLabel.font = [UIFont menuFont];
	cell.detailTextLabel.text = cellItem.description;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	FileResourceMenuItem *selectedItem = [self.items objectAtIndex: indexPath.row];
	UIViewController *nextViewController = [[[selectedItem.controllerClass class] alloc] initWithFileMenuItem: selectedItem];
	[self.navigationController pushViewController: nextViewController animated: YES];
	[nextViewController release];
}


#pragma mark Memory

- (void)dealloc {
	self.items = nil;
	self.fileMenuItem = nil;
	[super dealloc];
}

@end

