//
//  USWebViewController.m
//  unscrewed
//
//  Created by Sourabh B. on 26/05/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USWebViewController.h"

@interface USWebViewController ()
{
    __weak IBOutlet UIWebView *webview;
}
@end

@implementation USWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(20,0,60,44)];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[USColor themeSelectedTextColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *_export = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    [[self navigationItem] setLeftBarButtonItem:_export];
    
    [webview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.storeUrl]]];
}

- (void)btnCancelClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[HelperFunctions sharedInstance] hideProgressIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[HelperFunctions sharedInstance] showProgressIndicatorWithUserInteractionDiabled:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [HelperFunctions showAlertWithTitle:kError message:@"Unable to load web page" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitle:nil];
}

@end
