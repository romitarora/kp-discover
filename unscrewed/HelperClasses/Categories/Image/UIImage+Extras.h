//
//  UIImage+Extras.h
//  Unscrewed
//
//  Created by Sourabh B. on 23/09/14.
//  Copyright (c) 2014 Addval Solutions. All rights reserved.
//

@interface UIImage (Extras)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)crop:(CGRect)rect;

@end