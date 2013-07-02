//
//  MusicalTermTableCell.h
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 4/29/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MusicalTermTableCell : UITableViewCell {
   UILabel *termLabel;
   UILabel *descriptionLabel;
   UIImageView *imageView;
}

@property (nonatomic, assign) NSString *termText;
@property (nonatomic, assign) NSString *descriptionText;
@property (nonatomic, assign) NSString *imageName;

- (id) initWithReuseIdentifier: (NSString *) identifier;
- (CGFloat) rowHeight;

@end
