//
//  IJAdViewController.m
//  InsuranceJournal
//
//  Created by Curtis Duhn on 7/29/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "AdViewController.h"
#import "desiccant.h"
#import "Instrument.h"
#import "AppDelegate.h"

@interface AdViewController()
@property (nonatomic, retain) DTXMLRPCQuery *query;
@property (nonatomic, retain) NSURLConnection *adLoggingConnection;
@end


@implementation AdViewController
@synthesize source, query, imageView, adLoggingConnection, loadViewFromBottom;

- (void)dealloc {
    self.source = nil;
    self.query = nil;
    self.imageView = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view = self.view;  // Force loading
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
   [super viewDidLoad];
   adHeight = self.view.bounds.size.height;
   adWebViewHolder.frame = CGRectMake(0.0, 480.0, 320.0, 480.0);
}



- (void)attachUnderView:(UIView *)anchorView animated: (BOOL) animated {
   if (anchorView.superview != self.view.superview) {
      CGRect startAdFrame = self.view.bounds;
      startAdFrame.size.height = adHeight;
      if (loadViewFromBottom) {
         startAdFrame.origin.x = anchorView.frame.origin.x + (anchorView.frame.size.width - startAdFrame.size.width) / 2;
         startAdFrame.origin.y = anchorView.frame.origin.y + anchorView.frame.size.height;      
      } else {
         startAdFrame.origin.x = 0;
         startAdFrame.origin.y = -self.view.bounds.size.height;
      }
      self.view.frame = startAdFrame;
      self.view.alpha = 0.0;
      
      if (animated) {
         [UIView beginAnimations:nil context:anchorView];
         [UIView setAnimationDuration:0.4];
         [UIView setAnimationDidStopSelector:@selector(adShowAnimationDidStop:finished:context:)];
         [UIView setAnimationDelegate:self];         
      }
      
      CGRect newAdFrame = self.view.bounds;
      CGRect newAnchorFrame = anchorView.frame;
      if (loadViewFromBottom) {
         newAdFrame.origin.x = anchorView.frame.origin.x + (anchorView.frame.size.width - newAdFrame.size.width) / 2;
         newAdFrame.origin.y = anchorView.frame.origin.y + anchorView.frame.size.height - newAdFrame.size.height;      
      } else {
         newAdFrame.origin.x = 0.0;
         newAdFrame.origin.y = 0.0;
         newAnchorFrame = CGRectMake(newAnchorFrame.origin.x, 
                                       newAnchorFrame.origin.y + newAdFrame.size.height, 
                                       newAnchorFrame.size.width, 
                                       newAnchorFrame.size.height - newAdFrame.size.height);
      }
      self.view.frame = newAdFrame;
      anchorView.frame = newAnchorFrame;
      [anchorView.superview addSubview:self.view];
      [anchorView.superview bringSubviewToFront:self.view];
      self.view.alpha = 1.0;
      if (animated) {
         [UIView commitAnimations];                     
      }
   }
}

- (void)adShowAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    UIView *anchorView = (UIView *)context;
    CGRect newAnchorFrame = anchorView.frame;
    newAnchorFrame.size.height = anchorView.frame.size.height - self.view.bounds.size.height;      
    anchorView.frame = newAnchorFrame;
}

- (void)detachFromUnderView:(UIView *)anchorView {
    // For some reason, the add gets resized to full height before we get here, so I'm resetting it.
    CGRect adFrame = self.view.frame;
    adFrame.size.height = adHeight;
    self.view.frame = adFrame;
   [self.view removeFromSuperview];
    
    CGRect newAnchorFrame = anchorView.frame;
    newAnchorFrame.size.height = anchorView.frame.size.height + adHeight;
   if (loadViewFromBottom) {
      // ignored for now
   } else {
      newAnchorFrame = CGRectMake(newAnchorFrame.origin.x, 
                                    newAnchorFrame.origin.y - adFrame.size.height, 
                                    newAnchorFrame.size.width, 
                                    newAnchorFrame.size.height + adFrame.size.height);
   }
    anchorView.frame = newAnchorFrame;
}

- (void)loadAd {
    if (!self.source) self.source = @"";    
    self.query = [DTXMLRPCQuery queryWithURL:[NSURL URLWithString:@"http://www.instrumentsinreach.com/openx/www/delivery/axmlrpc.php"] 
                                    delegate:self 
                                  methodName:@"openads.view" 
                                      params:[NSArray arrayWithObjects:
                                              [NSDictionary dictionaryWithObjectsAndKeys:@"0.0.0.0", @"remote_addr", [NSArray array], @"cookies", nil], 
                                              [[Instrument currentInstrument] adZone],
                                              [NSNumber numberWithInt:0], 
                                              @"", 
                                              self.source, 
                                              [NSNumber numberWithBool:NO], 
                                              [NSArray array], 
                                            nil]];
    [query refresh];
}

- (void)queryWillStartLoading:(DTAsyncQuery *)theQuery {
}

- (void)queryDidFailLoading:(DTAsyncQuery *)theQuery {
    NSLog(@"Ad query failed loading with error: %@", theQuery.error);   
}

- (void)queryDidFinishLoading:(DTAsyncQuery *)theQuery {
    if (!query.faultCode) {
       NSString *urlString = [query.dictionaryResponse stringForKey:@"bannerContent"];
       if (urlString) {
          [imageView loadFromURL: urlString.to_url];          
       } else {
          NSLog(@"Invalid query response.  Dictionary contents:");
          NSLog(@"%@", query.dictionaryResponse);
       }
    }
    else {
        NSLog(@"*** XML-RPC Fault: \"%@\"", query.faultString);
    }
}

- (void)logAdImpression {
    NSURL *url = [query.dictionaryResponse stringForKey:@"logUrl"].to_url;
    if (url) {
        NSMutableURLRequest *logUrlRequest = [NSMutableURLRequest requestWithURL:url];
        if (logUrlRequest) {
            [logUrlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
            self.adLoggingConnection = [NSURLConnection connectionWithRequest:logUrlRequest delegate:nil];
        }
        else {
            NSLog(@"Failed to create logUrl request object.");
        }
    }
    else {
        NSLog(@"Didn't get a logUrl in the response from the ad server.");
    }
}

- (IBAction)handleAdClick {
    NSURL *url = [query.dictionaryResponse stringForKey:@"clickUrl"].to_url;
    if (url) {
       [adLoadingActivity startAnimating];
      adWebViewHolder.frame = CGRectMake(0.0, 480.0, 320.0, 480.0);
       UIWindow *mainWindow = [[AppDelegate sharedAppDelegate] window];
       [mainWindow addSubview: adWebViewHolder];
      [UIView beginAnimations: @"AdShow"  context: nil];
      [adWebView loadRequest: [NSURLRequest requestWithURL: url]];
      adWebViewHolder.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
      [UIView commitAnimations];
    }    
}

- (void) closeAd: (id) source {
   [adWebViewHolder removeFromSuperview];
   UIWindow *mainWindow = [[AppDelegate sharedAppDelegate] window];
   [mainWindow addSubview: adWebViewHolder];
   [UIView beginAnimations: @"AdHide" context: nil];
   adWebViewHolder.frame = CGRectMake(0.0, 480.0, 320.0, 480.0);
   [UIView   commitAnimations];
}

#pragma mark DTImageViewDelegate methods

- (void)imageView:(DTImageView *)imageView didFailLoadingWithError:(NSError *)error {
   
}
- (void)imageViewDidFinishLoading:(DTImageView *)theImageView {
   imageView.center = CGPointMake(imageView.center.x, imageView.center.y + imageView.frame.size.height);
   [UIView beginAnimations: @"imageView" context: nil];
   imageView.center = CGPointMake(imageView.center.x, imageView.center.y - imageView.frame.size.height);   
   [UIView commitAnimations];
}


#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
   [self closeAd: self];
}

#pragma mark UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   if ([[[request URL] absoluteString] contains: @"instrumentsinreach"]) {
      return YES;
   } else {
      [[UIApplication sharedApplication] openURL: [request URL]];
      return NO;
   }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   [adLoadingActivity stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
   [adLoadingActivity stopAnimating];
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Unable to Load Ad" 
                              message: [error localizedDescription] 
                             delegate: self 
                    cancelButtonTitle: @"Ok" 
                    otherButtonTitles: nil];
   [alert show];
   [alert release];
}

@end
