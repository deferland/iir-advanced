//
//  TrillNotesView.m
//  instruments-in-reach-v2
//
//  Created by jrtb on 10/8/08.
//  Copyright 2008 jrtb. All rights reserved.
//

#import "TrillNotesView.h"
#import "NSMutableDictionary+Zest.h"
#import "NSArray+Zest.h"

@implementation TrillNotesView

@synthesize delegate, instrument, firstTouch, lastTouch, touchesMoved, touchesStarted, touchesEnded;
@synthesize startingNote, currentNote, currentX, drawn, noteCView, noteC;


- (void)drawNotes {
	
	NSLog(@"allocing TrillNoteView components");

	int loopCount = 0;
	int lastX = 0;
	for (int i=self.instrument.minTrillNote; i <= self.instrument.maxTrillNote; i++) {
		
		double noteX = currentX+(74.0*loopCount);
		
		// label for note 1
		UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(noteX+6.0, 2.0, 74.0, 40.0)];
		[noteLabel setText: [instrument trillNoteLabelForIndex: i]];
		[noteLabel setTextAlignment:UITextAlignmentCenter];
		noteLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:12];
		noteLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:noteLabel];
		[noteLabel release];
		
		// box for note 1
		UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(noteX+28.0, 8.0, 32.0, 28.0)];
		UIImageView *box = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"square.png"]];
		[boxView addSubview:box];
		[self addSubview:boxView];	
		[boxView release];
		[box release];
		
		// image for note 1
		UIView *noteView = [[UIView alloc] initWithFrame:CGRectMake(noteX, 40.0, 74.0, 113.0)];
		UIImageView *note = [[UIImageView alloc] initWithImage:[UIImage imageNamed: [instrument trillImageNameForIndex: i]]];
//		NSLog(@"%@",  [instrument trillImageNameForIndex: i]);
		//add image view to view
		[noteView addSubview:note];
		[self addSubview:noteView];	
		[noteView release];
		[note release];
		
		loopCount++;
		lastX = noteX+74;
		
	}
	
	NSLog(@"getting here?");
	
	UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(lastX, 40.0, 74.0, 113.0)];
	UIImageView *end = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat: @"html/note_end%@.gif", instrument.clef]]];
	//add image view to view
	[endView addSubview:end];
	[self addSubview:endView];	
	[endView release];
	[end release];
	
	self.drawn = YES;
}	

- (void)initNotes {
	//NSLog(@"init notes");

	// starting left position = 32
	// each note is 44 pixels wide
	// note is 153 pixels high total, 40 for name and 113 for image
	
	currentX = 0;
	
	//NSLog(self.instrument);
	
	
	if ([instrument.clef isEqualToString:@"TC"]) {
		startingNote = 21;
	} else {
		startingNote = 29;
   }
	self.currentNote = self.startingNote;
	
}	

- (void)handleTimer {
	//NSLog(@"remove click view");
	[noteCView removeFromSuperview];
}	

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event allTouches];
	self.lastTouch = [[[touches allObjects] objectAtIndex:([allTouches count]-1)] locationInView:self];
	NSInteger noteIndex = (((self.lastTouch.x)/74)+instrument.minTrillNote);

	int clickPosition = (int)((self.lastTouch.x)/74);
	
	//NSLog([NSString stringWithFormat:@"clickPosition: %i",clickPosition]);
	
	int drawX = (clickPosition*74)+24;
	
	// click image for note
	noteCView = [[UIView alloc] initWithFrame:CGRectMake(drawX, 0.0, 74.0, 153.0)];
	noteC = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"note_click.png"]];
	//add image view to view
	[noteCView addSubview:noteC];
	noteCView.alpha = 0.4;
	[self addSubview:noteCView];	
	[self bringSubviewToFront:noteCView];
	//NSLog(@"adding click image");
	
	NSTimer *timer;
	
	timer = [NSTimer scheduledTimerWithTimeInterval: 0.5
											 target: self
										   selector: @selector(handleTimer)
										   userInfo: nil
											repeats: NO];
	
	[delegate selectedNote:noteIndex instrument:self.instrument];
	
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
   
   self.instrument = [Instrument currentInstrument];
	// Initialization code
	//NSLog(@"init notesView");
	
	touchesStarted = NO;
	touchesMoved = NO;
	touchesEnded = YES;

	self.autoresizesSubviews = NO;
	//self.multipleTouchEnabled = YES;
	
	self.drawn = NO;
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
			
}

- (void)dealloc {

	[delegate release];
	self.instrument = nil;
	[noteCView removeFromSuperview];
	[noteCView release];
	[noteC removeFromSuperview];
	[noteC release];
	
    [super dealloc];
}

@end
