//
//  ContentItemTableCell.m
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 4/30/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "ContentItemTableCell.h"

#import "UIButton+LookAndFeel.h"

@implementation ContentItemTableCell

@synthesize playButton, infoButton, infoURL, webViewActivity;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
   if (self = [super initWithStyle: UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
       rowHeight = 40.0;
       
       nameLabel = [[UILabel alloc] initWithFrame: CGRectZero];
       nameLabel.numberOfLines = 2;
       nameLabel.lineBreakMode = UILineBreakModeWordWrap;
       nameLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:12];
       nameLabel.textColor = [UIColor blackColor];
       nameLabel.backgroundColor = [UIColor clearColor];
       nameLabel.textAlignment = UITextAlignmentLeft;
       [self.contentView addSubview:nameLabel];	
       
       // composer cell
       composerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
       composerLabel.numberOfLines = 2;
       composerLabel.font = [UIFont fontWithName:@"TrebuchetMS-Italic" size: COMPOSER_FONT_SIZE];
       composerLabel.textColor = [UIColor blackColor];
       composerLabel.backgroundColor = [UIColor clearColor];
       composerLabel.textAlignment = UITextAlignmentLeft;
       composerLabel.adjustsFontSizeToFitWidth = NO;
       composerLabel.lineBreakMode = UILineBreakModeWordWrap;
       [self.contentView addSubview: composerLabel];	
       
       // performer label
       performerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
       performerLabel.numberOfLines = 2;
       performerLabel.font = [UIFont fontWithName:@"TrebuchetMS-Italic" size: COMPOSER_FONT_SIZE];
       performerLabel.textColor = [UIColor blackColor];
       performerLabel.backgroundColor = [UIColor clearColor];
       performerLabel.textAlignment = UITextAlignmentLeft;
       performerLabel.adjustsFontSizeToFitWidth = NO;
       performerLabel.lineBreakMode = UILineBreakModeWordWrap;
       [self.contentView addSubview: performerLabel];	
       
       // description cell
       descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
       descriptionLabel.numberOfLines = 3;
       descriptionLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:12];
       descriptionLabel.textColor = [UIColor blackColor];
       descriptionLabel.backgroundColor = [UIColor clearColor];
       descriptionLabel.textAlignment = UITextAlignmentLeft;
       [self.contentView addSubview: descriptionLabel];	
       
       self.playButton = [UIButton playButtonWithTitle: @"Play"]; 
       [self.contentView addSubview:playButton];	     
       
       self.infoButton = [UIButton playButtonWithTitle: @"Get Music"]; 
       [self.contentView addSubview: infoButton];	     
       
       [self setNameText: @""];
       [self setComposerText: @""];
       [self setPerformerText: @""];
       [self setDescriptionText: @""];
    }

   self.infoURL = @"";

   return self;
}

- (void) setYouTubeURL: (NSString *) urlString {
   self.playButton.hidden = YES;
   CGRect frame = CGRectMake(PLAY_BUTTON_X, PLAY_BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT);
   UIWebView *webView = [[[UIWebView alloc] initWithFrame: frame] autorelease];
   self.webViewActivity = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray] autorelease];
   self.webViewActivity.center = webView.center;
   [self.webViewActivity startAnimating];
   webView.delegate = self;
   [self.contentView addSubview: webView];
   [self.contentView addSubview: self.webViewActivity];
   NSString* embedHTML = @"\
   <html><head>\
   <style type=\"text/css\">\
   body {\
   background-color: transparent;\
   color: white;\
   }\
   </style>\
   </head><body style=\"margin:0\">\
   <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
   width=\"%0.0f\" height=\"%0.0f\"></embed>\
   </body></html>";  
   NSString* html = [NSString stringWithFormat:embedHTML, urlString, frame.size.width, frame.size.height];  
   [webView loadHTMLString:html baseURL:nil];  
}

#pragma mark UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   [self.webViewActivity stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
   //[self.activityIndicator stopAnimating];
}

#pragma mark Property support

- (void) setNameText: (NSString *) text {
   nameLabel.text = text;
}
- (void) setComposerText: (NSString *) text {
   if (text && [text length] > 0) 
   {
      composerLabel.text = [NSString stringWithFormat: @"Composer: %@", text];   
   } else {
      composerLabel.text = @"";
   }
   [self setNeedsLayout];
}
- (void) setPerformerText: (NSString *) text {
   if (text && [text length] > 0) {
      performerLabel.text = [NSString stringWithFormat: @"Performer: %@", text];      
   } else {
      performerLabel.text = @"";
   }
   [self setNeedsLayout];
}

- (void) setDescriptionText: (NSString *)description {
	descriptionLabel.text = description;
   [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat) rowHeight {
   [self layoutSubviews];
   return rowHeight;
}

- (void) layoutSubviews {
   CGFloat y = TOP_BOTTOM_PADDING;
   nameLabel.frame = CGRectMake(CELL_PADDING, y, LABEL_WIDTH, NAME_HEIGHT);
   y += NAME_HEIGHT; 
   if (composerLabel.text && [composerLabel.text length] > 0) {
      composerLabel.hidden = NO;
      composerLabel.frame = CGRectMake(CELL_PADDING, y + LABEL_SPACING, LABEL_WIDTH , COMPOSER_HEIGHT);      
      y += COMPOSER_HEIGHT + LABEL_SPACING;
   } else {
      composerLabel.hidden = YES;
   }
   if (performerLabel.text && [performerLabel.text length] > 0) {
      performerLabel.hidden = NO;
      performerLabel.frame = CGRectMake(CELL_PADDING, y + LABEL_SPACING, LABEL_WIDTH , PERFORMER_HEIGHT);
      y += PERFORMER_HEIGHT + LABEL_SPACING;
   } else {
      performerLabel.hidden = YES;
   }
   if (descriptionLabel.text && [descriptionLabel.text length] > 0) {
      descriptionLabel.hidden = NO;
      CGSize labelSize = CGSizeMake(DESCRIPTION_WIDTH, 60);
      CGSize theStringSize = [descriptionLabel.text sizeWithFont: descriptionLabel.font constrainedToSize:labelSize lineBreakMode: descriptionLabel.lineBreakMode];
      descriptionLabel.frame = CGRectMake(CELL_PADDING, y + LABEL_SPACING, theStringSize.width, theStringSize.height);
      y += LABEL_SPACING + theStringSize.height;
   } else {
      descriptionLabel.hidden = YES;
   }
   self.playButton.frame = CGRectMake(PLAY_BUTTON_X, PLAY_BUTTON_Y, BUTTON_WIDTH, BUTTON_HEIGHT);
   self.infoButton.frame = CGRectMake(CELL_PADDING, y + LABEL_SPACING, INFO_BUTTON_WIDTH, INFO_BUTTON_HEIGHT);
   y += TOP_BOTTOM_PADDING;
   if (self.infoButton.hidden) {
      rowHeight = MAX(y, MIN_HEIGHT);
   } else {
      rowHeight = MAX(y + INFO_BUTTON_HEIGHT + LABEL_SPACING, MIN_HEIGHT); 
   }
   self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, rowHeight);
   self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, rowHeight);
   
}

- (void) setInfoURL: (NSString *)info {
   [info retain];
   if (infoURL) [infoURL release];
   infoURL = info;
   if (info && [info length] > 0) {
      infoButton.hidden = NO;
   } else {
      infoButton.hidden = YES;
   }
   [self setNeedsLayout];
}


- (void)dealloc {
   [nameLabel release];
   [composerLabel release];
   [performerLabel release];
   [descriptionLabel release];
   self.webViewActivity = nil;
   self.playButton = nil;
   self.infoButton = nil;
   self.infoURL = nil;
   [super dealloc];
}


@end
