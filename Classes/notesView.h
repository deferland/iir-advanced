//
//  NotesView.h
//  instruments-in-reach-v2
//
//  Created by jrtb on 10/8/08.
//  Copyright 2008 jrtb. All rights reserved.
//

// this class overrides a uiwebview for the purpose of tracking and intercepting touches with the goal of eliminating vertical scrolling

#import "Instrument.h"

@protocol notesDelegate
- (void) selectedNote:(NSInteger)noteIndex;
@end


@interface NotesView : UIView { 

@protected
	id <NSObject, notesDelegate> delegate;
	BOOL				drawn;
	Instrument			*instrument;	
   NSInteger noteIndex;
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
	
}

@property (retain)			  id <NSObject, notesDelegate>		delegate;
@property					  BOOL								drawn;
@property (nonatomic,retain)  Instrument							*instrument;
@property					  CGPoint							firstTouch;
@property					  CGPoint							lastTouch;
@property					  NSInteger								noteIndex;
@property					  int								startingNote;
@property					  int								currentX;
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
