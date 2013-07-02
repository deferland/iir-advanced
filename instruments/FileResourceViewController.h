//
//  ACDocumentViewController.h
//  PortablePTO
//
//  Created by Christopher Garrett on 7/3/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileMenuItem.h"
#import "ACWebSearchHandler.h"
#import "AdBasedController.h"

@interface FileResourceViewController : AdBasedController <UIWebViewDelegate> {
	UIWebView *webView;
	NSURL *baseURL;
	
	BOOL searchable;
	ACWebSearchHandler *searchHandler;
	UISearchBar *searchBar;
	FileMenuItem *fileMenuItem;
}

@property (nonatomic, retain) FileMenuItem *fileMenuItem;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) ACWebSearchHandler *searchHandler;
@property (nonatomic, retain) NSURL *baseURL;

- (id) initWithFileMenuItem: (FileMenuItem *) fileMenuItem;

@end
