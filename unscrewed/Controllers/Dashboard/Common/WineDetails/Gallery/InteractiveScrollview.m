//
//  USInteractiveScrollview.m
//
//  Created by Sourabh Bhardwaj on 21/02/14.
//  Copyright (c) 2013 AddValSolutions. All rights reserved.
//

#import "InteractiveScrollview.h"

@implementation InteractiveScrollview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        self.zoomScale = 1.0;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 4.0f;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        
        self.backgroundColor = [UIColor whiteColor];
        
        //add gesture
        if(!doubleTapGesture)
        {
            doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
            doubleTapGesture.cancelsTouchesInView = NO; 
            doubleTapGesture.delaysTouchesEnded = NO;
            doubleTapGesture.numberOfTouchesRequired = 1; // One finger double tap
            doubleTapGesture.numberOfTapsRequired = 2;   
        }

        [self addGestureRecognizer:doubleTapGesture];
    }
    return self;
}


-(void)addImageView:(UIImageView *)imageView
{
    _imgVw = imageView;
    _imgVw.userInteractionEnabled=YES;
    [self addSubview:_imgVw];
}

#pragma mark handleDoubleTap
-(void)handleDoubleTapGesture:(id)sender
{
    if(self.zoomScale == 1.0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.50];
        self.zoomScale = 3.0f;
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.50];
        self.zoomScale = 1.0f;
        [UIView commitAnimations];
    }
}


#pragma mark ScrollView Delegates
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imgVw;
}

@end
