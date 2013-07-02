//
//  MusicalTermTableCell.m
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 4/29/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "MusicalTermTableCell.h"

#define CELL_IMAGE_HEIGHT (50.0)
#define CELL_IMAGE_WIDTH (30.0)

#define CELL_WIDTH 280.0
#define MIN_CELL_HEIGHT 80.0

#define TERM_LABEL_HEIGHT 20.0
#define LABEL_PADDING 5.0

#define LABEL_X 55.0

@implementation MusicalTermTableCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
   if (self = [super initWithStyle: UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
       termLabel = [[UILabel alloc] initWithFrame: CGRectMake( LABEL_X, 0, CELL_WIDTH - LABEL_X, TERM_LABEL_HEIGHT)];
       termLabel.font = [UIFont fontWithName:@"Georgia" size:16];
       termLabel.textColor = [UIColor redColor];
       termLabel.textAlignment = UITextAlignmentLeft;
       
       [self.contentView addSubview: termLabel];	

       descriptionLabel = [[UILabel alloc] initWithFrame: CGRectMake(LABEL_X, TERM_LABEL_HEIGHT + LABEL_PADDING, CELL_WIDTH - LABEL_X, 58)];
       descriptionLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:12];
       descriptionLabel.textAlignment = UITextAlignmentLeft;
       descriptionLabel.numberOfLines = 4;

       [self.contentView addSubview: descriptionLabel];	

       imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CELL_IMAGE_HEIGHT, CELL_IMAGE_WIDTH)];
       [self.contentView addSubview:imageView];
    }
    return self;
}


- (void)dealloc {
   [termLabel release];
   [descriptionLabel release];
   [imageView release];
    [super dealloc];
}

- (NSString *) termText {
   return termLabel.text;
}

- (void) setTermText: (NSString *) text{
   termLabel.text = text;
}

- (NSString *) descriptionText {
   return descriptionLabel.text;
}

- (void) setDescriptionText: (NSString *) text{
   CGSize labelSize = CGSizeMake(230, 58);
	CGSize theStringSize = [text sizeWithFont: descriptionLabel.font 
                           constrainedToSize: labelSize 
                               lineBreakMode: descriptionLabel.lineBreakMode];
	descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y, theStringSize.width, theStringSize.height);
   descriptionLabel.text = text;
}

- (NSString *) imageName {
   return @"image";
}

- (void) setImageName: (NSString *) imageName {
   if (imageName && ![imageName isEqualToString: @""]) {
      imageView.image = [UIImage imageNamed:imageName];      
   } else {
      imageView.image = nil;
   }
	if (imageView.image) {
		imageView.image = [UIImage imageNamed:imageName];
      imageView.bounds = CGRectMake(0.0, 0.0, imageView.image.size.width, imageView.image.size.height);
      imageView.center = CGPointMake(CELL_IMAGE_HEIGHT/2, CELL_IMAGE_WIDTH/2);
	}
}

- (CGFloat) rowHeight {
   return MAX(imageView.frame.size.height + LABEL_PADDING * 2, descriptionLabel.frame.size.height + termLabel.frame.size.height + LABEL_PADDING * 2);
}


@end
