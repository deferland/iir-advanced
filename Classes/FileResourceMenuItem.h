
#import "Desiccant.h"

@class ACMenuController;
@class FileResourceViewController;

@interface FileResourceMenuItem : NSObject {
	NSString *path;
	NSString *extension;
	NSString *title;
	NSString *description;
	NSString *resourceName;
   NSString *sortValue;
	Class controllerClass;
	BOOL directory;
}

@property(nonatomic, retain) NSString *path;
@property(nonatomic, retain) NSString *sortValue;
@property(nonatomic, retain) NSString *extension;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *resourceName;
@property(nonatomic, readonly) Class controllerClass;
@property(nonatomic, readonly) BOOL directory;

- (id) initWithPath: (NSString *) path;
- (NSComparisonResult) compare: (FileResourceMenuItem *) other;

@end
