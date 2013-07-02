//
//  MenuViewController.h
//  Simple Table
//

#import <UIKit/UIKit.h>

#import "Instrument.h"
#import "AdBasedController.h"

@interface MenuViewController : AdBasedController
	<UITableViewDelegate, UITableViewDataSource>
{
	NSArray *contents;
	Instrument *instrument;	
   
}

@property (nonatomic, retain) NSArray *contents;
@property (nonatomic,retain) Instrument	*instrument;

@end