//
//  MyNavigationController.m
//  unscrewed
//
//  Created by Robin Garg on 13/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
	CGRect rectNavBar = self.navigationBar.frame;
	rectNavBar.size.width = CGRectGetWidth([[UIApplication sharedApplication] keyWindow].frame) - kTransparentAreaWidth;
	self.navigationBar.frame = rectNavBar;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
