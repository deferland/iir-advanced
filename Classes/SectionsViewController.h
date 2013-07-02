//
//  SectionsViewController.h
//  Sections
//
//  Created by Jeff LaMarche on 7/10/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdBasedController.h"

@interface SectionsViewController : AdBasedController 
	<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
	IBOutlet	UITableView *table;
	IBOutlet	UISearchBar *search;
	NSDictionary			*allNames;
	NSMutableDictionary		*names;
	NSMutableArray			*keys;
	UIBarButtonSystemItem currentSystemItem;

}
@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) UISearchBar *search;
@property (nonatomic, retain) NSDictionary *allNames;
@property (nonatomic, retain) NSMutableDictionary *names;
@property (nonatomic, retain) NSMutableArray *keys;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;

@end

