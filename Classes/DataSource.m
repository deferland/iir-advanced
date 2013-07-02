//
//  DataSource.m
//  mapViewer
//
//  Created by Evgen Bodunov on 6/4/09.
//  Copyright 2009 Evgen Bodunov. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

@synthesize data;

static DataSource *sharedDataSource = nil;

#pragma mark Init Part

- (void) initDefaultData{

	if (![data objectForKey:@"FirstRun"]) {
		[data setObject:@"1" forKey:@"FirstRun"];
	}
}

- (id) init {
	if (self = [super init])
	{
		self.data = [NSMutableDictionary dictionary];

		[self loadData];
		[self initDefaultData];
	}
	return self;
}

#pragma mark Singleton Code

+(DataSource*)source {
    @synchronized(self) {
        if (sharedDataSource == nil)
            [[self alloc] init];
    }
    return sharedDataSource;
}

+(NSMutableDictionary *)data {
    return [DataSource source].data;
}

+(id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedDataSource == nil) {
            sharedDataSource = [super allocWithZone:zone];
            return sharedDataSource;
        }
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone {
    return self;
}

-(id)retain {
    return self;
}

-(unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

-(void)release {
    //do nothing
}

-(id)autorelease {
    return self;
}

/*
#pragma mark NSCoder protocol

- (id)initWithCoder:(NSCoder *)decoder {
	
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	
} */

#pragma mark SaveLoad Logic

- (void) saveData {
	NSMutableData *tempData;

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:@"Settings.archive"];
	NSKeyedArchiver *archiver;
	BOOL result;
	
	tempData = [NSMutableData data];
	archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:tempData];
	// Customize archiver here
	[archiver encodeObject:data forKey:@"data"];
	[archiver finishEncoding];
	result = [tempData writeToFile:archivePath atomically:YES];
	[archiver release];
}

- (void) loadData {
	NSData *tempData;
	NSKeyedUnarchiver *unarchiver;

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:@"Settings.archive"];
	
	tempData = [NSData dataWithContentsOfFile:archivePath];
	
	if (tempData) {
		unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:tempData];
		// Customize unarchiver here
		NSMutableDictionary *tmpDict = [unarchiver decodeObjectForKey:@"data"];
		if (tmpDict)
			self.data = tmpDict;
		[unarchiver finishDecoding];
		[unarchiver release];
	}
}

@end
