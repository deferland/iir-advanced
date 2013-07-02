//
//  AudioPlaylistMenuViewController.m
//  Simple Table
//

#import "AudioPlaylistMenuViewController.h"
#import "AboutViewController.h"
#import "Constants.h"
#import <MediaPlayer/MediaPlayer.h>

#import <SystemConfiguration/SystemConfiguration.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#include "UIButton+LookAndFeel.h"

#import "Audio.h"

#import "ContentItemTableCellForAudioPlaylist.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface AudioPlaylistMenuViewController (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
@end

@implementation AudioPlaylistMenuViewController

@synthesize listData, instrument, bottomLevel, fileList, receivedData, progressAlert, progressView, totalFileSize, audios;

@synthesize numFiles, totalSize, ids, currentFile, idArray, currentSize, nameArray, descriptionArray, composerArray, performerArray, infoArray, myTableView;

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
	
	// sort the array
	NSLog(@"sorting the array");
	NSSortDescriptor *descriptionSorter = [[NSSortDescriptor alloc] initWithKey:@"audiodescription" ascending:YES];
	[audios sortUsingDescriptors:[NSArray arrayWithObject:descriptionSorter]];
	
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
	
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 90.0f, 225.0f, 40.0f)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:12.0f];
    label2.text = @"";
    label2.tag = 743;
    [progressAlert addSubview:label2];
	[label2 release];
	
    [progressAlert show];
    [progressAlert release];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    const unsigned int bytes = 1024 * 1024;

    [receivedData appendData:data];

	float t = (float)[self.receivedData length]+[currentSize floatValue];
	
    NSNumber *progress = [NSNumber numberWithFloat:(t / [self.totalSize floatValue])];
    progressView.progress = [progress floatValue];

    UILabel *label2 = (UILabel *)[progressAlert viewWithTag:743];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"##0.00"];
    NSNumber *partial = [NSNumber numberWithFloat:(t / bytes)];
    NSNumber *total = [NSNumber numberWithFloat:([self.totalSize floatValue] / bytes)];
    label2.text = [NSString stringWithFormat:@"%@ MB of %@ MB", [formatter stringFromNumber:partial], [formatter stringFromNumber:total]];
    [formatter release];
	
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	
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
	self.currentSize = [NSNumber numberWithUnsignedInteger:([receivedData length]+[self.currentSize intValue])];

	NSFileManager *defaultManager;
	defaultManager = [NSFileManager defaultManager];
	
	int currentId = [[idArray objectAtIndex:[currentFile intValue]] intValue];
	
	NSString *filename = [NSString stringWithFormat:@"%i.mp3",currentId];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:filename];
	
	[receivedData writeToFile:appFile atomically:YES];		
	
	// add entry in Audio database for new file
	NSInteger primaryKey = [Audio insertNewAudioIntoDatabase:database :[idArray objectAtIndex:[currentFile intValue]] 
																	  :[nameArray objectAtIndex:[currentFile intValue]] 
																	  :[descriptionArray objectAtIndex:[currentFile intValue]]
																	  :[composerArray objectAtIndex:[currentFile intValue]]
																	  :[performerArray objectAtIndex:[currentFile intValue]]
																	  :[infoArray objectAtIndex:[currentFile intValue]]
																	  :instrument];
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
		
	} 
		
	// sort the array
	NSSortDescriptor *descriptionSorter = [[NSSortDescriptor alloc] initWithKey:@"audiodescription" ascending:YES];
	[audios sortUsingDescriptors:[NSArray arrayWithObject:descriptionSorter]];
	
    // release the connection, and the data object
    [connection release];
    [receivedData release];
	receivedData = nil;
	
	currentFile = [NSNumber numberWithInt:([currentFile intValue]+1)];
	
	if (currentFile == numFiles) {
	
		[myTableView reloadData];
		
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
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding: NSASCIIStringEncoding];
	return addressString;
}

- ( BOOL )isDataSourceAvailable
{
	// check to see if the IP address for www.musicinreach.com can be resolved. If it can, we have a network connection. If not, we don't. 
	return [self getIPAddressForHost:@"www.musicinreach.com"] != NULL;	
}

-(IBAction)loadAudio {

	if ([self isDataSourceAvailable]) {
		
		// connect to the server and find out how many files to download, their ids and the total size 
		
		numFiles = [NSNumber numberWithInt:0];
		self.totalSize = [NSNumber numberWithLongLong:0.0];
		self.currentSize = [NSNumber numberWithLongLong:0.0];

		self.ids = @"";
		currentFile = 0;
		
		NSString *path = [NSString stringWithFormat:@"http://www.musicinreach.com/iirCMS/get-info.php?instrument=%@", instrument];
		NSError *error;
		NSString *stringFromFileAtURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:path]
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
					numFiles = [NSNumber numberWithInt:[[NSString stringWithString:word] intValue]];
				} 
				if (i == 1) {
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
				if (i == 7) {
					infoArray = [[[NSString stringWithString:word] componentsSeparatedByString:@"$"] retain];		
				}
				i++;
			}
			
		}
		
		// check to see if incoming files already exists

		BOOL keepGoing = NO;
		if ([numFiles intValue] > [audios count]) {
			keepGoing = YES;
		} 
		
		if (keepGoing) {
		
			[self createProgressionAlertWithMessage:@"Downloading new audio!"];
		
			[self getNextFile];
			
		} else {
			
			NSLog(@"all files already exist");
			
			UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"All files up to date" message:@"All currently available audio recordings for this instrument have already been downloaded."
															delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert5 show];	
			[alert5 release];
			
			
		}
		
	} else {
		
		
		// inform the user that the achievements couldn't be published 
		UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"New audio recordings can not be downloaded at this time because a network connection is not available. Please try again when a network connection is available."
														delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert5 show];	
		[alert5 release];
		
	}
		
}

- (void) getNextFile
{
	
	NSString *temp = [NSString stringWithFormat:@"http://www.musicinreach.com/iirCMS/get-audio.php?id=%i",[[idArray objectAtIndex:[currentFile intValue]] intValue]];	

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
	
	 
	
}
	
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil instrument:(NSString *)instrumentString
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		NSLog(@"loading nib for audiomenuviewcontroller");
		
		// this will appear as the title in the navigation bar
		self.instrument = instrumentString;
		
		// this will appear as the title in the navigation bar
		self.title = @"My playlist";
		
		[self createEditableCopyOfDatabaseIfNeeded];
		[self initializeDatabase];
		
      moviePlayers = [[NSMutableArray alloc] init];
      
		NSArray *array;
		
		array = (NSMutableArray *) [[[[NSFileManager defaultManager] directoryContentsAtPath:DOCUMENTS_FOLDER] pathsMatchingExtensions:[NSArray arrayWithObjects:@"mp3", nil]] retain];
		
		self.fileList = array;
		[array release];
		
		self.bottomLevel = YES;
		
		
		// create blank view on top of table view to display loading and no files available messages
		myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 54.0, 320.0, 338.0)];
		
		myView.backgroundColor = [UIColor whiteColor];
						
		if ([self.fileList count] == 0) {
			label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 140.0, 320.0, 40.0)];
			label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:14];
			label.textColor = [UIColor blackColor];
			label.backgroundColor = [UIColor clearColor];
			label.textAlignment = UITextAlignmentCenter;
			label.numberOfLines = 2;
			label.text = @"No audio files have been downloaded.";
			
			[myView addSubview:label];	
			
			[self.view addSubview:myView];
		}
		
	}
	return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	myTableView.delegate=self;
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
	
	[audios release];
	
	[myTableView release];
	[idArray release];
   
   [moviePlayers release];

	[nameArray release];
	[descriptionArray release];
	[composerArray release];
	[performerArray release];
   [infoArray release];
	
	[instrument release];
	[listData release];
	[fileList release];
	[super dealloc];

}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [audios count];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
				
		NSFileManager *defaultManager;
		defaultManager = [NSFileManager defaultManager];
		
		int currentId = [[[audios objectAtIndex:indexPath.row] audioid] intValue];

		NSString *filename = [NSString stringWithFormat:@"%i.mp3",currentId];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		
		NSString *appFile = [documentsDirectory stringByAppendingPathComponent:filename];
		
		[defaultManager removeItemAtPath:appFile error:NULL];
		
		//Get the object to delete from the array.		
		Audio *audioObj = [audios objectAtIndex:indexPath.row];
		[audios removeObject:audioObj];
		
		//Delete the object from the table.
		[tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		sqlite3_stmt *statement = nil;

		if(statement == nil) {
			const char *sql = "delete from audio where id = ?";
			if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
		}
		
		//When binding parameters, index starts from 1 and not zero.
		sqlite3_bind_int(statement, 1, currentId);
		
		if (SQLITE_DONE != sqlite3_step(statement))
			NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
		
		sqlite3_reset(statement);		
		
		[myTableView reloadData];
	}
}



- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	NSLog(@"assigning cell");
	
	NSInteger row = [indexPath row];
	
    static NSString *CellIdentifier = @"LocalScoreCell";
    
	ContentItemTableCellForAudioPlaylist *cell = (ContentItemTableCellForAudioPlaylist *) [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
   
	if (cell == nil) {
      cell = [[ContentItemTableCellForAudioPlaylist alloc] initWithFrame: CGRectMake(0.0, 0.0, 280.0, 80.0)];
      cell.playButton.tag = [[[audios objectAtIndex:row] audioid] intValue];
      [cell.playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
      [cell.playButton setTitle:@"Play" forState:UIControlStateNormal];

      cell.infoButton.tag = row;
		[cell.infoButton addTarget:self action:@selector(infoURLPressed:) forControlEvents:UIControlEventTouchUpInside];
	}
	cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[cell setNameText: [[audios objectAtIndex:row] audioname]];
	[cell setComposerText: [[audios objectAtIndex:row] composer]];
   [cell setDescriptionText: [[audios objectAtIndex:row] audiodescription]];
   [cell setPerformerText: [[audios objectAtIndex:row] performer]];
   [cell setInfoURL: [[audios objectAtIndex: row] infoURL]];

	return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   ContentItemTableCellForAudioPlaylist *cell = (ContentItemTableCellForAudioPlaylist *) [self tableView: tableView cellForRowAtIndexPath: indexPath];
   return [cell rowHeight];
}


- (void) playAudio:(id)sender
{
	//int row = [sender tag];
	NSInteger tid = [sender tag];
	
	NSString *temp = [DOCUMENTS_FOLDER stringByAppendingString:[[@"/" stringByAppendingString:[NSString stringWithFormat:@"%i",tid]] stringByAppendingString:@".mp3"]];
	
	[self playMovieAtURL: [NSURL fileURLWithPath:temp]];
}	

- (void) infoURLPressed:(UIButton *)sender {
	NSString *urlString = [[audios objectAtIndex: [sender tag]] infoURL];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];   
}


#pragma mark -
#pragma mark Table Delegate Methods

- (NSIndexPath *)tableView:(UITableView *)tableView
	willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

-(void)playMovieAtURL:(NSURL*)theURL 

{
//    MPMoviePlayerController* theMovie=[[MPMoviePlayerController alloc] initWithContentURL:theURL]; 
    MPMoviePlayerViewController *playerViewController = [[[MPMoviePlayerViewController alloc] initWithContentURL:theURL] autorelease];
    /* 
	 Movie scaling mode can be one of: MPMovieScalingModeNone, MPMovieScalingModeAspectFit,
	 MPMovieScalingModeAspectFill, MPMovieScalingModeFill.
	 */    
//	theMovie.scalingMode=MPMovieScalingModeAspectFill; 

    //theMovie.userCanShowTransportControls=NO;
	
    // Register for the playback finished notification. 
//    [[NSNotificationCenter defaultCenter] addObserver:self 
//											 selector:@selector(myMovieFinishedCallback:) 
//												 name:MPMoviePlayerPlaybackDidFinishNotification 
//											   object:theMovie]; 
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(myMovieFinishedCallback:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:playerViewController]; 

    // Movie playback is asynchronous, so this method returns immediately. 
//    [theMovie play]; 
//   [moviePlayers addObject: theMovie];
    [moviePlayers addObject:playerViewController];
    [self.navigationController presentMoviePlayerViewControllerAnimated:playerViewController];
//   [theMovie release];
} 

// When the movie is done,release the controller. 
-(void)myMovieFinishedCallback:(NSNotification*)aNotification 
{
//    MPMoviePlayerController* theMovie=[aNotification object]; 
    MPMoviePlayerViewController *playerViewController = [aNotification object];
//    [[NSNotificationCenter defaultCenter] removeObserver:self 
//                                                    name:MPMoviePlayerPlaybackDidFinishNotification 
//                                                  object:theMovie]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMoviePlayerPlaybackDidFinishNotification 
                                                  object:playerViewController]; 
	
    // Release the movie instance created in playMovieAtURL
   [moviePlayers removeObject:playerViewController];
}

- (void)tableView:(UITableView *)tableView
	didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSUInteger row = [indexPath row];
	
		
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
