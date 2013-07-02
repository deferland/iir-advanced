//
//  PrefsViewController.h
//  locationPOC
//
//  Created by jrtb on 8/21/08.
//  Copyright 2008 jrtb. All rights reserved.
//

#import "RootViewController.h"

@interface PrefsViewController : UIViewController {
	id					flipDelegate;
	IBOutlet UILabel	*prefsLabelView;
	IBOutlet UIButton	*infoButtonLight;
}
@property (nonatomic,assign) id <MyFlipControllerDelegate>	flipDelegate;
@property (nonatomic,retain) UIButton						*infoButtonLight;
@property (nonatomic,retain) UILabel						*prefsLabelView;

- (IBAction)infoButtonPressed:(id)sender;

@end
