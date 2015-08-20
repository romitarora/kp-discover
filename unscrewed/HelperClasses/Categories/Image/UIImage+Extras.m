//
//  UIImage+Extras.h
//  Unscrewed
//
//  Created by Sourabh B. on 23/09/14.
//  Copyright (c) 2014 Addval Solutions. All rights reserved.
//

#import "UIImage+Extras.h"

@implementation UIImage (Extras)

#pragma mark -
#pragma mark Scale and crop image

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    CGSize originalImgSize = self.size;
    if (fmaxf(originalImgSize.height, originalImgSize.width) <= fminf(targetSize.height, targetSize.width)) {
        return self;
    }
    @autoreleasepool {
        UIImage *sourceImage = self;
        UIImage *newImage = nil;
        CGSize imageSize = sourceImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGFloat targetWidth = targetSize.width;
        CGFloat targetHeight = targetSize.height;
        CGFloat scaleFactor = 0.0;
        CGFloat scaledWidth = targetWidth;
        CGFloat scaledHeight = targetHeight;

        if (CGSizeEqualToSize(imageSize, targetSize) == NO)
        {
            CGFloat widthFactor = targetWidth / width;
            CGFloat heightFactor = targetHeight / height;

            if (widthFactor < heightFactor)
                scaleFactor = widthFactor; // scale to fit height
            else
                scaleFactor = heightFactor; // scale to fit width
            scaledWidth  = width * scaleFactor;
            scaledHeight = height * scaleFactor;
        }

		UIGraphicsBeginImageContextWithOptions(CGSizeMake(scaledWidth, scaledHeight), NO, self.scale);
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.size.width  = scaledWidth;
        thumbnailRect.size.height = scaledHeight;

        [sourceImage drawInRect:thumbnailRect];

        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if(newImage == nil)
            DLog(@"could not scale image");

        //pop the context to get back to the default
        UIGraphicsEndImageContext();
        return newImage;
    }
}

- (UIImage *)crop:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}

@end
