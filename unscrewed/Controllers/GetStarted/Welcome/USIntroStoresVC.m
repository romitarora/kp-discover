//
//  USIntroStoresVC.m
//  unscrewed
//
//  Created by Ray Venenoso on 7/16/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USIntroStoresVC.h"
#import "USIntroFindVC.h"

@interface USIntroStoresVC ()

@end

@implementation USIntroStoresVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation
- (IBAction)btnNextEventHandler:(UIButton *)sender {
    USIntroFindVC *nextVC = [[USIntroFindVC alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
