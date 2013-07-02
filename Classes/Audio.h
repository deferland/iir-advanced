//
//  Audio.h
//
//  Created by Brandon Trebitowski on 8/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Audio : NSObject {
	sqlite3 *database;
	NSInteger primaryKey;
	NSString *audioid;
	NSString *audioname;
	NSString *audiodescription;
	NSString *composer;
	NSString *performer;
	NSString *instrument;
	NSString *infoURL;
	BOOL	 downloaded;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (nonatomic, retain) NSString *audioid;
@property (nonatomic, retain) NSString *audioname;
@property (nonatomic, retain) NSString *audiodescription;
@property (nonatomic, retain) NSString *composer;
@property (nonatomic, retain) NSString *performer;
@property (nonatomic, retain) NSString *infoURL;
@property (nonatomic, retain) NSString *instrument;
@property					  BOOL	   downloaded;

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
+ (NSInteger)insertNewAudioIntoDatabase:(sqlite3 *)database :(NSString *)nid :(NSString *)nname :(NSString *)ndescription :(NSString *)ncomposer :(NSString *)nperformer :(NSString *)infoURL :(NSString *)ninstrument;
- (void) setDownloaded;

@end