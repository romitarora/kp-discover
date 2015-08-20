//
//  USIntroRateVC.m
//  unscrewed
//
//  Created by Ray Venenoso on 7/16/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USIntroRateVC.h"
#import "USIntroSnapVC.h"

@interface USIntroRateVC ()

@end

@implementation USIntroRateVC

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
    USIntroSnapVC *nextVC = [[USIntroSnapVC alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
