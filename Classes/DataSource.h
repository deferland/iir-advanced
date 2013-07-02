//
//  DataSource.h
//  mapViewer
//
//  Created by Evgen Bodunov on 6/4/09.
//  Copyright 2009 Evgen Bodunov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject {
	NSMutableDictionary *data;
}

+ (DataSource *)source;
+ (NSMutableDictionary *)data;

- (void)loadData;
- (void)saveData;

@property (nonatomic, retain) NSMutableDictionary *data;

@end
