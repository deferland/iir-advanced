//
// File:	   TrillSelectionViewController.h
//
// Abstract:   The view controller for page one of this sample.
//
//  Created by jrtb on 9/08/08.
//  Copyright 2008 jrtb. All rights reserved.

#import <UIKit/UIKit.h>
#import "TrillNotesView.h"
#import "TrillChartViewController.h"
#import "Instrument.h"
#import "AdBasedController.h"

@interface TrillSelectionViewController : AdBasedController <UIApplicationDelegate, TrillNotesDelegate, UIScrollViewDelegate>
{
	UIScrollView						*scrollView;
	TrillNotesView						*notesView;
	UIView								*myView;
	UIView								*myView2;
	UIView								*myView3;
	UIActivityIndicatorView				*progressView;
	Instrument							*instrument;	
	NSInteger							*noteIndex;	
	CGImageRef							image;
	NSArray								*pickerViewArray;
	UIBarButtonSystemItem				currentSystemItem;
	UISegmentedControl					*styleSegmentedControl;
	TrillChartViewController			*targetViewController;
}

@property (nonatomic,retain) UIScrollView								*scrollView;
@property (nonatomic,retain) TrillNotesView								*notesView;
@property (nonatomic,retain) UIView										*myView;
@property (nonatomic,retain) UIView										*myView2;
@property (nonatomic,retain) UIView										*myView3;
@property (nonatomic,retain) Instrument									*instrument;
@property (nonatomic,retain) UIActivityIndicatorView					*progressView;
@property (nonatomic,retain) TrillChartViewController					*targetViewController;

- (void) initNotes;
- (void) releaseNotes; 

@end
