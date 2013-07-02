//
// File:	   InstrumentListController.h
//
// Abstract:   The application's main view controller (front page).

#import <UIKit/UIKit.h>
#import "AdBasedController.h"


@interface InstrumentListViewController : AdBasedController <UITableViewDelegate, UITableViewDataSource>
{
   NSArray *instruments;
}

@end
