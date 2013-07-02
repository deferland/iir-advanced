//
//  AudioLibraryMenuViewController.m
//  Simple Table
//

#import "AudioLibraryMenuViewController.h"
#import "AboutViewController.h"
#import "Constants.h"

#import <SystemConfiguration/SystemConfiguration.h>

#import "UIButton+LookAndFeel.h"

#import "Audio.h"
#import "Instrument.h"

#import "ContentItemTableCell.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface AudioLibraryMenuViewController (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
@end

@implementation AudioLibraryMenuViewController

@synthesize fileList, receivedData, progressAlert, progressView, totalFileSize, totalSizeArray, audios, currentConnection;

@synthesize totalSize, currentSize, descriptionArray, composerArray, performerArray;

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
	NSLog(@"done sorting array");
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
	// this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [self.receivedData setLength:0];
	self.totalFileSize = [NSNumber numberWithLongLong:[response expectedContentLength]];
	
}

- (void)createProgressionAlertWithMessage:(NSString *)message {
	
	NSLog(@"creating progress alert");
	
    progressAlert = [[UIAlertView alloc] initWithTitle:message message:@"Please wait..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    // Create the progress bar and add it to the alert
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 90.0f)];
    [progressAlert addSubview:progressView];
    [progressView setProgressViewStyle:UIProgressViewStyleBar];
	
    label = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 90.0f, 225.0f, 40.0f)];
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
	
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [self.receivedData appendData:data];
	
	float t = (float)[self.receivedData length]+[currentSize floatValue];
	
	float ts = [[totalSizeArray objectAtIndex:[self.currentFile intValue]] floatValue];
	
    NSNumber *progress = [NSNumber numberWithFloat:(t / ts)];
    progressView.progress = [progress floatValue];
	
    UILabel *label2 = (UILabel *)[progressAlert viewWithTag:743];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"##0.00"];
    NSNumber *partial = [NSNumber numberWithFloat:(t / bytes)];
    NSNumber *total = [NSNumber numberWithFloat:(ts / bytes)];
    label2.text = [NSString stringWithFormat:@"%@ MB of %@ MB", [formatter stringFromNumber:partial], [formatter stringFromNumber:total]];
    [formatter release];
	
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
   self.currentConnection = nil;
   self.receivedData = nil;
	
	[progressAlert dismissWithClickedButtonIndex:0 animated:YES];	
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	@synchronized(self) {
      self.currentSize = [NSNumber numberWithUnsignedInteger:([receivedData length]+[self.currentSize intValue])];
      
      int currentId = [[idArray objectAtIndex:[self.currentFile intValue]] intValue];
      
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
      NSInteger primaryKey = [Audio insertNewAudioIntoDatabase:database :[idArray objectAtIndex:[self.currentFile intValue]] 
                                                              :[nameArray objectAtIndex:[self.currentFile intValue]] 
                                                              :[descriptionArray objectAtIndex:[self.currentFile intValue]]
                                                              :[composerArray objectAtIndex:[self.currentFile intValue]]
                                                              :[performerArray objectAtIndex:[self.currentFile intValue]]
                                                              :[infoArray objectAtIndex:[self.currentFile intValue]]
                                                              :instrument];
      BOOL alreadyInDatabase = NO;
      
      for (int h=0; h < [audios count]; h++) {
         if ([[[audios objectAtIndex:h] audioid] intValue] == [[idArray objectAtIndex:[self.currentFile intValue]] intValue]) {
            alreadyInDatabase = YES;
         }
      }
      
      if (!alreadyInDatabase) {
         
         Audio *newAudio = [[Audio alloc] initWithPrimaryKey:primaryKey database:database];
         [audios addObject:newAudio];
         [newAudio release];
         
      }
      
      // sort the array
      NSSortDescriptor *descriptionSorter = [[NSSortDescriptor alloc] initWithKey:@"audiodescription" ascending:YES];
      [audios sortUsingDescriptors:[NSArray arrayWithObject:descriptionSorter]];
      
      // remove files from arrays which have already been downloaded
      
      NSFileManager *fileManager = [NSFileManager defaultManager];
      paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      documentsDirectory = [paths objectAtIndex:0];
      
      
      NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
      
      for (int z=0; z < [self.numFiles intValue]; z++) {
         
         BOOL success;
         NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.mp3",[[idArray objectAtIndex:z] intValue]]];
         success = [fileManager fileExistsAtPath:writableDBPath];
         if (success) {
            [indexes addIndex:z];
         }
      }
      
      [totalSizeArray removeObjectsAtIndexes:indexes];      
      [idArray removeObjectsAtIndexes:indexes];      
      [nameArray removeObjectsAtIndexes:indexes];      
      [descriptionArray removeObjectsAtIndexes:indexes];      
      [composerArray removeObjectsAtIndexes:indexes];      
      [performerArray removeObjectsAtIndexes:indexes];      
      
      self.numFiles = [NSNumber numberWithInt:[idArray count]];		
      
      // release the connection, and the data object
      NSLog(@"Connection retain count: %d", [self.currentConnection retainCount]);
      self.currentConnection = nil;
      self.receivedData = nil;

      [myTableView reloadData];
      
      [progressAlert dismissWithClickedButtonIndex:0 animated:YES];
      
   }
	
}

-(IBAction)loadAudio {
   NSLog(@"Load Audio");
      if ([self isDataSourceAvailable]) {
         
         // connect to the server and find out how many files to download, their ids and the total size 
         
         self.numFiles = [NSNumber numberWithInt:0];
         self.totalSize = [NSNumber numberWithLongLong:0.0];
         self.currentSize = [NSNumber numberWithLongLong:0.0];
         
         self.ids = @"";
         self.currentFile = [NSNumber numberWithInt: 0];
         
         NSString *path = [NSString stringWithFormat:@"http://www.musicinreach.com/iirCMS/get-info.php?instrument=%@", [[Instrument currentInstrument] cmsName]];
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
            
            NSArray *words = [stringFromFileAtURL componentsSeparatedByString:@"#$%"];	
            
            int i=0;
            for(NSString *word in words)
            {
               if (i == 0) {
                  self.numFiles = [NSNumber numberWithInt:[[NSString stringWithString:word] intValue]];
               } 
               if (i == 1) {
                  self.totalSizeArray = [NSMutableArray arrayWithArray: [[NSString stringWithString:word] componentsSeparatedByString:@"$"]];
               }
               if (i == 2) {
                  self.ids = [NSString stringWithString:word];
                  self.idArray = [NSMutableArray arrayWithArray: [ids componentsSeparatedByString:@"$"]];		
               }
               if (i == 3) {
                  self.nameArray = [NSMutableArray arrayWithArray: [[NSString stringWithString:word] componentsSeparatedByString:@"$"]];		
               }
               if (i == 4) {
                  self.descriptionArray = [NSMutableArray arrayWithArray: [[NSString stringWithString:word] componentsSeparatedByString:@"$"]];		
               }
               if (i == 5) {
                  self.composerArray = [NSMutableArray arrayWithArray: [[NSString stringWithString:word] componentsSeparatedByString:@"$"]];		
               }
               if (i == 6) {
                  self.performerArray = [NSMutableArray arrayWithArray: [[NSString stringWithString:word] componentsSeparatedByString:@"$"]];		
               }
               if (i == 7) {
                  self.infoArray = [NSMutableArray arrayWithArray: [[NSString stringWithString:word] componentsSeparatedByString:@"$"]];		
               }               
               i++;
            }
            
         }
         
         // remove files from arrays which have already been downloaded
         
         NSFileManager *fileManager = [NSFileManager defaultManager];
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         NSString *documentsDirectory = [paths objectAtIndex:0];
         
         NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
         
         for (int z=0; z < [self.numFiles intValue]; z++) {
            
            BOOL success;
            NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.mp3",[[idArray objectAtIndex:z] intValue]]];
            success = [fileManager fileExistsAtPath:writableDBPath];
            if (success) {
               [indexes addIndex:z];
            } 
         }
         
         if ([self.numFiles intValue] > 0) {
            [totalSizeArray removeObjectsAtIndexes:indexes];               
            [idArray removeObjectsAtIndexes:indexes];
            [nameArray removeObjectsAtIndexes:indexes];
            [descriptionArray removeObjectsAtIndexes:indexes];
            [composerArray removeObjectsAtIndexes:indexes];
            [performerArray removeObjectsAtIndexes:indexes];
            [infoArray removeObjectsAtIndexes:indexes];         
            self.numFiles = [NSNumber numberWithInt:[idArray count]];		
         }
         
         
         if ([self.numFiles intValue] > 0) {
            myView.alpha = 0;
         } else {
            [activityIndicator removeFromSuperview];
            label.frame = CGRectMake(0.0, 140.0, 320.0, 40.0);
            label.numberOfLines = 2;
            label.text = @"All audio files in the library have been downloaded. Check back soon!";
         }
         [myTableView reloadData];
         
      } else {
         // inform the user that the achievements couldn't be published 
         UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"New audio recordings can not be downloaded at this time because a network connection is not available. Please try again when a network connection is available."
                                                         delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert5 show];	
         [alert5 release];
         
      }

}

- (void) getFile :(int)file
{
	
	self.currentFile = [NSNumber numberWithInt:file];
	
	self.totalFileSize = [NSNumber numberWithLongLong:0.0];
	self.currentSize = [NSNumber numberWithLongLong:0.0];
	
	
	NSString *temp = [NSString stringWithFormat:@"http://www.musicinreach.com/iirCMS/get-audio.php?id=%i",[[idArray objectAtIndex:[self.currentFile intValue]] intValue]];	
	
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:temp]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	
	// create the connection with the request
	// and start loading the data
	self.currentConnection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];
   // Create the NSMutableData that will hold
   // the received data
   // receivedData is declared as a method instance elsewhere
   self.receivedData = [NSMutableData data];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil instrument:(NSString *)instrumentString
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil instrument:instrumentString];
	if (self)
	{
		NSLog(@"loading nib for audiomenuviewcontroller");
		
		// this will appear as the title in the navigation bar
		//self.title = instrumentString;
		self.instrument = instrumentString;
		
		// this will appear as the title in the navigation bar
		self.title = @"Get Audio Files";
	
		[self createEditableCopyOfDatabaseIfNeeded];
		[self initializeDatabase];
		
		NSArray *array;
		
		array = (NSMutableArray *) [[[[NSFileManager defaultManager] directoryContentsAtPath:DOCUMENTS_FOLDER] pathsMatchingExtensions:[NSArray arrayWithObjects:@"mp3", nil]] retain];
		
		self.fileList = array;
		[array release];
				
		[self performSelector:@selector(loadAudio) withObject:nil afterDelay:0.0];
		
	}
	return self;
}


- (void)dealloc {
   self.currentConnection = nil;
   self.receivedData = nil;
	
	[audios release];
	[totalSizeArray release];
	
	[descriptionArray release];
	[composerArray release];
	[performerArray release];
	
	[fileList release];
	[super dealloc];
	
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.numFiles intValue];	
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSInteger row = [indexPath row];
	
	ContentItemTableCell *cell = (ContentItemTableCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	[cell.playButton setTitle:@"Download" forState:UIControlStateNormal];
	NSLog(@"getting cell");
	[cell setNameText: [nameArray objectAtIndex:row]];
	[cell setComposerText: [composerArray objectAtIndex:row]];
	[cell setPerformerText: [performerArray objectAtIndex:row]];
	[cell setDescriptionText: [descriptionArray objectAtIndex:row]];
	[cell setInfoURL: [infoArray objectAtIndex: row]];
	cell.playButton.tag = row;
	cell.infoButton.tag = row;
	
	
	//disabling  Button "Get Music"
	[cell.infoButton	setEnabled:NO];
	[cell.infoButton	setHidden:YES];
	
	return cell;
	
}

- (void) playAudio:(UIButton *)sender
{
	NSInteger tid = [sender tag];
	[self createProgressionAlertWithMessage:@"Downloading new audio!"];
	[self getFile:tid];	
}	

- (void) infoURLPressed:(UIButton *)sender {
	NSString *urlString = [infoArray objectAtIndex: [sender tag]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];   
}


#pragma mark -
#pragma mark Table Delegate Methods

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return nil;
}

@end