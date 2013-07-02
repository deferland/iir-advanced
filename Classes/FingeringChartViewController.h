//
// File:	   FingeringChartViewController.h
//
// Abstract:   The view controller for page two of this sample.

#import <UIKit/UIKit.h>
#import "Instrument.h"

@interface FingeringChartViewController : UIViewController <UIScrollViewDelegate>
{
	UIScrollView						*scrollView;	// holds alt fingering images to scroll horizontally
	Instrument							*instrument;	
	NSInteger							noteIndex;	
	CGImageRef							image;
	NSArray								*pickerViewArray;
	UIBarButtonSystemItem				currentSystemItem;
	UISegmentedControl					*styleSegmentedControl;	
	UIColor								*defaultTintColor;
	UISegmentedControl					*segmentedControl;
	UIBarButtonItem						*segmentBarItem;
	UIImageView							*rightView;
	UIImageView							*leftView;
	UIImageView							*rightView2;
	UIImageView							*leftView2;
	int									scrollPosition;
}

@property (nonatomic, retain) UIView									*scrollView;
@property (nonatomic, retain) UIImageView								*rightView;
@property (nonatomic, retain) UIImageView								*leftView;
@property (nonatomic, retain) UIImageView								*rightView2;
@property (nonatomic, retain) UIImageView								*leftView2;
@property (nonatomic) NSInteger									noteIndex;
@property (nonatomic,retain) Instrument									*instrument;
@property (nonatomic,retain) UISegmentedControl							*segmentedControl;
@property (nonatomic,retain) UIBarButtonItem							*segmentBarItem;
@property					 int										scrollPosition;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil noteIndex:(NSInteger)noteIndex;
- (void)segmentAction:(id)sender;
- (void) releaseImages;
- (void) initImages;
- (void) drawImages;

@end
