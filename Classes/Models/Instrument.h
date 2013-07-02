//
//  Instrument.h
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 6/30/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Instrument : NSObject {
	NSMutableArray		*trillLabels;
	NSMutableArray		*noteLabels;
   NSString *name;
   NSInteger minTrillNote;
   NSInteger maxTrillNote;
   NSInteger maxNote;
   NSInteger minNote;
   NSString *clef;
   NSString *adZone;
   NSMutableDictionary *instrumentProperties;
   NSString *abbreviation;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *adZone;
@property (nonatomic, retain) NSString *clef;
@property (nonatomic, retain) NSString *abbreviation;
@property (nonatomic, retain) NSMutableArray *trillLabels;
@property (nonatomic, retain) NSMutableArray *noteLabels;
@property (nonatomic) NSInteger minTrillNote;
@property (nonatomic) NSInteger maxTrillNote;
@property (nonatomic) NSInteger minNote;
@property (nonatomic) NSInteger maxNote;
@property (nonatomic, retain) NSMutableDictionary *instrumentProperties;
@property (readonly) BOOL trebleClef;
@property (readonly) BOOL bassClef;

+ (Instrument *) currentInstrument;
+ (void) resetInstrument;
+ (NSArray *) instrumentList;
+ (void) setCurrentInstrumentName: (NSString *) name;

- (NSString *) cmsName;

- (NSDictionary *) trillValuesForIndex: (NSInteger) i;
- (NSString *) trillLabelForIndex: (NSInteger) i;
- (NSString *) trillImageNameForIndex: (NSInteger) i;
- (NSArray *) trillFingeringChartsForIndex: (NSInteger) i;
- (NSString *) trillNoteLabelForIndex: (NSInteger) i;

- (NSString *) enharmonicLabelForIndex: (NSInteger) i;
- (NSString *) noteLabelForIndex: (NSInteger) i;
- (NSString *) noteFileNameForIndex: (NSInteger) i;
- (NSArray *) noteFingeringChartsForIndex: (NSInteger) index;

- (NSString *) messageBoardPath;

@end
