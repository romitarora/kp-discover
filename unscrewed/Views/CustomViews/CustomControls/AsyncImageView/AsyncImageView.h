//
//  UIImage+Network.h
//  Fireside
//
//  Created by Soroush Khanlou on 8/25/12.
//
//

#import <UIKit/UIKit.h>

@interface AsyncImageView : UIImageView

- (void)getImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)getImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholder scaling:(int)scaling;
- (void)getImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cachingKey:(NSString*)key;

@end

