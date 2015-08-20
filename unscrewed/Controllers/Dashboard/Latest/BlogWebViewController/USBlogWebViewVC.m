//
//  USBlogWebViewVC.m
//  unscrewed
//
//  Created by Robin Garg on 03/07/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USBlogWebViewVC.h"
#import "USPost.h"

@interface USBlogWebViewVC ()<UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webViewBlog;

@end

@implementation USBlogWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = self.objPost.title;
    
    self.webViewBlog.delegate = self;
	[self.webViewBlog loadRequest:[NSURLRequest requestWithURL:self.objPost.blogUrl]];
    self.webViewBlog.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.webViewBlog.scrollView.contentOffset = CGPointMake(0, 200);
    self.webViewBlog.hidden = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	DLog(@"Request = %@",request);
	DLog(@"URL Scheme = %@",request.URL.scheme);
	return YES;
}

@end
