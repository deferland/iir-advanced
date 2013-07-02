//
//  AdBasedController.h
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 4/17/10.
//  Copyright 2010 ZWorkbench, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdViewController.h"
#import "DTImageViewDelegate.h"

@interface AdBasedController : UIViewController <DTImageViewDelegate> {
   IBOutlet UIView *adHolder;
   AdViewController *adViewController;
   BOOL viewShowing;
   BOOL adLoaded;
   
}

@property (nonatomic, retain) AdViewController *adViewController;
@property (nonatomic, retain) IBOutlet UIView *adHolder;

@end
