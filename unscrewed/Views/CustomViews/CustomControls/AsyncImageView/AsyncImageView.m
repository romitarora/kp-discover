//
//  UIImageView+Network.m
//
//  Created by Soroush Khanlou on 8/25/12.
//
//

#import "AsyncImageView.h"
#import "NSString+MD5.h"
#import "UIImage+Extras.h"
#import "FTWCache.h"

@interface AsyncImageView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, copy) NSURL *imgUrl;

@end

@implementation AsyncImageView

@synthesize activityView = _activityView;

- (void)setUp {
    if (_activityView == nil)
    {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.hidesWhenStopped = YES;
        _activityView.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
        _activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_activityView];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)getImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
	[self getImageFromURL:url placeholderImage:placeholder scaling:1];
}

- (void)getImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholder scaling:(int)scaling {
	NSString *key = [[url absoluteString] stringByAppendingString:NSStringFromCGSize(self.frame.size)];
	[self getImageFromURL:url placeholderImage:placeholder cachingKey:key scaling:scaling];
}

- (void) getImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder cachingKey:(NSString*)key scaling:(int) scaling {
	self.imgUrl = url;
	
	NSString *cacheKey = [key MD5Hash];
	NSData *cachedData = [FTWCache objectForKey:cacheKey];
	if (cachedData) {
		DLog(@"cached image");
		self.imgUrl = nil;
        self.image = [UIImage imageWithData:cachedData];
	} else {
		self.image = placeholder;
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
		dispatch_async(queue, ^{
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *imageFromData = [UIImage imageWithData:data];
			// get resized image
			CGFloat scaleFactor = scaling * [UIScreen mainScreen].scale;
			CGSize size = CGSizeMake(CGRectGetWidth(self.frame) * scaleFactor, CGRectGetHeight(self.frame) *scaleFactor);
            UIImage *resizedImage = [imageFromData imageByScalingAndCroppingForSize: size];
			NSData *resizedImageData = UIImagePNGRepresentation(resizedImage);
			[FTWCache setObject:resizedImageData forKey:cacheKey];
			dispatch_sync(dispatch_get_main_queue(), ^{
				if (imageFromData) {
					if ([self.imgUrl.absoluteString isEqualToString:url.absoluteString]) {
						self.image = resizedImage;
					} else {
						//NSLog(@"urls are not the same, bailing out!");
					}
				}
			});
		});
	}
}


- (void) getImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder cachingKey:(NSString*)key {
	self.imgUrl = url;
	
	NSString *cacheKey = [key MD5Hash];
	NSData *cachedData = [FTWCache objectForKey:cacheKey];
	if (cachedData) {
		DLog(@"cached image");
		self.imgUrl   = nil;
		self.image      = [UIImage imageWithData:cachedData];
	} else {
		//[self.activityView startAnimating];
		self.image = placeholder;
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
		dispatch_async(queue, ^{
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *imageFromData = [UIImage imageWithData:data];
			// get resized image
			UIImage *resizedImage = [imageFromData imageByScalingAndCroppingForSize:self.frame.size];
			NSData *resizedImageData = UIImagePNGRepresentation(resizedImage);
			[FTWCache setObject:resizedImageData forKey:cacheKey];
			dispatch_sync(dispatch_get_main_queue(), ^{
				if (imageFromData) {
					if ([self.imgUrl.absoluteString isEqualToString:url.absoluteString]) {
						self.image = resizedImage;
					} else {
						//NSLog(@"urls are not the same, bailing out!");
					}
				}
				//[self.activityView stopAnimating];
			});
		});
	}
}

@end

