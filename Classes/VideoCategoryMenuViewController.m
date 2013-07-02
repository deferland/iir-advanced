//
//  VideoCategoryMenuViewController.m
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 6/16/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "VideoCategoryMenuViewController.h"

#import <SystemConfiguration/SystemConfiguration.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#import "VideoLibraryMenuViewController.h"
#import "UIFont+LookAndFeel.h"
#import "Instrument.h"

@implementation VideoCategoryMenuViewController

@synthesize categories;

- (id) init {
   return [self initWithNibName: @"VideoCategoryMenuViewController" bundle: nil];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[self performSelectorInBackground:@selector(loadCategories) withObject:nil];
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
   [super viewWillAppear: animated];
   [activityIndicator startAnimating];
}

- (void)dealloc {
   self.categories = nil;
    [super dealloc];
}

#pragma mark Methods for downloading categories

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self.navigationController popViewControllerAnimated: YES];
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

-(void)loadCategories {
	NSAutoreleasePool *ap = [[NSAutoreleasePool alloc] init];
	if ([self isDataSourceAvailable]) {
		
		// connect to the server and find out how many files to download, their ids and the total size 
		NSString *path = [NSString stringWithFormat: @"http://www.musicinreach.com/iirCMS/get-info2.php?instrument=%@", [[Instrument currentInstrument] cmsName]] ;
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
			if ([[words objectAtIndex: 0] isEqualToString: @"0"]) {
            self.categories = [NSArray array];
         } else {
            int i=0;
            for(NSString *word in words)
            {
               if (i == 5) {
                  self.categories = [[NSString stringWithString:word] componentsSeparatedByString:@"$"];		
                  // Make them unique
                  self.categories = [[NSSet setWithArray: self.categories] allObjects];
               }
               i++;
            }            
         }
		}
      if ([self.categories count] == 0) {
         
         UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"Video Not Available" message:@"Video recordings not available."
                                                         delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert5 show];	
         [alert5 release];
         
      } else {
         [tableView reloadData];
      }
	} else {
      UIAlertView *noNetworkAlert = [[UIAlertView alloc] initWithTitle:@"Network Not Available" message:@"You do not currently have an internet connection.  You need to have a network connection in order to access videos."
                                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [noNetworkAlert show];	
      [noNetworkAlert release];      
   }
	[activityIndicator stopAnimating];
	
	[ap release];
}

#pragma mark Table View Delegate Methods

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIViewController *next = [[VideoLibraryMenuViewController alloc] initWithNibName: @"VideoLibraryMenuViewController" 
																			  bundle: nil 
                                                       instrument: [[Instrument currentInstrument] cmsName]
																			category: [self.categories objectAtIndex: indexPath.row]];
	[self.navigationController pushViewController: next animated: YES];
	[next release];
   [aTableView deselectRowAtIndexPath: indexPath animated: NO];
}

#pragma mark -
#pragma mark Table View Data Source Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:SimpleTableIdentifier] autorelease];
	}
	
	// Set up the cell
	
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [categories objectAtIndex:row];
	cell.textLabel.font = [UIFont menuFont];
	return cell;
}




@end
