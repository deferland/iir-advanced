
#import "FileResourceMenuItem.h"
#import "AdBasedController.h"

@interface FileResourceBasedMenuController : AdBasedController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *items;
	IBOutlet UITableView *tableView;
	FileResourceMenuItem *fileMenuItem;
}

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) FileResourceMenuItem *fileMenuItem;


- (id) initWithFileMenuItem: (FileResourceMenuItem *) fileMenuItem;

/*
 - (NSDictionary *) sectionAtIndex: (NSInteger) index;
 - (NSString *) sectionName: (NSInteger) sectionIndex;
 - (NSMutableArray *) itemsInSection: (NSInteger)sectionIndex;
 - (NSDictionary *) itemForIndexPath: (NSIndexPath *)path;
 */


@end
