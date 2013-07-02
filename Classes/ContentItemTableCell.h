//
//  ContentItemTableCell.h
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 4/30/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


#define CELL_WIDTH 320.0
#define BUTTON_WIDTH 67.0
#define BUTTON_HEIGHT 56.0
#define BUTTON_PADDING 10.0
#define CELL_PADDING 6.0

#define TOP_BOTTOM_PADDING 10.0

#define NAME_Y (TOP_BOTTOM_PADDING)
#define COMPOSER_FONT_SIZE 12.0
#define COMPOSER_HEIGHT (COMPOSER_FONT_SIZE * 2.0 + 5.0)
#define PERFORMER_HEIGHT (COMPOSER_FONT_SIZE * 2.0 + 5.0)
#define PERFORMER_Y (COMPOSER_Y + COMPOSER_HEIGHT + LABEL_SPACING)
#define DEFAULT_DESCRIPTION_HEIGHT 60.0
#define PLAY_BUTTON_X (CELL_WIDTH - BUTTON_PADDING - BUTTON_WIDTH - CELL_PADDING)
#define PLAY_BUTTON_Y (TOP_BOTTOM_PADDING + BUTTON_PADDING)

#define LABEL_WIDTH (PLAY_BUTTON_X - BUTTON_PADDING)

#define INFO_BUTTON_X CELL_PADDING
#define INFO_BUTTON_Y (PERFORMER_Y + PERFORMER_HEIGHT + LABEL_SPACING)
#define INFO_BUTTON_HEIGHT 30.0
#define INFO_BUTTON_WIDTH 80.0
#define DESCRIPTION_WIDTH (CELL_WIDTH - CELL_PADDING * 2)
#define DESCRIPTION_Y (INFO_BUTTON_Y + INFO_BUTTON_HEIGHT + LABEL_SPACING)
#define NAME_HEIGHT 40.0
#define LABEL_SPACING 3.0
#define MIN_HEIGHT (TOP_BOTTOM_PADDING*2 + BUTTON_PADDING*2 + BUTTON_HEIGHT)


@interface ContentItemTableCell : UITableViewCell <UIWebViewDelegate> {
   UILabel *nameLabel;
   UILabel *descriptionLabel;
   UILabel *composerLabel;
   UILabel *performerLabel;
   UIButton *playButton;
   UIButton *infoButton;
   NSString *infoURL;
   CGFloat rowHeight;
   UIActivityIndicatorView *webViewActivity;
}

@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UIButton *infoButton;
@property (nonatomic, retain) NSString *infoURL;
@property (nonatomic, retain) UIActivityIndicatorView *webViewActivity;

- (void) setNameText: (NSString *) text;
- (void) setComposerText: (NSString *) text;
- (void) setPerformerText: (NSString *) text;
- (void) setDescriptionText: (NSString *) text;

- (void) setYouTubeURL: (NSString *) urlString;


- (CGFloat) rowHeight;

@end
