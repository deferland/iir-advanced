//
//  AudioLibraryMenuViewController.h
//  Simple Table
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#import "LibraryMenuViewController.h"

@interface AudioLibraryMenuViewController : LibraryMenuViewController
{
	NSMutableData						*receivedData;
	NSNumber							*totalFileSize;
	UIAlertView							*progressAlert;
	UIProgressView						*progressView;	
	
	NSArray								*fileList;	
	
	NSNumber							*totalSize;
	NSNumber							*currentSize;

	NSMutableArray				*totalSizeArray;

	NSMutableArray				*descriptionArray;
	NSMutableArray				*composerArray;
	NSMutableArray				*performerArray;
   NSURLConnection								*currentConnection;
   
	sqlite3 *database;
	NSMutableArray *audios;
}

@property (nonatomic, retain) NSArray									*fileList;
@property (nonatomic, retain) NSNumber									*totalFileSize;
@property (nonatomic, retain) UIAlertView								*progressAlert;
@property (nonatomic, retain) UIProgressView							*progressView;

@property (nonatomic, retain) NSNumber									*totalSize;
@property (nonatomic, retain) NSNumber									*currentSize;

@property (nonatomic, retain) NSMutableArray							*totalSizeArray;

@property (nonatomic, retain) NSMutableArray							*descriptionArray;
@property (nonatomic, retain) NSMutableArray							*composerArray;
@property (nonatomic, retain) NSMutableArray							*performerArray;


@property (nonatomic,retain) NSMutableData								*receivedData;
@property (nonatomic,retain) NSURLConnection								*currentConnection;

@property (nonatomic, retain) NSMutableArray *audios;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil instrument:(NSString *)instrumentString;
- (IBAction)loadAudio;

- (void) playAudio:(UIButton *)sender;
- (void) infoURLPressed:(UIButton *)sender;
- (void) getFile :(int)file;

@end


