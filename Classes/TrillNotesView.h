//
//  TrillNotesView.h
//  instruments-in-reach-v2
//
//  Created by jrtb on 10/8/08.
//  Copyright 2008 jrtb. All rights reserved.
//

// this class overrides a uiwebview for the purpose of tracking and intercepting touches with the goal of eliminating vertical scrolling

#import "Instrument.h"

@protocol TrillNotesDelegate
- (void) selectedNote:(NSInteger)noteIndex instrument:(Instrument *)instrument;
@end

@interface TrillNotesView : UIView { 

@protected
	id <NSObject, TrillNotesDelegate> delegate;
	BOOL				drawn;
	CGPoint				firstTouch;
	CGPoint				lastTouch;
	int					startingNote;
	int					currentNote;
	int					currentX;
	BOOL				touchesMoved;
	BOOL				touchesStarted;
	BOOL				touchesEnded;
	UIView				*noteCView;
	UIImageView			*noteC;
	Instrument *instrument;
}

@property (retain)			  id <NSObject, TrillNotesDelegate>		delegate;
@property					  BOOL								drawn;
@property					  CGPoint							firstTouch;
@property					  CGPoint							lastTouch;
@property					  int								startingNote;
@property					  int								currentNote;
@property					  int								currentX;
@property (nonatomic,retain)  Instrument					*instrument;
@property					  BOOL								touchesMoved;
@property					  BOOL								touchesStarted;
@property					  BOOL								touchesEnded;
@property (nonatomic,retain)  UIView							*noteCView;
@property (nonatomic,retain)  UIImageView						*noteC;



- (void)initNotes;
//- (void)updateNotes;
- (void)drawNotes;
- (void)handleTimer;

@end
