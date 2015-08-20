//
//  NSString+Utilities.m
//  MyDoc-Patient
//
//  Created by Robin on 7/31/14.
//
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isValidEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidPhoneNumber {
    NSCharacterSet *phoneNumberCharSet = [NSCharacterSet characterSetWithCharactersInString:@" 0123456789-"];
    NSCharacterSet *stringCharSet = [NSCharacterSet characterSetWithCharactersInString:self];
    return [phoneNumberCharSet isSupersetOfSet:stringCharSet];
}

- (CGRect)rectWithSize:(CGSize)size font:(UIFont *)font {
	return [self boundingRectWithSize:size
							  options:NSStringDrawingUsesLineFragmentOrigin
						   attributes:@{NSFontAttributeName:font}
							  context:nil];
}

@end
