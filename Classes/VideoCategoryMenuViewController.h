//
//  VideoCategoryMenuViewController.h
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 6/16/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdBasedController.h"

@interface VideoCategoryMenuViewController : AdBasedController <UITableViewDelegate, UITableViewDataSource> {
	NSArray		*categories;
	
	IBOutlet UIActivityIndicatorView * activityIndicator;
   IBOutlet UITableView *tableView;
}

@property(nonatomic, retain) NSArray *categories;

-(void)loadCategories;


@end
