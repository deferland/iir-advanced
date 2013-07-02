
#import "FileResourceMenuItem.h"
#import "FileResourceViewController.h"
#import "FileResourceBasedMenuController.h"


@implementation FileResourceMenuItem

@synthesize path, extension, title, description, resourceName, directory, controllerClass, sortValue;

             

- (id) initWithPath: (NSString *) myPath {
	if (self = [super init]) {
		self.path = myPath;
		NSFileManager *fileMgr = [NSFileManager defaultManager];
		[fileMgr fileExistsAtPath: self.path isDirectory: &directory];
		NSString *fileName = [[self.path pathComponents] lastObject];
		NSString *fullName;
		if (directory) {
			self.extension = @"";
			fullName = fileName;
		} else {
			self.extension = [self.path pathExtension];                  
			fullName = [fileName substringToIndex: (fileName.length - extension.length - 1)];
		}
      // You can also put a sort value at the end of the name, e.g. Foo.2.html
      self.sortValue = [fullName pathExtension];
      if ([self.sortValue length] > 0) {
         fullName = [fullName substringToIndex: (fullName.length - self.sortValue.length - 1)];            
      }
		NSArray *itemTitleAndDescription = [fullName componentsSeparatedByString: @"--"];
		self.title = [itemTitleAndDescription objectAtIndex: 0];
		if ([itemTitleAndDescription count] > 1) {
			self.description = [itemTitleAndDescription objectAtIndex: 1];
		}
		if ([extension isEqualToString: @"html"] || [extension isEqualToString: @"pdf"]) {
			controllerClass = [FileResourceViewController class];
		} else if (directory) {
			controllerClass = [FileResourceBasedMenuController class];
		} 
	}
	return self;
}

- (NSComparisonResult) compare: (FileResourceMenuItem *) other {
   if (self.sortValue) {
      return [self.sortValue compare: other.sortValue];      
   } else {
      return NSOrderedSame;
   }
}

- (void) dealloc {
	self.path = nil;
	self.extension = nil;
	self.title = nil;
	self.description = nil;
	self.resourceName = nil;
	[super dealloc];
}

@end
