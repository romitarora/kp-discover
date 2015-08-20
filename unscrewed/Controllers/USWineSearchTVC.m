//
//  USWineSearchTVC.m
//  unscrewed
//
//  Created by Mario Danic on 05/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USWineSearchTVC.h"
#import "USWine.h"
#import "USWineSearchResultsCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "USWineDetailTVC.h"

@interface USWineSearchTVC ()
@property (nonatomic, strong) NSMutableArray *wineResults;
@property (nonatomic) NSInteger wineCount;
@end


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation USWineSearchTVC

- (void)viewDidLoad
{
  [super viewDidLoad];

  _wineCount = 0;
  _wineSearchBar = [[UISearchBar alloc] init];
  [_wineSearchBar sizeToFit];
  _wineSearchBar.delegate = self;
  _wineSearchBar.showsCancelButton = YES;

  _wineSearchController = [[UISearchDisplayController alloc]
                           initWithSearchBar:_wineSearchBar contentsController:
                           self];
  _wineSearchController.delegate = self;
  _wineSearchController.searchResultsDataSource = self;
  _wineSearchController.searchResultsDelegate = self;
  _wineSearchController.displaysSearchBarInNavigationBar = YES;

  [_wineSearchController.navigationItem setHidesBackButton:YES];
  [_wineSearchController setActive:YES animated:YES];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  if (_retailerSelected)
  {

    [self performSegueWithIdentifier:@"backToPlacesTwo" sender:self];
  } else {
    [self performSegueWithIdentifier:@"backToWineSearchOne" sender:self];
  }
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.wineTableView.userInteractionEnabled = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
  if ([touch.view isDescendantOfView:self.wineTableView] )
  {
    return NO;
  }

  return YES;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)
  section
{
  if (tableView == _wineSearchController.searchResultsTableView)
  {
    return [_wineResults count];
  } else {
    return 0;
  }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(
    NSIndexPath *)indexPath
{
  if (tableView == _wineSearchController.searchResultsTableView)
  {


    USWine *wine = [self.wineResults objectAtIndex:indexPath.row];

    return [self _configureCell:wine];
  }

  return nil;
}

- (UITableViewCell *)_configureCell:(USWine *)wine
{
  USWineSearchResultsCell *cell =
    (USWineSearchResultsCell *)[self.tableView dequeueReusableCellWithIdentifier
                                :
                                @"USWineSearchResultsCell"];

  cell.wineId = wine.wineId;
  cell.labelName.text = wine.name;
  cell.labelPrice.text =
    [NSString stringWithFormat:@"$%.2f",
     ([wine.averagePrice longLongValue] / 100.00)];
  cell.labelDescription.text = wine.wineDescription;

  [cell.imageView setImageWithURL:wine.wineImageUrl placeholderImage:[UIImage
                                                                      imageNamed
                                                                      :
                                                                      @"red_wine_glass.png"
   ]];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(
    NSIndexPath *)indexPath;
{
  return 127;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath
                                                                    *)indexPath
{
  if (tableView == _wineSearchController.searchResultsTableView)
  {

    self.tableView.userInteractionEnabled = NO;

    [self performSegueWithIdentifier:@"wineSearchSegue" sender:[tableView
                                                                cellForRowAtIndexPath
                                                                :indexPath]];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"wineSearchSegue"])
  {
    USWineDetailTVC *usWineDetailTVC = [segue destinationViewController];
    usWineDetailTVC.wineId = [(USWineSearchResultsCell *)sender wineId];
    usWineDetailTVC.wineImage =
      [[(USWineSearchResultsCell *)sender imageView] image];
  }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  if (![searchText isEqualToString:@""])
  {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendNetworkRequest:)                    object:nil];
    [self performSelector:@selector(sendNetworkRequest:) withObject:searchText
               afterDelay:0.5];
  }
}

- (void)sendNetworkRequest:(NSString *)searchText
{
  NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];

  [arguments setObject:@"1000" forKey:@"per_page"];
  [arguments setObject:@"true" forKey:@"autocomplete"];
  [arguments setObject:searchText forKey:@"q"];
  if (_retailerSelected)
  {
    [arguments setObject:_retailerSelected forKey:@"place_id"];
  }

  [self doNetworkRequest:arguments];
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)
  scope
{

}

#pragma mark - Search Delegate Methods

- (BOOL)   searchDisplayController:(UISearchDisplayController *)controller
  shouldReloadTableForSearchString:(NSString *)searchString
{
  [self filterContentForSearchText:searchString scope:[[_wineSearchBar
                                                        scopeButtonTitles]
                                                       objectAtIndex:[
                                                         _wineSearchBar
                                                         selectedScopeButtonIndex
                                                       ]]];

  return YES;
}

- (BOOL)  searchDisplayController:(UISearchDisplayController *)controller
  shouldReloadTableForSearchScope:(NSInteger)searchOption
{
  [self filterContentForSearchText:_wineSearchBar.text scope:
   [[_wineSearchBar scopeButtonTitles] objectAtIndex:searchOption]];

  return YES;
}


#pragma mark - Private methods

- (void)doNetworkRequest:(NSDictionary *)arguments
{

  NSURL *baseURL =
    [NSURL URLWithString:
     @"http://unscrewed-api-staging-2.herokuapp.com/api/wines"
    ];
  NSMutableArray *wineResultsArray = [[NSMutableArray alloc] init];

  AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];

  manager.responseSerializer = [AFJSONResponseSerializer serializer];

  [manager GET:[baseURL absoluteString]
    parameters:arguments
       success:^(NSURLSessionDataTask *task, id responseObject) {
    NSDictionary *response = (NSDictionary *)responseObject;

    NSArray *wines = [response objectForKey:@"wines"];

    for (NSDictionary * wine in wines)
    {

      USWine *usWine = [[USWine alloc] init];
      usWine.wineId = [wine objectForKey:@"id"];
      usWine.name =
        [[[wine objectForKey:@"name"] stringByAppendingString:@" "]
         stringByAppendingString
         :[wine objectForKey:@"year"]];

      NSString *varietal = [[wine objectForKey:@"filter_subtypes"] firstObject];
      NSString *varietalFromRegion =
        [[varietal stringByAppendingString:@" from "] stringByAppendingString:[[
                                                                                 wine
                                                                                 objectForKey
                                                                                 :
                                                                                 @"filter_regions"
                                                                               ]
      firstObject]];
      usWine.wineDescription = varietalFromRegion;

      usWine.averagePrice = [wine objectForKey:@"avg_price"];

      NSString *imageUrlString =
        [[wine objectForKey:@"photo"] objectForKey:@"url"];
      usWine.wineImageUrl = [NSURL URLWithString:imageUrlString];

      [wineResultsArray addObject:usWine];
    }

    self.wineCount = [[response objectForKey:@"wines_total"]integerValue];
    self.wineResults = wineResultsArray;
    [self.searchDisplayController.searchResultsTableView reloadData];

  } failure:^(NSURLSessionDataTask *task, NSError *error) {

    UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:
       @"Error retrieving wine list"
                                 message:[error
                                          localizedDescription
       ]
                                delegate:nil
                       cancelButtonTitle:@"Ok"
                       otherButtonTitles:nil];
    [alertView show];

  }];
}


@end
