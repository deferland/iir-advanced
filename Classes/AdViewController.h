//
//  IJAdViewController.h
//  InsuranceJournal
//
//  Created by Curtis Duhn on 7/29/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"
#import "DTImageViewDelegate.h"

#define AD_HEIGHT 49.0

@interface AdViewController : UIViewController <DTAsyncQueryDelegate, UIWebViewDelegate, UIAlertViewDelegate, DTImageViewDelegate> {
   IBOutlet UIWebView *adWebView;
   IBOutlet UIView *adWebViewHolder;
   IBOutlet UIActivityIndicatorView *adLoadingActivity;
   DTXMLRPCQuery *query;
   NSString *source;
   DTImageView *imageView;
   CGFloat adHeight;
   NSURLConnection *adLoggingConnection;
   BOOL loadViewFromBottom;
}

@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) IBOutlet DTImageView *imageView;
@property (assign) BOOL loadViewFromBottom;

- (IBAction)handleAdClick;
- (IBAction)closeAd: (id) button;


- (void)attachUnderView:(UIView *)anchorView animated: (BOOL) animated;
- (void)detachFromUnderView:(UIView *)anchorView;
- (void)loadAd;
- (void)logAdImpression;

@end
