//
//  LibraryMenuViewController.m
//  instruments-in-reach-v2
//
//  Created by Evgen Bodunov on 7/12/09.
//  Copyright 2009 none. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#import "LibraryMenuViewController.h"
#import "ContentItemTableCell.h"

@implementation LibraryMenuViewController

@synthesize myTableView, listData, instrument, bottomLevel, numFiles, ids, idArray, nameArray, infoArray, currentFile, activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil instrument:(NSString *)instrumentString
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		self.bottomLevel = YES;
		
		// create blank view on top of table view to display loading and no files available messages
		myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 54.0, 320.0, 338.0)];
		myView.backgroundColor = [UIColor whiteColor];
		
		self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
		[myView addSubview:activityIndicator];
		activityIndicator.center = CGPointMake(160, 110);
		[activityIndicator startAnimating];  
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 140.0, 320.0, 20.0)];
		label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:14];
		label.textColor = [UIColor blackColor];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.numberOfLines = 1;
		
		[myView addSubview:label];  
		
		[self.view addSubview:myView];
		
		moviePlayers = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)dealloc {
   self.numFiles = nil;
	[myTableView setDelegate:nil];
	[myTableView release];
	[idArray release];
	
	[nameArray release];
	
	[instrument release];
	[listData release];
	[moviePlayers release];
	self.activityIndicator = nil;
	[super dealloc];	
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

-(void)playMovieAtURL:(NSURL*)theURL 

{
	MPMoviePlayerController* theMovie=[[MPMoviePlayerController alloc] initWithContentURL:theURL]; 
	
	/* 
	 Movie scaling mode can be one of: MPMovieScalingModeNone, MPMovieScalingModeAspectFit,
	 MPMovieScalingModeAspectFill, MPMovieScalingModeFill.
	 */    
	theMovie.scalingMode=MPMovieScalingModeAspectFill; 
	
	
	
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
	[theMovie release]; 
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSUInteger row = [indexPath row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.numFiles intValue];  
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *CellIdentifier = [NSString stringWithFormat:@"%@ %d", @"DataCell_", indexPath.row];
	
	ContentItemTableCell *cell = (ContentItemTableCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil) {
		cell = [[[ContentItemTableCell alloc] initWithFrame: CGRectMake(0,0,320,80)
											reuseIdentifier: CellIdentifier] autorelease];
		
		[cell.playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
		[cell.infoButton addTarget:self action:@selector(infoURLPressed:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return cell;
}

#pragma mark Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	ContentItemTableCell *cell = (ContentItemTableCell *) [self tableView: tableView cellForRowAtIndexPath: indexPath];
	return [cell rowHeight];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self.navigationController popViewControllerAnimated: YES];
}

@end
