//
//  USGalleryViewController.h
//
//  Created by Sourabh Bhardwaj on 21/02/14.
//  Copyright (c) 2013 AddValSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractiveScrollview.h"

@interface USGalleryViewController : UIViewController<UIGestureRecognizerDelegate> {
    //full screen view
    IBOutlet UIScrollView *scrollviewFullScreen;
    IBOutlet UIButton *btnDone;
}

@property(nonatomic,strong)UIImage *image;

@end
