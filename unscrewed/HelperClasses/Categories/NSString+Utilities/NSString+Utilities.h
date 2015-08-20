//
//  NSString+Utilities.h
//  MyDoc-Patient
//
//  Created by Robin on 7/31/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)

- (NSString *)trim;

- (BOOL)isValidEmail;
- (BOOL)isValidPhoneNumber;

- (CGRect)rectWithSize:(CGSize)size font:(UIFont *)font;

@end
