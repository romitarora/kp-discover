//
//  USGalleryViewController.m
//
//  Created by Sourabh Bhardwaj on 21/02/14.
//  Copyright (c) 2013 AddValSolutions. All rights reserved.
//

#import "USGalleryViewController.h"

@interface USGalleryViewController () {
    BOOL isFullScreen;
    UITapGestureRecognizer *doubleTapGesture, *singleTapGesture;
}

/*
 create images for thumbnail and full screen view
 */
-(void)renderImages;

@end

@implementation USGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollviewFullScreen.backgroundColor = [UIColor clearColor];
    
    isFullScreen = NO;
    [self addGesturesToScrollView];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
     create image gallery
     */
    [self renderImages];
    self.navigationController.navigationBarHidden = YES;
    [scrollviewFullScreen bringSubviewToFront:btnDone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.hidesBottomBarWhenPushed = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Gestures
- (void)addGesturesToScrollView
{
    //single tap
    if(!singleTapGesture)
    {
        singleTapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        singleTapGesture.delegate=self;
    }
    [scrollviewFullScreen addGestureRecognizer:singleTapGesture];
}

//create images for thumbnail and full screen view
#pragma mark Images
- (void)renderImages {
    //remvoe previous subviews
    [self removePreviousViews];

    // for one image gallery
    if(_image) {
        CGRect rectFullScreen = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        // fullscreen
        UIImageView *imageFull = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [imageFull setImage:_image];
        imageFull.backgroundColor = [UIColor clearColor];
        imageFull.contentMode = UIViewContentModeScaleAspectFit;
        InteractiveScrollview *innerScrollViewFull = [[InteractiveScrollview alloc] initWithFrame:rectFullScreen];
        [innerScrollViewFull addImageView:imageFull];
        innerScrollViewFull.backgroundColor = [UIColor clearColor];
        [scrollviewFullScreen addSubview:innerScrollViewFull];
    }
    
    //set full screen scrollView content size
    [scrollviewFullScreen setContentSize:CGSizeMake(kScreenWidth + 1, 0)];

    // for multiple image gallery
    /*
     NSMutableArray *imageCollection = [[NSMutableArray alloc] initWithObjects:_message.payload, nil];
     DLog(@"%@",imageCollection);

    for(int i = 0; i < imageCollection.count; i++) {
        UIImage *img = [imageCollection objectAtIndex:i];
        
        CGRect rectFullScreen = CGRectMake((320 * i), 0, 320, screenHeight);
        
        // fullscreen
        UIImageView *imageFull = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, screenHeight)];
        [imageFull setImage:img];
        imageFull.backgroundColor = [UIColor clearColor];
        imageFull.contentMode = UIViewContentModeScaleAspectFit;
        InteractiveScrollview *innerScrollViewFull = [[InteractiveScrollview alloc] initWithFrame:rectFullScreen];
        [innerScrollViewFull addImageView:imageFull];
        innerScrollViewFull.backgroundColor = [UIColor clearColor];
        [scrollviewFullScreen addSubview:innerScrollViewFull];
    }
     
     //set full screen scrollView content size
     int size = (imageCollection.count * 320);
     [scrollviewFullScreen setContentSize:CGSizeMake((size > 320 ? size : 320+1), 0)];
     */
}

#pragma mark - Remove Previous SubViews
- (void)removePreviousViews {
    //full screenimages
    for(UIView *subView in scrollviewFullScreen.subviews)
        [subView removeFromSuperview];
}

#pragma mark - Handle Single Tap
- (void)singleTap:(id)sender {
    
    [self hideGalleryView];
/*
    if(isFullScreen) {
        isFullScreen = NO;
        [UIView animateWithDuration:0.50f animations:^{
            btnDone.alpha = 1.0;
        }];
    } else {
        isFullScreen = YES;
        [UIView animateWithDuration:0.50f animations:^{
            btnDone.alpha = 0.0;
        }];
    }
 */
}

- (IBAction)btnDone:(id)sender {
    [self hideGalleryView];
}

- (void)hideGalleryView {
    [UIView transitionWithView:kAppDelegate.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self dismissViewControllerAnimated:NO completion:nil];
                    }
                    completion:nil];
}

@end
