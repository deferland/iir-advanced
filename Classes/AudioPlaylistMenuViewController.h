//
//  AudioPlaylistMenuViewController.h
//  Simple Table
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "AdBasedController.h"

@interface AudioPlaylistMenuViewController : AdBasedController
	<UITableViewDelegate, UITableViewDataSource>
{
	IBOutlet UITableView				*myTableView;
	NSArray								*listData;
	UIBarButtonSystemItem				currentSystemItem;
	NSString							*instrument;	
	BOOL								bottomLevel;
	NSArray								*fileList;
	
    NSMutableData						*receivedData;
	NSNumber							*totalFileSize;
	UIAlertView							*progressAlert;
	UIProgressView						*progressView;
	
	NSNumber							*numFiles;
	NSNumber							*totalSize;
	NSNumber							*currentSize;
	NSString							*ids;
	NSNumber							*currentFile;
	NSArray								*idArray;
	NSArray								*nameArray;
	NSArray								*descriptionArray;
	NSArray								*composerArray;
	NSArray								*performerArray;
	NSArray								*infoArray;
   NSMutableArray *moviePlayers;
	
	UIView								*myView;
	UIActivityIndicatorView				*progressView2;
	UILabel								*label;
	
	sqlite3 *database;
	NSMutableArray *audios;
	
}
@property (nonatomic, retain) UITableView								*myTableView;
@property (nonatomic, retain) NSArray									*listData;
@property (nonatomic,retain)  NSString									*instrument;
@property					  BOOL										bottomLevel;
@property (nonatomic, retain) NSArray									*fileList;
@property (nonatomic, retain) NSNumber									*totalFileSize;
@property (nonatomic, retain) UIAlertView								*progressAlert;
@property (nonatomic, retain) UIProgressView							*progressView;

@property (nonatomic, retain) NSNumber									*numFiles;
@property (nonatomic, retain) NSNumber									*totalSize;
@property (nonatomic, retain) NSNumber									*currentSize;
@property (nonatomic, retain) NSString									*ids;
@property (nonatomic, retain) NSNumber									*currentFile;
@property (nonatomic, retain) NSArray									*idArray;
@property (nonatomic, retain) NSArray									*nameArray;
@property (nonatomic, retain) NSArray									*descriptionArray;
@property (nonatomic, retain) NSArray									*composerArray;
@property (nonatomic, retain) NSArray									*performerArray;
@property (nonatomic, retain) NSArray									*infoArray;

@property (nonatomic,retain) NSMutableData								*receivedData;

@property (nonatomic, retain) NSMutableArray *audios;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil instrument:(NSString *)instrumentString;
- (void)playMovieAtURL:(NSURL*)theURL;
- (void)myMovieFinishedCallback:(NSNotification*)aNotification;
- (IBAction)loadAudio;
- (void) getNextFile;

- ( BOOL )isDataSourceAvailable;
- (void) playAudio:(id)sender;

@end


