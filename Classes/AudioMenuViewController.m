//
//  AudioMenuViewController.m
//  Simple Table
//

#import "AudioMenuViewController.h"
#import "PageSixViewController.h"
#import "Constants.h"
#import <MediaPlayer/MediaPlayer.h>

#import <SystemConfiguration/SystemConfiguration.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#import "Audio.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface AudioMenuViewController (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
@end

@implementation AudioMenuViewController

@synthesize listData, instrument, bottomLevel, fileList, receivedData, modalButton, progressAlert, progressView, totalFileSize, audios;

@synthesize numFiles, totalSize, ids, currentFile, idArray, currentSize, nameArray, descriptionArray, composerArray, performerArray, myTableView;

#pragma mark Table view Controller Methods

// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"audio.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"audio.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

// Open the database connection and retrieve minimal information for all objects.
- (void)initializeDatabase {
    NSMutableArray *audioArray = [[NSMutableArray alloc] init];
    self.audios = audioArray;
    [audioArray release];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"audio.sqlite"];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT pk FROM audio";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            // We "step" through the results - once for each row.
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // The second parameter indicates the column index into the result set.
                int primaryKey = sqlite3_column_int(statement, 0);
                // We avoid the alloc-init-autorelease pattern here because we are in a tight loop and
                // autorelease is slightly more expensive than release. This design choice has nothing to do with
                // actual memory management - at the end of this block of code, all the book objects allocated
                // here will be in memory regardless of whether we use autorelease or release, because they are
                // retained by the books array.
                Audio *a = [[Audio alloc] initWithPrimaryKey:primaryKey database:database];
                [audios addObject:a];
                [a release];
            }
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
    }
	
	/*
	NSLog([[NSString alloc] initWithFormat:@"id:%@",[[audios objectAtIndex:0] audioid]]);
	NSLog([[NSString alloc] initWithFormat:@"name:%@",[[audios objectAtIndex:0] audioname]]);
	NSLog([[NSString alloc] initWithFormat:@"description:%@",[[audios objectAtIndex:0] audiodescription]]);
	NSLog([[NSString alloc] initWithFormat:@"composer:%@",[[audios objectAtIndex:0] composer]]);
	NSLog([[NSString alloc] initWithFormat:@"performer:%@",[[audios objectAtIndex:0] performer]]);
	NSLog([[NSString alloc] initWithFormat:@"instrument:%@",[[audios objectAtIndex:0] instrument]]);
	 */
	
	// sort the array
	NSLog(@"sorting the array");
	NSSortDescriptor *descriptionSorter = [[NSSortDescriptor alloc] initWithKey:@"audiodescription" ascending:YES];
	[audios sortUsingDescriptors:[NSArray arrayWithObject:descriptionSorter]];
	
}

- (void)createToolbarItems
{	
	// match each of the toolbar item's style match the selection in the "UIBarButtonItemStyle" segmented control
	UIBarButtonItemStyle style = UIBarButtonItemStyleBordered;	
	toolbar.barStyle = UIBarStyleBlackOpaque;
	
	// create the system-defined "OK or Done" button
    //UIBarButtonItem *systemItem = [[UIBarButtonItem alloc]
	//							   initWithBarButtonSystemItem:currentSystemItem
	//							   target:self action:@selector(action:)];
	//systemItem.style = style;
	
	// flex item used to separate the left groups items and right grouped items
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	// create a bordered style button with custom title
	UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc] initWithTitle:@"Home"
																	style:style	// note you can use "UIBarButtonItemStyleDone" to make it blue
																   target:self
																   action:@selector(homeButtonPressed:)];
	
	// create a bordered style button with custom title
	UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc] initWithTitle:@"About"
																	style:style	// note you can use "UIBarButtonItemStyleDone" to make it blue
																   target:self
																   action:@selector(aboutButtonPressed:)];
	
	// create a bordered style button with custom title
	UIBarButtonItem *customItem3 = [[UIBarButtonItem alloc] initWithTitle:@"Instruments"
																	style:style	// note you can use "UIBarButtonItemStyleDone" to make it blue
																   target:self
																   action:@selector(setupButtonPressed:)];
	
	customItem1.width = 80;
	customItem2.width = 80;
	customItem3.width = 80;
	
	NSArray *items = [NSArray arrayWithObjects: customItem1, flexItem, customItem2, flexItem, customItem3, nil];
	[toolbar setItems:items animated:NO];
	
	//[systemItem release];
	[flexItem release];
	//[infoItem release];
	[customItem1 release];
	[customItem2 release];
	[customItem3 release];
}

- (IBAction)homeButtonPressed:(id)sender {
	//NSLog(@"home button pressed");
	[[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)aboutButtonPressed:(id)sender {
	//NSLog(@"about button pressed");
	PageSixViewController	*modalViewController = [[PageSixViewController alloc] initWithNibName:@"PageSixViewController" bundle:nil];
	[[self navigationController] presentModalViewController:modalViewController animated:YES];
}

- (IBAction)setupButtonPressed:(id)sender {
	//NSLog(@"setup button pressed");
	[[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 1)
	{
		NSLog(@"ok");
		
	}
	else
	{
		NSLog(@"cancel");
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"did recieve response");
    
	// this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [receivedData setLength:0];
	self.totalFileSize = [NSNumber numberWithLongLong:[response expectedContentLength]];
	
}

- (void)createProgressionAlertWithMessage:(NSString *)message {
	
	NSLog(@"creating progress alert");
	
    progressAlert = [[UIAlertView alloc] initWithTitle:message message:@"Please wait..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    // Create the progress bar and add it to the alert
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 90.0f)];
    [progressAlert addSubview:progressView];
    [progressView setProgressViewStyle:UIProgressViewStyleBar];
	
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 90.0f, 225.0f, 40.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.text = @"";
    label.tag = 743;
    [progressAlert addSubview:label];
	[label release];
	
    [progressAlert show];
    [progressAlert release];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    const unsigned int bytes = 1024 * 1024;

	//NSLog(@"getting data");
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [receivedData appendData:data];
	
	//NSLog([NSString stringWithFormat:@"totalFilesize: %f",[self.totalFileSize floatValue]]);
	//NSLog([NSString stringWithFormat:@"currentSize: %f",[currentSize floatValue]]);
	//NSLog([NSString stringWithFormat:@"totalSize: %f",[totalSize floatValue]]);

	float t = (float)[self.receivedData length]+[currentSize floatValue];
	
	//NSLog([NSString stringWithFormat:@"t: %f",t]);
	
    //NSNumber *resourceLength = [NSNumber numberWithFloat:t];
	
    NSNumber *progress = [NSNumber numberWithFloat:(t / [self.totalSize floatValue])];
    progressView.progress = [progress floatValue];

	//NSLog([NSString stringWithFormat:@"progress: %f",[progress floatValue]]);

    UILabel *label = (UILabel *)[progressAlert viewWithTag:743];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"##0.00"];
    NSNumber *partial = [NSNumber numberWithFloat:(t / bytes)];
    NSNumber *total = [NSNumber numberWithFloat:([self.totalSize floatValue] / bytes)];
    label.text = [NSString stringWithFormat:@"%@ MB of %@ MB", [formatter stringFromNumber:partial], [formatter stringFromNumber:total]];
    [formatter release];
	
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	//NSLog(@"connection error");
	
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	receivedData = nil;
	
	[progressAlert dismissWithClickedButtonIndex:0 animated:YES];	
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"connection finished loading");
	
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    //NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);

	self.currentSize = [NSNumber numberWithUnsignedInteger:([receivedData length]+[self.currentSize intValue])];

	NSFileManager *defaultManager;
	defaultManager = [NSFileManager defaultManager];
	
	int currentId = [[idArray objectAtIndex:[currentFile intValue]] intValue];
	NSLog([NSString stringWithFormat:@"id for current file: %i",currentId]);
	
	NSString *filename = [NSString stringWithFormat:@"%i.mp3",currentId];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	if (!documentsDirectory) {
		NSLog(@"Documents directory not found!"); 
	} 
	
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:filename];
	
	//NSLog(appFile);
	
	[receivedData writeToFile:appFile atomically:YES];		
	
	// add entry in Audio database for new file
	NSInteger primaryKey = [Audio insertNewAudioIntoDatabase:database :[idArray objectAtIndex:[currentFile intValue]] 
																	  :[nameArray objectAtIndex:[currentFile intValue]] 
																	  :[descriptionArray objectAtIndex:[currentFile intValue]]
																	  :[composerArray objectAtIndex:[currentFile intValue]]
																	  :[performerArray objectAtIndex:[currentFile intValue]]
																	  :@"saxophone"];
	BOOL alreadyInDatabase = NO;
	
	for (int h=0; h < [audios count]; h++) {
		//NSLog([NSString stringWithFormat:@"audios id: %i",[[[audios objectAtIndex:h] audioid] intValue]]);
		//NSLog([NSString stringWithFormat:@"current id: %i",[[idArray objectAtIndex:[currentFile intValue]] intValue]]);
		if ([[[audios objectAtIndex:h] audioid] intValue] == [[idArray objectAtIndex:[currentFile intValue]] intValue]) {
			alreadyInDatabase = YES;
		}
	}
	
	//NSLog([NSString stringWithFormat:@"primaryKey returned: %i",primaryKey]);
	
	if (!alreadyInDatabase) {
	
		Audio *newAudio = [[Audio alloc] initWithPrimaryKey:primaryKey database:database];
		[audios addObject:newAudio];
		[newAudio release];
		
		NSLog([NSString stringWithFormat:@"new primary key: %i",primaryKey]);
		
		for (int l=0; l < [audios count]; l++) {
			
			NSLog([[NSString alloc] initWithFormat:@"id:%@",[[audios objectAtIndex:l] audioid]]);
			NSLog([[NSString alloc] initWithFormat:@"name:%@",[[audios objectAtIndex:l] audioname]]);
			NSLog([[NSString alloc] initWithFormat:@"description:%@",[[audios objectAtIndex:l] audiodescription]]);
			NSLog([[NSString alloc] initWithFormat:@"composer:%@",[[audios objectAtIndex:l] composer]]);
			NSLog([[NSString alloc] initWithFormat:@"performer:%@",[[audios objectAtIndex:l] performer]]);
			NSLog([[NSString alloc] initWithFormat:@"instrument:%@",[[audios objectAtIndex:l] instrument]]);
			
		}

	} else {
		
		NSLog(@"already in database");
		
	}
		
	// sort the array
	NSLog(@"sorting the array");
	NSSortDescriptor *descriptionSorter = [[NSSortDescriptor alloc] initWithKey:@"audiodescription" ascending:YES];
	[audios sortUsingDescriptors:[NSArray arrayWithObject:descriptionSorter]];
	
    // release the connection, and the data object
    [connection release];
    [receivedData release];
	receivedData = nil;
	
	currentFile = [NSNumber numberWithInt:([currentFile intValue]+1)];
	
	if (currentFile == numFiles) {
		NSLog(@"All files downloaded");
		
		NSLog([NSString stringWithFormat:@"numFiles: %i",[numFiles intValue]]);
		NSLog([NSString stringWithFormat:@"audios size: %i",[audios count]]);		
	
		[myTableView reloadData];
		
		modalButton.enabled = YES;
		[progressAlert dismissWithClickedButtonIndex:0 animated:YES];
	} else {
		[self getNextFile];
	}
	
}

// Courtesy of Apple - this code originally from the iPhone Developer's Cookbook, page 305
- (NSString *) getIPAddressForHost: (NSString *) theHost
{
	struct hostent *host = gethostbyname([theHost UTF8String]);
	
    if (host == NULL) {
        herror("resolv");
		return NULL;
	}
	
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0])];
	return addressString;
}

- ( BOOL )isDataSourceAvailable
{
	// check to see if the IP address for jrtb.com can be resolved. If it can, we have a network connection. If not, we don't. 
	return [self getIPAddressForHost:@"jrtb.com"] != NULL;	
}

-(IBAction)loadAudio {

	if ([self isDataSourceAvailable]) {
		
		modalButton.enabled = NO;

		NSLog(@"THINKS DATA SOURCE IS AVAILABLE!");
		
		// connect to the server and find out how many files to download, their ids and the total size 
		
		numFiles = [NSNumber numberWithInt:0];
		self.totalSize = [NSNumber numberWithLongLong:0.0];
		self.currentSize = [NSNumber numberWithLongLong:0.0];

		self.ids = @"";
		currentFile = 0;
		
		NSString *path = @"http://jrtb.com/iir/get-info.php?instrument=saxophone";
		NSError *error;
		NSString *stringFromFileAtURL = [[NSString alloc]
										  initWithContentsOfURL:[NSURL URLWithString:path]
										  encoding:NSUTF8StringEncoding
										  error:&error];
		if (stringFromFileAtURL == nil) {
			// an error occurred
			NSLog(@"Error reading file at %@\n%@",
				  path, [error localizedFailureReason]);
			// implementation continues ...
		} else {
			
			NSArray *words = [stringFromFileAtURL componentsSeparatedByString:@"#"];	
			
			int i=0;
			for(NSString *word in words)
			{
				if (i == 0) {
					NSLog([NSString stringWithString:word]);
					//numFiles = [NSNumber numberWithInt:3];
					//NSLog(@"getting HERE?");
					numFiles = [NSNumber numberWithInt:[[NSString stringWithString:word] intValue]];
					//NSLog(@"getting here?");
				} 
				if (i == 1) {
					//totalSize = [NSNumber numberWithFloat:[[NSString stringWithString:word] floatValue]];
					self.totalSize = [NSNumber numberWithLongLong:[[NSString stringWithString:word] intValue]];
				}
				if (i == 2) {
					self.ids = [NSString stringWithString:word];
					idArray = [[ids componentsSeparatedByString:@"$"] retain];		
				}
				if (i == 3) {
					nameArray = [[[NSString stringWithString:word] componentsSeparatedByString:@"$"] retain];		
				}
				if (i == 4) {
					descriptionArray = [[[NSString stringWithString:word] componentsSeparatedByString:@"$"] retain];		
				}
				if (i == 5) {
					composerArray = [[[NSString stringWithString:word] componentsSeparatedByString:@"$"] retain];		
				}
				if (i == 6) {
					performerArray = [[[NSString stringWithString:word] componentsSeparatedByString:@"$"] retain];		
				}
				i++;
			}
			
		}
		
		// check to see if incoming files already exist
		
		NSLog([NSString stringWithFormat:@"numFiles: %i",[numFiles intValue]]);
		NSLog([NSString stringWithFormat:@"audios size: %i",[audios count]]);		

		BOOL keepGoing = NO;
		if ([numFiles intValue] > [audios count]) {
			keepGoing = YES;
		} //else {
		//	for (int h=0; h < [numFiles intValue]; h++) {
		//		if ([[idArray objectAtIndex:h] intValue] != [[[audios objectAtIndex:h] audioid] intValue]) {
		//			keepGoing = YES;
		//		}
		//	}
		//}
		
		if (keepGoing) {
		
			[self createProgressionAlertWithMessage:@"Downloading new audio!"];
		
			[self getNextFile];
			
		} else {
			
			NSLog(@"all files already exist");
			
			modalButton.enabled = YES;
			
			UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"All files up to date" message:@"All currently available audio recordings for this instrument have already been downloaded."
															delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert5 show];	
			[alert5 release];
			
			
		}
		
	} else {
		
		//NSLog(@"*******GETTING HERE!*********");
		
		// inform the user that the achievements couldn't be published 
		UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"New audio recordings can not be downloaded at this time because a network connection is not available. Please try again when a network connection is available."
														delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert5 show];	
		[alert5 release];
		
	}
		
}

- (void) getNextFile
{
	NSLog([NSString stringWithFormat:@"numFiles: %i",[numFiles intValue]]);
	NSLog([NSString stringWithFormat:@"totalSize: %f",[totalSize floatValue]]);
	NSLog(ids);
	NSLog([NSString stringWithFormat:@"currentFile: %i",[currentFile intValue]]);
	
	//NSLog([words2 objectAtIndex:i]);
	
	NSString *temp = [NSString stringWithFormat:@"http://jrtb.com/iir/get-audio.php?id=%i",[[idArray objectAtIndex:[currentFile intValue]] intValue]];	
	NSLog(temp);

	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:temp]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	
	if (receivedData != nil) {
		[receivedData release];
		receivedData = nil;
	}
	
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];
	} else {
		// inform the user that the achievements couldn't be published 
		UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"New audio recordings can not be downloaded at this time because a network connection is not available. Please try again when a network connection is available."
														delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert5 show];	
		[alert5 release];
	}	
	
	//[theRequest release];
	//[theConnection release];
	 
	 
	
}
	
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil instrument:(NSString *)instrumentString
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		NSLog(@"loading nib for audiomenuviewcontroller");
		
		// this will appear as the title in the navigation bar
		//self.title = instrumentString;
		self.instrument = instrumentString;
		
		// this will appear as the title in the navigation bar
		self.title = @"Recorded Audio";
		
		modalButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target:self action:@selector(loadAudio)];
		self.navigationItem.rightBarButtonItem = modalButton;
		
		[self createEditableCopyOfDatabaseIfNeeded];
		[self initializeDatabase];
		
		NSArray *array;
		
		//NSLog(self.instrument);
		
		// What does not stick around, we must retain
		//fileList = [[[[NSFileManager defaultManager] directoryContentsAtPath:DOCUMENTS_FOLDER]
		//			 pathsMatchingExtensions:[NSArray arrayWithObjects:@"txt", @"c", @"h", @"m", nil]] retain];
		
		array = (NSMutableArray *) [[[[NSFileManager defaultManager] directoryContentsAtPath:DOCUMENTS_FOLDER] pathsMatchingExtensions:[NSArray arrayWithObjects:@"mp3", nil]] retain];
		
		self.fileList = array;
		[array release];
		
		self.bottomLevel = YES;
		
		// important for view orientation rotation
		//webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);	
		self.view.autoresizesSubviews = YES;
		
		// create the UIToolbar at the bottom of the view controller
		toolbar = [UIToolbar new];
		toolbar.barStyle = UIBarStyleDefault;
				
		// size up the toolbar and set its frame
		[toolbar sizeToFit];
		CGFloat toolbarHeight = [toolbar frame].size.height;
		CGRect mainViewBounds = self.view.bounds;
		[toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
									 CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - ((toolbarHeight * 2.0)-20),
									 CGRectGetWidth(mainViewBounds),
									 toolbarHeight)];
		
		[self.view addSubview:toolbar];
		
		currentSystemItem = UIBarButtonSystemItemDone;
		[self createToolbarItems];
		
	}
	return self;
}

- (void)viewDidLoad
{
	printf("Documents folder is %s\n", [DOCUMENTS_FOLDER UTF8String]);
		
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	
	NSLog(@"Releasing audiomenuviewcontroller!");
	
	[myTableView release];
	[idArray release];
	//[numFiles release];
	//[totalSize release];
	//[ids release];
	//[currentFile release];

	[nameArray release];
	[descriptionArray release];
	[composerArray release];
	[performerArray release];
	
	//[totalFileSize release];
	[modalButton release];
	[instrument release];
	[listData release];
	[fileList release];
	[super dealloc];

}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [audios count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	NSLog(@"setting up cell");
	
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
				   reuseIdentifier:SimpleTableIdentifier] autorelease];
	}
	
	// Set up the cell
	
	NSUInteger row = [indexPath row];
	//cell.text = [listData objectAtIndex:row];
	//NSLog([[audios objectAtIndex:row] audiodescription]);
	cell.text = [[audios objectAtIndex:row] audiodescription];
	cell.font = [UIFont boldSystemFontOfSize:16];
	//UIImage *image = [UIImage imageNamed:@"star.png"];
	//cell.image = image;
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

/*
- (NSInteger)tableView:(UITableView *)tableView
	indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	return row;
}
 */

- (NSIndexPath *)tableView:(UITableView *)tableView
	willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	//if (row == 0)
	//	return nil;
	
	NSString *temp = [DOCUMENTS_FOLDER stringByAppendingString:[[@"/" stringByAppendingString:[[audios objectAtIndex:row] audioid]] stringByAppendingString:@".mp3"]];
	
	NSLog(temp);
	
	[self playMovieAtURL: [NSURL fileURLWithPath:temp]];
	
	return indexPath;
}

-(void)playMovieAtURL:(NSURL*)theURL 

{
    MPMoviePlayerController* theMovie=[[MPMoviePlayerController alloc] initWithContentURL:theURL]; 

    /* 
	 Movie scaling mode can be one of: MPMovieScalingModeNone, MPMovieScalingModeAspectFit,
	 MPMovieScalingModeAspectFill, MPMovieScalingModeFill.
	 */    
	theMovie.scalingMode=MPMovieScalingModeAspectFill; 

    //theMovie.userCanShowTransportControls=NO;
	
    // Register for the playback finished notification. 
	
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(myMovieFinishedCallback:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:theMovie]; 
	
    // Movie playback is asynchronous, so this method returns immediately. 
    [theMovie play]; 
} 

// When the movie is done,release the controller. 
-(void)myMovieFinishedCallback:(NSNotification*)aNotification 
{
    MPMoviePlayerController* theMovie=[aNotification object]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMoviePlayerPlaybackDidFinishNotification 
                                                  object:theMovie]; 
	
    // Release the movie instance created in playMovieAtURL
    [theMovie release]; 
}

- (void)tableView:(UITableView *)tableView
	didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSUInteger row = [indexPath row];
	
		
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	
    UIView *aView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 56)] autorelease];

	UIImageView *bannerView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bannerIIR.png"]] autorelease];
	bannerView.frame = CGRectMake(0.0, 0.0, 320.0, 56.0);
	[aView addSubview:bannerView];	
	
    return aView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return 56;
	} else {
		return 56;
	}
}

//- (void)viewWillAppear:(BOOL)animated
//{
//	NSIndexPath *tableSelection = [myTableView indexPathForSelectedRow];
//	[myTableView deselectRowAtIndexPath:tableSelection animated:NO];
//}

- (void)viewDidAppear:(BOOL)animated
{
	// do something here as our view re-appears
	
	NSLog(@"AudioMenuViewController appearing");
	
	/*
	if (targetViewController1 != nil) {
		NSLog(@"removing target1");
		[targetViewController1 release];
		targetViewController1 = nil;
	}
	if (targetViewController2 != nil) {
		NSLog(@"removing target2");
		//[targetViewController2 release];
		targetViewController2 = nil;
	}
	if (targetViewController3 != nil) {
		NSLog(@"removing target3");
		[targetViewController3 release];
		targetViewController3 = nil;
	}
	 */
	
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 180;
}
*/

@end
