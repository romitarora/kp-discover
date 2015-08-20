//
//  WineDealSelectionViewController.h
//  unscrewed-ios
//
//  Created by Gary Earle on 8/13/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

@interface USWineSearchFirstFilterTVC : UIViewController

@property (weak, nonatomic) IBOutlet RadioButton *storesRadioButton;
@property (weak, nonatomic) IBOutlet RadioButton *restaurantsRadioButton;
@property (weak, nonatomic) IBOutlet RadioButton *onlineRadioButton;

@property (nonatomic) NSString *placesSearchButtonSelected;

@end
