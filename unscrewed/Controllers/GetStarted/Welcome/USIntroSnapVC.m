//
//  USIntroSnapVC.m
//  unscrewed
//
//  Created by Ray Venenoso on 7/16/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USIntroSnapVC.h"
#import "USIntroLatestVC.h"

@interface USIntroSnapVC ()

@end

@implementation USIntroSnapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation
- (IBAction)btnNextEventHandler:(UIButton *)sender {
    USIntroLatestVC *nextVC = [[USIntroLatestVC alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
