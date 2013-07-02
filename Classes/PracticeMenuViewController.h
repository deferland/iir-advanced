//
//  PractiveMenuViewController.h
//  Simple Table
//

#import <UIKit/UIKit.h>
#import "EquipmentGuideViewController.h"
#import "AdBasedController.h"

@interface PracticeMenuViewController : AdBasedController
	<UITableViewDelegate, UITableViewDataSource>
{
	NSArray *listData;
	UIBarButtonSystemItem				currentSystemItem;
	NSString							*instrument;	
	EquipmentGuideViewController				*targetViewController4;
	BOOL								bottomLevel;
	
}
@property (nonatomic, retain) NSArray *listData;
@property (nonatomic,retain) NSString									*instrument;
@property (nonatomic,retain) EquipmentGuideViewController						*targetViewController4;
@property					 BOOL										bottomLevel;

@end


