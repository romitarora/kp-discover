//
//  USGotItVC.m
//  unscrewed
//
//  Created by Mario Danic on 22/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USGotItVC.h"
@interface USGotItVC ()
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblMessage;
@property (nonatomic, weak) IBOutlet UIButton *btnNext;

- (IBAction)btnNextEventHandler:(UIButton *)sender;


@end

@implementation USGotItVC

- (void)viewDidLoad
{
    
    NSLog(@" GOT IT VC SHOWED");
  [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self setUI];
}
#pragma mark View Creation
- (void)setFontAndTextColor {
    // Set Font
    [self.lblName setFont:[USFont helloNameFont]];
    [self.lblMessage setFont:[USFont gotitMsgFont]];
    [self.btnNext.titleLabel setFont:[USFont defaultButtonFont]];
    // Set Text Color
    [self.lblName setTextColor:[USColor themeNormalTextColor]];
    [self.lblMessage setTextColor:[USColor themeNormalTextColor]];
    [self.btnNext setTitleColor:[USColor signInSectionNormalTextColor] forState:UIControlStateNormal];
    // Background Color
    [self.lblName setBackgroundColor:[USColor clearColor]];
    [self.lblMessage setBackgroundColor:[USColor clearColor]];
    [self.btnNext setBackgroundColor:[USColor themeSelectedColor]];
}

- (void)setUI {
    [self setFontAndTextColor];
    
    self.btnNext.layer.cornerRadius = 3.f;
    // Set Text
    [self.lblName setText:[NSString stringWithFormat:@"Got it!"]];
    [self.lblMessage setText:@"Remember we're only in LA and\nSeattle, and we're still testing, so please\nhang with us and let us know how we\ncan improve!"];
    [self.btnNext setTitle:@"Done" forState:UIControlStateNormal];
}

#pragma mark UIButton Event Handler
// Next Button Event Handler
- (IBAction)btnNextEventHandler:(UIButton *)sender {
    //[self navigateToPlacesViewController];
    
    // Open Dashboard
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:kAppDelegate.window cache:NO];
    [kAppDelegate.window setRootViewController:[kGlobalPref dashboard]];
    [UIView commitAnimations];
}

@end
