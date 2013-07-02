//
//  VideoPlaylistMenuViewController.h
//  Simple Table
//

#import <UIKit/UIKit.h>
#import "AdBasedController.h"

@interface VideoPlaylistMenuViewController : AdBasedController
	<UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate>
{
	IBOutlet UITableView				*myTableView;
	NSArray								*listData;
	UIBarButtonSystemItem				currentSystemItem;
	NSString							*instrument;	
	BOOL								bottomLevel;
	
	NSNumber							*numFiles;
	NSString							*ids;
	NSNumber							*currentFile;
	NSMutableArray						*idArray;
	NSMutableArray						*nameArray;
	NSMutableArray						*urlArray;
	NSMutableArray						*infoArray;

	NSMutableArray						*savedIdArray;

	UIView								*myView;
	UIActivityIndicatorView				*progressView2;
	UILabel								*label;
   
   NSMutableArray *moviePlayers;

		
}
@property (nonatomic, retain) UITableView								*myTableView;
@property (nonatomic, retain) NSArray									*listData;
@property (nonatomic,retain)  NSString									*instrument;
@property					  BOOL										bottomLevel;

@property (nonatomic, retain) NSNumber									*numFiles;
@property (nonatomic, retain) NSString									*ids;
@property (nonatomic, retain) NSNumber									*currentFile;
@property (nonatomic, retain) NSMutableArray							*idArray;
@property (nonatomic, retain) NSMutableArray							*savedIdArray;
@property (nonatomic, retain) NSMutableArray							*nameArray;
@property (nonatomic, retain) NSMutableArray							*urlArray;
@property (nonatomic, retain) NSMutableArray							*infoArray;

- (void)playMovieAtURL:(NSURL*)theURL;
- (void)myMovieFinishedCallback:(NSNotification*)aNotification;
- (IBAction)loadAudio;

- ( BOOL )isDataSourceAvailable;
- (void) playAudio:(UIButton *)sender;
- (void) saveAudio:(UIButton *)sender;

@end


