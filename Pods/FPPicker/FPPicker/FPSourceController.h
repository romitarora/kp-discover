//
//  ServiceController.h
//  FPPicker
//
//  Created by Liyan David Chang on 6/20/12.
//  Copyright (c) 2012 Filepicker.io (Cloudtop Inc), All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FPPicker.h"
#import "FPInternalHeaders.h"

@interface FPSourceController : FPTableWithUploadButtonViewController

@property (nonatomic, strong) NSMutableArray *contents;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) FPSource *sourceType;
@property (nonatomic, strong) NSString *viewType;
@property (nonatomic, strong) NSString *nextPage;
@property (nonatomic, strong) UIActivityIndicatorView *nextPageSpinner;
@property (nonatomic, weak) id <FPSourcePickerDelegate> fpdelegate;

- (void)fpLoadContents:(NSString *)loadpath;
- (void)afterReload;

@end
