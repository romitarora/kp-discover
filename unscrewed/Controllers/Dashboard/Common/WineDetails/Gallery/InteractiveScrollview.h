//
//  USInteractiveScrollview.h
//
//  Created by Sourabh Bhardwaj on 21/02/14.
//  Copyright (c) 2013 AddValSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface InteractiveScrollview : UIScrollView<UIScrollViewDelegate>
{
    UITapGestureRecognizer *singleTapGesture;
    UITapGestureRecognizer *doubleTapGesture;
}

- (void)addImageView:(UIImageView *)imageView;
- (void)handleDoubleTapGesture:(id)sender;

@property(nonatomic,strong)UIImageView *imgVw;

@end
