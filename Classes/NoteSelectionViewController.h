//
// File:	   NoteSelectionViewController.h
//
// Abstract:   The view controller for page one of this sample.
//
//  Created by jrtb on 9/08/08.
//  Copyright 2008 jrtb. All rights reserved.

#import <UIKit/UIKit.h>
#import "NotesView.h"
#import "FingeringChartViewController.h"
#import "Instrument.h"
#import "AdBasedController.h"

@interface NoteSelectionViewController : AdBasedController <UIApplicationDelegate, notesDelegate, UIScrollViewDelegate>
{
	UIScrollView						*scrollView;
	NotesView							*notesView;
	UIView								*blankView;
	UIView								*clefView;
	UIView								*topBlank;
	UIActivityIndicatorView				*progressView;
	Instrument							*instrument;	
	NSInteger							noteIndex;	
	CGImageRef							image;
	NSArray								*pickerViewArray;
	UIBarButtonSystemItem				currentSystemItem;
	UISegmentedControl					*styleSegmentedControl;
	FingeringChartViewController				*targetViewController;
}

@property (nonatomic,retain) UIScrollView								*scrollView;
@property (nonatomic,retain) NotesView									*notesView;
@property (nonatomic,retain) UIView										*blankView;
@property (nonatomic,retain) UIView										*clefView;
@property (nonatomic,retain) UIView										*topBlank;
@property (nonatomic,retain) Instrument									*instrument;
@property (nonatomic) NSInteger									noteIndex;
@property (nonatomic,retain) UIActivityIndicatorView					*progressView;
@property (nonatomic,retain) FingeringChartViewController						*targetViewController;

- (void) initNotes;
- (void) releaseNotes;

@end
