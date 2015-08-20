//
//  USMessageVC.m
//  unscrewed
//
//  Created by Robin Garg on 04/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USMessageVC.h"

@interface USMessageVC ()

@end

@implementation USMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	if (self.showInfoAbout == ShowInformationForAboutUs) {
		self.navigationItem.title = @"About Us";
	} else {
		self.navigationItem.title = @"Terms & Privacy";
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
