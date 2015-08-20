//
//  USHelloVC.m
//  unscrewed
//
//  Created by Mario Danic on 08/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USHelloVC.h"
#import "USPlacesVC.h"

@interface USHelloVC ()

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblMessage;
@property (nonatomic, weak) IBOutlet UIButton *btnNext;

- (IBAction)btnNextEventHandler:(UIButton *)sender;

@end

@implementation USHelloVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setUI];
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark View Creation
- (void)setFontAndTextColor {
    // Set Font
    //[self.lblName setFont:[USFont helloNameFont]];
    //[self.lblMessage setFont:[USFont helloMsgFont]];
    //[self.btnNext.titleLabel setFont:[USFont defaultButtonFont]];
    // Set Text Color
    //[self.lblName setTextColor:[USColor themeNormalTextColor]];
    //[self.lblMessage setTextColor:[USColor themeNormalTextColor]];
    //[self.btnNext setTitleColor:[USColor signInSectionNormalTextColor] forState:UIControlStateNormal];
    // Background Color
    //[self.lblName setBackgroundColor:[USColor clearColor]];
    //[self.lblMessage setBackgroundColor:[USColor clearColor]];
    //[self.btnNext setBackgroundColor:[USColor themeSelectedColor]];
}

- (void)setUI {
    [self setFontAndTextColor];
    
    //self.btnNext.layer.cornerRadius = 3.f;
    // Set Text
    [self.lblName setText:[NSString stringWithFormat:@"Hi, %@!",self.name]];
    [self.lblMessage setText:@"Just a couple of questions so we can\ntrack the right wines for you"];
    //[self.btnNext setTitle:@"Next" forState:UIControlStateNormal];
}

#pragma mark Navigation
- (void)navigateToPlacesViewController {
    NSLog(@" GO TO PLACES");
    USPlacesVC *objPlacesVC = [[USPlacesVC alloc] init];
    
    [self.navigationController setViewControllers:@[objPlacesVC] animated:YES];
}

#pragma mark - $$ EVENT HANDLER $$
#pragma mark UIButton Event Handler
// Next Button Event Handler
- (IBAction)btnNextEventHandler:(UIButton *)sender {
    [self navigateToPlacesViewController];
}

@end
