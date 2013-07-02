//
//  UIButton+LookAndFeel.m
//  instruments-in-reach-v2
//
//  Created by Christopher Garrett on 4/29/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "UIButton+LookAndFeel.h"
#import "UIFont+LookAndFeel.h"

@implementation UIButton (LookAndFeel)

+ (UIButton *) playButtonWithTitle: (NSString *)title {
   UIImage *buttonBackgroundImage = [[UIImage imageNamed: @"black_button_background.png"] stretchableImageWithLeftCapWidth: 8 topCapHeight: 8];
   UIButton *myButton = [UIButton buttonWithType: UIButtonTypeRoundedRect]; 
   [myButton setBackgroundImage: buttonBackgroundImage forState: UIControlStateNormal];
   myButton.titleLabel.font = [UIFont buttonFont];
   [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   [myButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
   [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
   [myButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
   myButton.backgroundColor = [UIColor clearColor];
   myButton.adjustsImageWhenHighlighted = YES;    
   [myButton setTitle: title forState:UIControlStateNormal];
   return myButton;
}

+ (UIButton *) linkButtonWithTitle: (NSString *)title {
   UIButton *myButton = [UIButton buttonWithType: UIButtonTypeCustom]; 
   myButton.titleLabel.font = [UIFont fontWithName: @"Trebuchet MS" size: 12];
   [myButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
   myButton.backgroundColor = [UIColor clearColor];
   [myButton setTitle: title forState:UIControlStateNormal];
   return myButton;
}

   
@end
