//
//  VideoPlaylistMenuViewController.m
//  Simple Table
//

#import "VideoPlaylistMenuViewController.h"
#import "AboutViewController.h"
#import "Constants.h"
#import <MediaPlayer/MediaPlayer.h>

#import <SystemConfiguration/SystemConfiguration.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#include "UIButton+LookAndFeel.h"

#include "ContentItemTableCell.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation VideoPlaylistMenuViewController

@synthesize listData, instrument, bottomLevel;

@synthesize numFiles, ids, currentFile, idArray, savedIdArray, nameArray, urlArray, infoArray, myTableView;


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

		self.ids = @"";
		currentFile = 0;
		
		NSString *path = [NSString stringWithFormat:@"http://www.musicinreach.com/iirCMS/get-info2.php?instrument=%@", instrument];
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
					numFiles = [NSNumber numberWithInt:[[NSString stringWithString:word] intValue]];
				} 
				if (i == 1) {
					self.ids = [NSString stringWithString:word];
					idArray = [[ids componentsSeparatedByString:@"$"] retain];		
				}
				if (i == 2) {
					nameArray = [[[NSString stringWithString:word] componentsSeparatedByString:@"$"] retain];		
				}
				if (i == 3) {
					urlArray = [[[NSString stringWithString:word] componentsSeparatedByString:@"$"] retain];		
				}
				if (i == 4) {
					infoArray = [[[NSString stringWithString:word] componentsSeparatedByString:@"$"] retain];		
				}
				i++;
			}
			
		}
		
		// remove files from arrays which have already been saved
		if ([numFiles intValue] > 0) {
         NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
         
         CFStringRef savedVideosPref = (CFStringRef)CFPreferencesCopyAppValue(CFSTR("savedVideosPref"), kCFPreferencesCurrentApplication);
         
         NSString *savedVideos = [[NSString alloc] initWithFormat:@""];
         
         if (savedVideosPref) {			
            savedVideos = [NSString stringWithString:(NSString *) savedVideosPref];
            CFRelease(savedVideosPref);
         }
         
         savedIdArray = [[savedVideos componentsSeparatedByString:@"#"] retain];	
         
         for (int z=0; z < [numFiles intValue]; z++) {
            BOOL alreadyInThere = NO;
            for (int i=0; i < [savedIdArray count]; i++) {
               if ([[idArray objectAtIndex:z] isEqualToString:[savedIdArray objectAtIndex:i]]) {
                  alreadyInThere = YES;
               }
               
            }
            
            if (!alreadyInThere) {	
               [indexes addIndex:z];
            }
         }
         
         [idArray removeObjectsAtIndexes:indexes];
         [nameArray removeObjectsAtIndexes:indexes];
         [urlArray removeObjectsAtIndexes:indexes];
         [infoArray removeObjectsAtIndexes:indexes];
         
         numFiles = [NSNumber numberWithInt:[idArray count]];		
         
      }
			
		if ([numFiles intValue] > 0) {
			myView.alpha = 0;
		} else {
			[progressView2 removeFromSuperview];
			label.frame = CGRectMake(0.0, 140.0, 320.0, 40.0);
			label.numberOfLines = 2;
			label.text = @"You have not yet saved any video to your playlist!";
		}
		
	} else {
		
		//NSLog(@"*******GETTING HERE!*********");
		
		// inform the user that the achievements couldn't be published 
		UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"Video recording list can not be downloaded at this time because a network connection is not available. Please try again when a network connection is available."
														delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert5 show];	
		[alert5 release];
		
	}
		
}


- (void) loadView {
   [super loadView];
   
   moviePlayers = [[NSMutableArray alloc] init];
   
   // this will appear as the title in the navigation bar
   self.title = @"My Playlist";
   
   self.bottomLevel = YES;
   
   // important for view orientation rotation
   self.view.autoresizesSubviews = YES;
   
   
   currentSystemItem = UIBarButtonSystemItemDone;
   
   // create blank view on top of table view to display loading and no files available messages
   myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 54.0, 320.0, 338.0)];
   
   myView.backgroundColor = [UIColor whiteColor];
   
   progressView2 = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 100, 30.0, 30.0)];
   progressView2.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
   progressView2.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                     UIViewAutoresizingFlexibleRightMargin |
                                     UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleBottomMargin);
   
   [myView addSubview:progressView2];
   [progressView2 startAnimating];	
   
   label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 140.0, 320.0, 20.0)];
   label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:14];
   label.textColor = [UIColor blackColor];
   label.backgroundColor = [UIColor clearColor];
   label.textAlignment = UITextAlignmentCenter;
   label.numberOfLines = 1;
   label.text = @"Loading...";
   
   [myView addSubview:label];	
   
   [self.view addSubview:myView];
   
   [self loadAudio];   
}

- (void)viewDidLoad
{
   [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	myTableView.editing = NO;  //This allows user of progrm to add or remove elements from list
}

- (void)dealloc {
   
   [moviePlayers release];
	
	[myTableView setDelegate:nil];
	[myTableView release];
	[idArray release];
	[savedIdArray release];
	
	[nameArray release];
	[urlArray release];
   [infoArray release];
	
	[instrument release];
	[listData release];
	[super dealloc];

}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [numFiles intValue];	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:
(NSIndexPath *)indexPath
{
	
	return UITableViewCellEditingStyleDelete;
	
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [myTableView setEditing:editing animated:YES];
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {

		// remove selected video from prefs
		
		CFStringRef savedVideosPref = (CFStringRef)CFPreferencesCopyAppValue(CFSTR("savedVideosPref"), kCFPreferencesCurrentApplication);
		
		NSString *savedVideos = [[NSString alloc] initWithFormat:@""];
		
		if (savedVideosPref) {			
			savedVideos = [NSString stringWithString:(NSString *) savedVideosPref];
			CFRelease(savedVideosPref);
		}

		savedVideos = [savedVideos stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"#%i",[[idArray objectAtIndex:indexPath.row] intValue]] withString:@""];
		
		CFPreferencesSetAppValue((CFStringRef)@"savedVideosPref", savedVideos, kCFPreferencesCurrentApplication);
		CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);	

		NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
		
		[indexes addIndex:indexPath.row];
		
		[idArray removeObjectsAtIndexes:indexes];
		[nameArray removeObjectsAtIndexes:indexes];
		[urlArray removeObjectsAtIndexes:indexes];
		[infoArray removeObjectsAtIndexes:indexes];
		
		numFiles = [NSNumber numberWithInt:[idArray count]];		

		
		[myTableView reloadData];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   
	NSInteger row = [indexPath row];
   
	NSString *CellIdentifier = [NSString stringWithFormat:@"%@ %d", @"DataCell_", indexPath.row];
	
	ContentItemTableCell *cell = (ContentItemTableCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil) {
		cell = [[[ContentItemTableCell alloc] initWithFrame: CGRectMake(0,0,320,80)
                                          reuseIdentifier: CellIdentifier] autorelease];
      
      [cell.playButton setTitle:@"Play" forState:UIControlStateNormal];
		[cell.playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
		[cell.infoButton addTarget:self action:@selector(infoURLPressed:) forControlEvents:UIControlEventTouchUpInside];
	}
   
	[cell setNameText: [nameArray objectAtIndex:row]];
   [cell setInfoURL: [infoArray objectAtIndex: row]];
   //[cell setComposerText: [composerArray objectAtIndex:row]];
   //[cell setPerformerText: [performerArray objectAtIndex:row]];
	//[cell setDescriptionText: [descriptionArray objectAtIndex:row]];
   cell.playButton.tag = row;
   cell.infoButton.tag = row;
   
	return cell;
}

- (void) infoURLPressed:(UIButton *)sender {
	
	NSString *urlString = [infoArray objectAtIndex: [sender tag]];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];   
}

- (void) saveAudio:(UIButton *)sender
{
	NSInteger tid = [sender tag];
	NSInteger oid = tid;
	tid = [[idArray objectAtIndex:tid] intValue];

	CFStringRef savedVideosPref = (CFStringRef)CFPreferencesCopyAppValue(CFSTR("savedVideosPref"), kCFPreferencesCurrentApplication);
	
	NSString *savedVideos = [[NSString alloc] initWithFormat:@""];
	
	if (savedVideosPref) {			
		savedVideos = [NSString stringWithString:(NSString *) savedVideosPref];
		CFRelease(savedVideosPref);
	}

	//NSLog(@"savedVideos:");
	//NSLog(savedVideos);

	savedIdArray = [[savedVideos componentsSeparatedByString:@"#"] retain];	
	
	//NSLog([NSString stringWithFormat:@"count of savedIdArray: %i",[savedIdArray count]]);
	
	BOOL alreadyInThere = NO;
	
	for (int i=0; i < [savedIdArray count]; i++) {
		
		//NSLog([savedIdArray objectAtIndex:i]);
		
		if ([[NSString stringWithFormat:@"%i",tid] isEqualToString:[savedIdArray objectAtIndex:i]]) {
			
			alreadyInThere = YES;
			NSLog(@"already in there!");
			
		}
		
	}
	
	if (!alreadyInThere) {	
		savedVideos = [savedVideos stringByAppendingString:[NSString stringWithFormat:@"#%i",tid]];
		CFPreferencesSetAppValue((CFStringRef)@"savedVideosPref", savedVideos, kCFPreferencesCurrentApplication);
		CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);	
		
		NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
		
		[indexes addIndex:oid];
		
		[idArray removeObjectsAtIndexes:indexes];
		[nameArray removeObjectsAtIndexes:indexes];
		[urlArray removeObjectsAtIndexes:indexes];
		[infoArray removeObjectsAtIndexes:indexes];
		
		numFiles = [NSNumber numberWithInt:[idArray count]];		
		
		[myTableView reloadData];
		
		UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"Video Saved!" message:@"Video saved to your playlist."
														delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert5 show];	
		[alert5 release];
		
	}

}

- (void) playAudio:(UIButton *)sender
{
	//int row = [sender tag];
	NSInteger tid = [sender tag];
	
	NSString *temp = [urlArray objectAtIndex:tid];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp]];
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
   [moviePlayers addObject: theMovie];
   [theMovie release];
} 

// When the movie is done,release the controller. 
-(void)myMovieFinishedCallback:(NSNotification*)aNotification 
{
    MPMoviePlayerController* theMovie=[aNotification object]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMoviePlayerPlaybackDidFinishNotification 
                                                  object:theMovie]; 
	
    // Release the movie instance created in playMovieAtURL
   [moviePlayers removeObject: theMovie];
}

- (void)tableView:(UITableView *)tableView
	didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSUInteger row = [indexPath row];
	
		
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   ContentItemTableCell *cell = (ContentItemTableCell *) [self tableView: tableView cellForRowAtIndexPath: indexPath];
   return [cell rowHeight];
}


@end
