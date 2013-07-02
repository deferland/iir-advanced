//
//  Audio.m
//
//  Created by Brandon Trebitowski on 8/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Audio.h"

static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *insert_statement = nil;
//static sqlite3_stmt *select_statement = nil;

@implementation Audio
@synthesize primaryKey,audioid,audioname,audiodescription,composer,performer,instrument, downloaded, infoURL;

- (void) setDownloaded
{
	self.downloaded = YES;
}

+ (NSInteger)insertNewAudioIntoDatabase:(sqlite3 *)database :(NSString *)nid :(NSString *)nname :(NSString *)ndescription :(NSString *)ncomposer :(NSString *)nperformer :(NSString *)infoURL :(NSString *)ninstrument {
	 
    if (insert_statement == nil) {
        static char *sql = "INSERT INTO audio (id,name,description,composer,performer, infoURL, instrument) VALUES(?,?,?,?,?,?,?)";
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
	
	//NSLog(nname);
	
	sqlite3_bind_int(insert_statement, 1, [nid intValue]);
	sqlite3_bind_text(insert_statement, 2, [nname UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(insert_statement, 3, [ndescription UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(insert_statement, 4, [ncomposer UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(insert_statement, 5, [nperformer UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(insert_statement, 6, [infoURL UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(insert_statement, 7, [ninstrument UTF8String], -1, SQLITE_TRANSIENT);
		
    int success = sqlite3_step(insert_statement);
	
	//NSLog([NSString stringWithFormat:@"success: %i"]);
	
    sqlite3_reset(insert_statement);
    if (success != SQLITE_ERROR) {
        return sqlite3_last_insert_rowid(database);
    }
    NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
    return -1;
	
}

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
	
	if (self = [super init]) {
        primaryKey = pk;
        database = db;
		
		downloaded = NO;
		
        // Compile the query for retrieving book data. See insertNewBookIntoDatabase: for more detail.
        if (init_statement == nil) {
            // Note the '?' at the end of the query. This is a parameter which can be replaced by a bound variable.
            // This is a great way to optimize because frequently used queries can be compiled once, then with each
            // use new variable values can be bound to placeholders.
            const char *sql = "SELECT id,name,description,composer,performer, infoURL, instrument FROM audio WHERE pk=?";
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
        // For this query, we bind the primary key to the first (and only) placeholder in the statement.
        // Note that the parameters are numbered from 1, not from 0.
        sqlite3_bind_int(init_statement, 1, primaryKey);
        if (sqlite3_step(init_statement) == SQLITE_ROW) {
			if ((char *)sqlite3_column_text(init_statement, 0)) {
				self.audioid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 0)];
			} else {
				self.audioid = @"";
			}
			if ((char *)sqlite3_column_text(init_statement, 1)) {
				self.audioname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 1)];
			} else {
				self.audioname = @"";
			}
			if ((char *)sqlite3_column_text(init_statement, 2)) {
				self.audiodescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 2)];
			} else {
				self.audiodescription = @"";
			}
			if ((char *)sqlite3_column_text(init_statement, 3)) {
				self.composer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 3)];
			} else {
				self.composer = @"";
			}
			if ((char *)sqlite3_column_text(init_statement, 4)) {
				self.performer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 4)];
			} else {
				self.performer = @"";
			}
        if ((char *)sqlite3_column_text(init_statement, 5)) {
           self.infoURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 5)];
        } else {
           self.infoURL = @"";
        }
           if ((char *)sqlite3_column_text(init_statement, 6)) {
				self.instrument = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 6)];
			} else {
				self.instrument = @"";
			}
        } else {
            self.audioid = @"";
            self.audioname = @"Nothing";
            self.audiodescription = @"";
            self.composer = @"";
            self.performer = @"";
            self.instrument = @"";
           self.infoURL = @"";
        }
        // Reset the statement for future reuse.
        sqlite3_reset(init_statement);
    }
    return self;
}

@end
