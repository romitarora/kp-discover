//
//  UILabel+LineHeight.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 09/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "UILabel+LineHeight.h"

@implementation UILabel (LineHeight)

/**
 * Sets line height of UILabel through attributed text. Line break is assumed to be truncate tail.
 * Line height and line break are set together line break must be set after attributedString.
 * Important: must be called before appendToAttributedString, `setLineHeight:` replaces the attributedText.
 */
- (void)setLineHeight:(CGFloat)lineHeight {
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.minimumLineHeight = lineHeight;
    paragraphStyle.alignment = self.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:[NSString stringWithUTF8String:"\u200B"]
                                                   attributes:@{ NSParagraphStyleAttributeName : paragraphStyle }];
    self.attributedText = attributedString;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (CGFloat)lineHeight {
    NSAssert(NO, @"lineHeight getter not implemented");
    return 0.0;
}

- (void)resetTextOfAttributedText:(NSString *)text {
    if ([self.attributedText isKindOfClass:NSMutableAttributedString.class]) {
        self.attributedText = self.attributedText.mutableCopy;
    }
    [(NSMutableAttributedString *)self.attributedText
     replaceCharactersInRange:(NSRange){0, self.attributedText.length}
     withString:text];
}

@end
