//
//  USCongratsVC.m
//  unscrewed
//
//  Created by Mario Danic on 10/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USCongratsVC.h"

@implementation USCongratsVC

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSString *textToColor =
    @"Wherever you are, we suggest the best wines for your $$, based on your tastes, expert scores, user reviews and price comparisons";

  const CGFloat fontSize = 17;

  UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
  UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
  UIColor *foregroundColor =
    [UIColor colorWithRed:234.0 / 255.0 green:102.0 / 255.0 blue:108.0 /
     255.0          alpha:1.0];

  NSDictionary *attrs =
    [NSDictionary dictionaryWithObjectsAndKeys:boldFont, NSFontAttributeName,
     foregroundColor, NSForegroundColorAttributeName, nil];
  NSDictionary *subAttrs =
    [NSDictionary dictionaryWithObjectsAndKeys:regularFont, NSFontAttributeName,
     nil];

  const NSRange range = NSMakeRange(32, 23);

  NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:textToColor attributes:
     subAttrs];
  [attributedText setAttributes:attrs range:range];

  [_mainTextLabel setAttributedText:attributedText];
}

@end
