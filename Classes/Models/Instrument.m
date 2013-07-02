//
//  Instrument.m
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 6/30/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "Instrument.h"
#import "NSMutableDictionary+Zest.h"
#import "NSArray+Zest.h"

static Instrument *currentInstrument; 
static NSArray *instrumentList; 

@implementation Instrument

@synthesize name, minTrillNote, maxTrillNote, trillLabels, clef, instrumentProperties, minNote, maxNote, abbreviation, noteLabels, adZone;

+ (Instrument *) currentInstrument {
   if (!currentInstrument) {
      [Instrument resetInstrument];
   }
   return currentInstrument;
}

+ (void) resetInstrument {
   CFStringRef instrumentPref = (CFStringRef)CFPreferencesCopyAppValue(CFSTR("instrument"), kCFPreferencesCurrentApplication);
   if (instrumentPref) {
      currentInstrument = [[Instrument alloc] initWithName: (NSString *)instrumentPref];
   } else {
      currentInstrument = [[Instrument alloc] initWithName: [[Instrument instrumentList] objectAtIndex: 0]];
   }
   [(NSString *)instrumentPref release];
}
         
+ (NSArray *)instrumentList {
   if (!instrumentList) {
      NSMutableDictionary *dict = [NSMutableDictionary dictionaryFromResource: @"InstrumentList"];
      instrumentList = [dict objectForKey: @"instrumentList"];         
   }
   return instrumentList;
}

+ (void) setCurrentInstrumentName: (NSString *)instrument {
   CFPreferencesSetAppValue(CFSTR("instrument"), instrument, kCFPreferencesCurrentApplication);
   CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
   [Instrument resetInstrument];
}

- (NSString *) cmsName {
   if ([self.name hasSuffix: @"Trombone"]) {
      return @"trombone";
   } else {
      return self.name;
   }
}

- (NSString *) messageBoardPath {
   return [self.name lowercaseString];
}

- (id) initWithName: (NSString *)instrumentName {
	if (self == [super init]) {
		self.instrumentProperties = [NSMutableDictionary dictionaryFromResource: instrumentName];
		self.trillLabels = [instrumentProperties objectForKey: @"trillLabels"];
		self.adZone = [instrumentProperties objectForKey: @"adZone"];
		self.trillLabels = [self.trillLabels reversed];
		self.noteLabels = [instrumentProperties objectForKey: @"noteNames"];
		self.name = instrumentName;
		self.maxTrillNote = [[instrumentProperties objectForKey: @"maxTrillNote"] intValue];
		self.minTrillNote = [[instrumentProperties objectForKey: @"minTrillNote"] intValue];
		self.maxNote = [[instrumentProperties objectForKey: @"maxNote"] intValue];
		self.minNote = [[instrumentProperties objectForKey: @"minNote"] intValue];
		self.abbreviation = [instrumentProperties objectForKey: @"abbreviation"];
		self.clef = [instrumentProperties objectForKey: @"clef"];
	}
	
	return self;
}

- (BOOL) noteIsFlatOrSharpForIndex: (NSInteger) index {
   NSString *label = [self noteLabelForIndex: index];
   return [label rangeOfString: @"♭"].location != NSNotFound || [label rangeOfString: @"#"].location != NSNotFound;
}

- (NSString *) enharmonicLabelForIndex: (NSInteger) i {
   if ([self noteIsFlatOrSharpForIndex: i]) {
      if (i>0) {
         if ([self noteIsFlatOrSharpForIndex: i-1]) {
            return [NSString stringWithFormat: @"%@ / %@", [self noteLabelForIndex: i-1], [self noteLabelForIndex: i]];
         }
      } 
      if (i < maxNote) {
         if ([self noteIsFlatOrSharpForIndex: i+1]) {
            return [NSString stringWithFormat: @"%@ / %@",[self noteLabelForIndex: i], [self noteLabelForIndex: i+1]];
         }      
      }       
   }
   return [self noteLabelForIndex: i];
}

- (NSString *) noteLabelForIndex: (NSInteger) i {
   return [self.noteLabels objectAtIndex: i];
}

- (NSString *) trillLabelForIndex: (NSInteger) i {
   return [[self trillValuesForIndex: i] objectForKey: @"trillLabel"];
}

- (NSString *) trillNoteLabelForIndex: (NSInteger) i {
   return [[self trillValuesForIndex: i] objectForKey: @"noteLabel"];
}


- (NSString *) trillImageNameForIndex: (NSInteger) i {
   return [NSString stringWithFormat: @"html/%@_notes/%@.gif", self.clef, [[self trillValuesForIndex: i] objectForKey: @"noteTrillImage"]];
}

- (NSArray *) trillFingeringChartsForIndex: (NSInteger) index {
	NSInteger actualIndex = index - self.minTrillNote + 1;
	UIImage *img = nil;
	NSMutableArray *result = [NSMutableArray array];
	NSString *fileName;
	
	for (int i=0; i<3; i++) {
		fileName = [NSString stringWithFormat: i?@"%@T%i%c.png":@"%@T%i.png", abbreviation, actualIndex, 'a'+i];
      NSLog(@"Trill fingering chart for index %d = %@", index, fileName);		
		if (img = [UIImage imageNamed: fileName])
			[result addObject:img];
		else 
			break;
	}
	
	return result; 
}

- (NSArray *) noteFingeringChartsForIndex: (NSInteger) index {
	UIImage *img = nil;
	NSMutableArray *result = [NSMutableArray array];
	NSString *fileName;
	
	for (int i=0; i<4; i++) {
		fileName = [NSString stringWithFormat: @"%@%i%c.png", abbreviation, index, 'a'+i];
      NSLog(@"Note fingering chart for index %d = %@", index, fileName);		
		if (img = [UIImage imageNamed: fileName])
			[result addObject:img];
		else 
			break;
	}
	
	return result;   
}


- (BOOL) trebleClef {
   return [self.clef isEqualToString: @"TC"];
}

- (BOOL) bassClef {
   return !self.trebleClef;
}

- (NSString *) noteFileNameForIndex: (NSInteger) i {
   return [NSString stringWithFormat: @"html/%@_notes/%@%i.gif", self.clef, [self.clef substringToIndex: 1], i];
}


- (NSDictionary *) trillValuesForIndex: (NSInteger) i {
   NSInteger actualIndex = i-1;
   return [trillLabels objectAtIndex: actualIndex];
}

- (void) dealloc {
   self.instrumentProperties = nil;
   self.trillLabels = nil;
   self.trillLabels = nil;
   self.adZone = nil;
   self.name = nil;
   self.abbreviation = nil;
   self.clef = nil;
   [super dealloc];
}

@end
