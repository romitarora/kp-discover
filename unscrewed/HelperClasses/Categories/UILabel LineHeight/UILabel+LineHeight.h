//
//  UILabel+LineHeight.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 09/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LineHeight)

@property (nonatomic) CGFloat lineHeight;

- (void)resetTextOfAttributedText:(NSString *)text;

@end
