
#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UILabel *appName;
	IBOutlet UILabel *copyright;
	IBOutlet UILabel *version;
	UIBarButtonSystemItem currentSystemItem;
	UIScrollView						*scrollView;
	UIImageView							*instructionsView;

}

- (IBAction)dismissAction:(id)sender;

@end
