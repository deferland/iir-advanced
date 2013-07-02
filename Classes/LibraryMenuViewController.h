//
//  LibraryMenuViewController.h
//  instruments-in-reach-v2
//
//  Created by Evgen Bodunov on 7/12/09.
//  Copyright 2009 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdBasedController.h"

@interface LibraryMenuViewController : AdBasedController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UIView			*headerView;
	IBOutlet UITableView	*myTableView;
	
	NSArray					*listData;
	NSString				*instrument;	
	BOOL					bottomLevel;
	
	UIBarButtonSystemItem	currentSystemItem;
	
	NSNumber				*numFiles;
	NSString				*ids;
	NSNumber				*currentFile;
	
	NSMutableArray			*idArray;
	NSMutableArray			*nameArray;
	NSMutableArray			*infoArray;
	NSMutableArray			*moviePlayers;
	
	UIView					*myView;
	UIActivityIndicatorView	*activityIndicator;
	UILabel					*label;
}

@property (nonatomic, retain)	NSNumber *currentFile;
@property (nonatomic, retain)	UITableView		*myTableView;
@property (nonatomic, retain)	NSArray			*listData;
@property (nonatomic, retain)	NSString		*instrument;
@property (assign)				BOOL			bottomLevel;

@property (nonatomic, retain)	NSNumber		*numFiles;
@property (nonatomic, retain)	NSString		*ids;

@property (nonatomic, retain)	NSMutableArray	*idArray;
@property (nonatomic, retain)	NSMutableArray	*nameArray;
@property (nonatomic, retain)	NSMutableArray	*infoArray;
@property (nonatomic, retain) UIActivityIndicatorView	*activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil instrument:(NSString *)instrumentString;

- (void)playMovieAtURL:(NSURL*)theURL;
- (void)myMovieFinishedCallback:(NSNotification*)aNotification;

- ( BOOL )isDataSourceAvailable;

@end
