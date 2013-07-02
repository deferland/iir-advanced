//
//  ContentItemTableCellForAudioPlaylist.h
//  instruments-in-reach-v2
//
//  Created by Denis Butyletskiy on 23.11.09.
//  Copyright 2009 Bootman Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ContentItemTableCellForAudioPlaylist : UITableViewCell {
	UILabel *nameLabel;
	UILabel *descriptionLabel;
	UILabel *composerLabel;
	UILabel *performerLabel;
	UIButton *playButton;
	UIButton *infoButton;
	NSString *infoURL;
	CGFloat rowHeight;
}

@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UIButton *infoButton;
@property (nonatomic, retain) NSString *infoURL;

- (void) setNameText: (NSString *) text;
- (void) setComposerText: (NSString *) text;
- (void) setPerformerText: (NSString *) text;
- (void) setDescriptionText: (NSString *) text;

- (CGFloat) rowHeight;

@end
