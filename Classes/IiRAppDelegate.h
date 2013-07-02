//
//  IiRAppDelegate.h
//  IiR
//
//  Created by jrtb on 9/15/08.
//  Copyright jrtb 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;
@class IiRViewController;

@interface IiRAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet RootViewController *rootViewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *rootViewController;

@end

