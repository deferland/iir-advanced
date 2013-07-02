//
//  VideoLibraryMenuViewController.m
//  Simple Table
//

#import "VideoLibraryMenuViewController.h"
#import "AboutViewController.h"
#import "Constants.h"

#import <SystemConfiguration/SystemConfiguration.h>

#import "UIButton+LookAndFeel.h"

#import "ContentItemTableCell.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation VideoLibraryMenuViewController

@synthesize category, urlArray, categoryArray, mediaWebView;


-(IBAction)loadVideo {
	if ([self isDataSourceAvailable]) {
		
		NSLog(@"THINKS DATA SOURCE IS AVAILABLE!");
		// connect to the server and find out how many files to download, their ids and the total size 
		
		self.numFiles = [NSNumber numberWithInt:0];
		
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
					self.numFiles = [NSNumber numberWithInt:[[NSString stringWithString:word] intValue]];
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
               if (i == 5) {
                  categoryArray = [[[NSString stringWithString:word] componentsSeparatedByString:@"$"] retain];    
               }               
				i++;
			}
			
		}
		
		// Filter the items that match the category for this view
		// Work backwards through the list so that indexes are correct
      if ([numFiles intValue] > 0) {
         for (int i= [categoryArray count] - 1; i >= 0; i--) {
            if (![category isEqualToString: [categoryArray objectAtIndex: i]]) {
               [categoryArray removeObjectAtIndex: i];
               [idArray removeObjectAtIndex: i];
               [nameArray removeObjectAtIndex: i];
               [urlArray removeObjectAtIndex: i];
               self.numFiles = [NSNumber numberWithInt: [numFiles intValue] - 1];
            }
         }         
      }
		
		if ([numFiles intValue] > 0) {
			myView.alpha = 0;
		} else {
			[activityIndicator removeFromSuperview];
			label.frame = CGRectMake(0.0, 140.0, 320.0, 40.0);
			label.numberOfLines = 2;
			label.text = @"There are not currently any video files available. Check back soon!";
		}
		
		[myTableView reloadData];
		
	} else {
		
		//NSLog(@"*******GETTING HERE!*********");
		
		// inform the user that the achievements couldn't be published 
		UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"Video recording list can not be downloaded at this time because a network connection is not available. Please try again when a network connection is available."
														delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert5 show];  
		[alert5 release];
		
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil instrument:(NSString *)instrumentString category: (NSString *) myCategory
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil instrument:instrumentString];
	if (self)
	{
		NSLog(@"loading nib for videomenuviewcontroller");
		
		// this will appear as the title in the navigation bar
		//self.title = instrumentString;
		self.instrument = instrumentString;
		
		// this will appear as the title in the navigation bar
		self.title = @"Get Videos";
		
		self.category = myCategory;
				
		currentSystemItem = UIBarButtonSystemItemDone;
	
		//[self loadVideo];
		[self performSelector:@selector(loadVideo) withObject:nil afterDelay:0.1];
	}
	return self;
}


- (void)dealloc {
   self.mediaWebView = nil;
	self.category = nil;
	[urlArray release];
	[infoArray release];
	self.categoryArray = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [numFiles intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	
 	ContentItemTableCell *cell = (ContentItemTableCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	[cell setNameText: [nameArray objectAtIndex:row]];
	[cell setInfoURL: [infoArray objectAtIndex: row]];
	cell.playButton.tag = row;
	cell.infoButton.tag = row;
   
   [cell setYouTubeURL: [urlArray objectAtIndex: indexPath.row]];
   
	return cell;
}

- (void) infoURLPressed:(UIButton *)sender {
	
	NSString *urlString = [infoArray objectAtIndex: [sender tag]];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];   
}


- (void) playAudio:(UIButton *)sender
{
	//int row = [sender tag];
	//NSInteger tid = [sender tag];
	
	//NSString *urlString = [urlArray objectAtIndex:tid];
	//NSLog(@"urlString: %@", urlString);
   //self.mediaWebView = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
   //self.mediaWebView.delegate = self;
   //[activityIndicator startAnimating];
}  

#pragma mark UIWebView delegate methods

#pragma mark UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
   [self.activityIndicator stopAnimating];
}

#pragma mark Table Delegate Methods

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end