//
//  USWineVC.m
//  unscrewed
//
//  Created by Gary Earle on 10/9/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USWineVC.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface USWineVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *wineScrollView;

@end

@implementation USWineVC

- (void)doNetworkRequest:(NSDictionary *)arguments
{

  NSURL *baseURL =
    [NSURL URLWithString:[
       @"http://unscrewed-api-staging-2.herokuapp.com/api/wines/"
 stringByAppendingString: self.wineId]];

  AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];

  manager.responseSerializer = [AFJSONResponseSerializer serializer];

  NSLog(@"USWineVC::doNetworkRequest with arguments: %@", arguments);

  [manager GET:[baseURL absoluteString]
    parameters:arguments
       success:^(NSURLSessionDataTask *task, id responseObject) {

    [self buildScrollViewWithWineData:(NSDictionary *)responseObject];

  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:
       @"Error while attempting to retrieve wine details"
                                 message:[error
                                          localizedDescription
       ]
                                delegate:nil
                       cancelButtonTitle:@"Ok"
                       otherButtonTitles:nil];
    [alertView show];

  }];
}


- (void)buildScrollViewWithWineData:(NSDictionary *)wineData
{

  self.wineScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
  self.wineScrollView.contentSize = CGSizeMake(320, 4000);
  [self.view addSubview:self.wineScrollView];

  UIImageView *wineImageView =
    [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 320)];
  wineImageView.image = self.wineImage;
  [self.wineScrollView addSubview:wineImageView];

  UILabel *wineNameLabel =
    [[UILabel alloc] initWithFrame:CGRectMake(10, 390, 280, 42)];
  wineNameLabel.numberOfLines = 0;
  wineNameLabel.text =
    [[[[wineData objectForKey:@"wine"] objectForKey:@"name"]
      stringByAppendingString
      :@" "] stringByAppendingString:[[wineData objectForKey:@"wine"]
                                      objectForKey:
                                      @"year"]];
  [self.wineScrollView addSubview:wineNameLabel];


}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
  [self doNetworkRequest:arguments];

}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.

}


@end
