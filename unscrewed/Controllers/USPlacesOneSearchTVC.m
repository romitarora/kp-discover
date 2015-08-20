//
//  USPlacesOneSearchTVC.m
//  unscrewed
//
//  Created by Rav Chandra on 30/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USPlacesOneSearchTVC.h"
#import "USPlacesTwoTVC.h"

#import "USRetailerCell.h"
#import "USUser.h"
#import "USUserComment.h"
#import "AFNetworking.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation USPlacesOneSearchTVC

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self)
  {
    // Custom initialization
  }

  return self;
}


- (void)viewDidLoad
{
  [super viewDidLoad];

  _retailer = [[USRetailer alloc] init];
  _userComments = [[NSMutableArray alloc] init];
  _userLikes = [[NSMutableArray alloc] init];

  NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
  [arguments setObject:@"1000" forKey:@"per_page"];
  [self doNetworkRequest:arguments];

  _allPlaces = [[NSMutableArray alloc] init];
  _filteredPlaces = [[NSMutableArray alloc] init];

  // initialise search bar
  _placesSearchBar = [[UISearchBar alloc] init];
  [_placesSearchBar sizeToFit];
  _placesSearchBar.delegate = self;
  _placesSearchBar.showsCancelButton = YES;

  _placesSearchController = [[UISearchDisplayController alloc]
                             initWithSearchBar:_placesSearchBar
                             contentsController:self];
  _placesSearchController.delegate = self;
  _placesSearchController.searchResultsDataSource = self;
  _placesSearchController.searchResultsDelegate = self;
  _placesSearchController.displaysSearchBarInNavigationBar = YES;

  [_placesSearchController.navigationItem setHidesBackButton:YES];
  [_placesSearchController setActive:YES animated:YES];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  NSLog(@"cancel click");
  [self performSegueWithIdentifier:@"backToPlacesOne" sender:self];
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.placesTableView.userInteractionEnabled = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
  if ([touch.view isDescendantOfView:self.placesTableView] )
  {
    return NO;
  }

  return YES;
}

- (void)doNetworkRequest:(NSDictionary *)arguments placeID:(NSString *)placeID
{
  NSString *endpoint =
    [NSString stringWithFormat:
     @"https://unscrewed-api-staging-2.herokuapp.com/api/places/%@",
     placeID];
  NSURL *baseURL = [NSURL URLWithString:endpoint];

  AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];

  manager.responseSerializer = [AFJSONResponseSerializer serializer];

  [manager GET:[baseURL absoluteString]
    parameters:arguments
       success:^(NSURLSessionDataTask *task, id responseObject) {
    NSDictionary *response = (NSDictionary *)responseObject;

    // deserialize place object
    NSDictionary *rawPlace = [response objectForKey:@"place"];
    _retailer.name = [rawPlace objectForKey:@"name"];
    _retailer.address = [rawPlace objectForKey:@"street1"];
    _retailer.numOfDeals = [rawPlace objectForKey:@"deals_count"];
    _retailer.favorited = true;
    _retailer.retailerId = [rawPlace objectForKey:@"id"];
    _retailer.photoUrl = [[rawPlace objectForKey:@"photo"] objectForKey:@"url"];
    _retailer.zipCode = [rawPlace objectForKey:@"zip_code"];
    _retailer.city = [rawPlace objectForKey:@"city"];
    _retailer.state = [rawPlace objectForKey:@"state"];
    _retailer.type = [rawPlace objectForKeyedSubscript:@"type"];
    NSDictionary *rawWineCounts = [rawPlace objectForKey:@"wine_counts"];
    _retailer.redWines = [[rawWineCounts objectForKey:@"Red"] stringValue];
    _retailer.whiteWines = [[rawWineCounts objectForKey:@"White"] stringValue];
    NSInteger othersCount = 0;
    if ([[rawWineCounts objectForKey:@"Sparkling"] integerValue])
    {
      othersCount += [[rawWineCounts objectForKey:@"Sparkling"] integerValue];
    }
    if ([[rawWineCounts objectForKey:@"Sparkling/Champagne"] integerValue])
    {
      othersCount +=
        [[rawWineCounts objectForKey:@"Sparkling/Champagne"] integerValue];
    }
    if ([[rawWineCounts objectForKey:@"Rose"] integerValue])
    {
      othersCount += [[rawWineCounts objectForKey:@"Rose"] integerValue];
    }

    _retailer.sparklingAndOthers =
      [NSString stringWithFormat:@"%ld", (long)othersCount];

    _userComments = [[NSMutableArray alloc]init];
    // deserialize user likes
    for (NSDictionary * rawUser in [response objectForKey : @"user_likes"])
    {
      USUser *user = [[USUser alloc] init];
      user.avatar = [rawUser objectForKey:@"avatar"];
      user.userId  = [rawUser objectForKey:@"id"];
      user.name = [rawUser objectForKey:@"name"];
      user.email = [rawUser objectForKey:@"email"];
      [_userLikes addObject:user];
    }

    _userComments = [[NSMutableArray alloc]init];

    // deserialize user comments
    for (NSDictionary *
         rawComment in [response objectForKey : @"user_comments"])
    {
      USUserComment *userComment = [[USUserComment alloc] init];
      userComment.body = [rawComment objectForKey:@"body"];
      userComment.userId  = [rawComment objectForKey:@"id"];

      NSDictionary *rawUser = [rawComment objectForKey:@"user"];
      userComment.user = [[USUser alloc] init];
      userComment.user.avatar = [rawUser objectForKey:@"avatar"];
      userComment.user.userId  = [rawUser objectForKey:@"id"];
      userComment.user.name = [rawUser objectForKey:@"name"];
      userComment.user.email = [rawUser objectForKey:@"email"];
      [_userComments addObject:userComment];
    }

    [self performSegueWithIdentifier:@"placesSearchDetail" sender:self];

  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:
       @"Error Retrieving places"
                                 message:[error
                                          localizedDescription
       ]
                                delegate:nil
                       cancelButtonTitle:@"Ok"
                       otherButtonTitles:nil];
    [alertView show];
  }];
}

- (void)doNetworkRequest:(NSDictionary *)arguments
{
  NSURL *baseURL =
    [NSURL URLWithString:
     @"https://unscrewed-api-staging-2.herokuapp.com/api/places"
    ];

  AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];

  manager.responseSerializer = [AFJSONResponseSerializer serializer];


  [manager GET:[baseURL absoluteString]
    parameters:arguments
       success:^(NSURLSessionDataTask *task, id responseObject) {
    NSDictionary *response = (NSDictionary *)responseObject;

    NSArray *places = [response objectForKey:@"places"];

    for (NSDictionary * place in places)
    {

      USRetailer *retailer = [[USRetailer alloc] init];

      retailer.name = [place objectForKey:@"name"];
      retailer.address = [place objectForKey:@"street1"];
      retailer.numOfDeals = [place objectForKey:@"deals_count"];
      retailer.favorited = true;
      retailer.retailerId = [place objectForKey:@"id"];
      // NSString *type = [place objectForKey:@"type"];  // unused for now
      retailer.photoUrl = [[place objectForKey:@"photo"] objectForKey:@"url"];

      [_allPlaces addObject:retailer];
    }
    [self.placesTableView reloadData];

  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:
       @"Error Retrieving places"
                                 message:[error
                                          localizedDescription
       ]
                                delegate:nil
                       cancelButtonTitle:@"Ok"
                       otherButtonTitles:nil];
    [alertView show];

  }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath
                                                                    *)indexPath
{
  USRetailer *retailer;

  if (tableView == _placesSearchController.searchResultsTableView)
  {
    retailer = [_filteredPlaces objectAtIndex:indexPath.row];
/*    } else {
 *      retailer = [_allPlaces objectAtIndex:indexPath.row];
 *  }
 */
    NSDictionary *arguments = [[NSDictionary alloc]init];
    [self doNetworkRequest:arguments placeID:retailer.retailerId];
    self.placesTableView.userInteractionEnabled = NO;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)
  section
{
  if (tableView == _placesSearchController.searchResultsTableView)
  {
    return [_filteredPlaces count];
  } else {
    return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(
    NSIndexPath *)indexPath
{
  if (tableView == _placesSearchController.searchResultsTableView)
  {
    USRetailer *retailer = [_filteredPlaces objectAtIndex:indexPath.row];

    return [self _configureCell:retailer indexPath:indexPath];
  }

  return nil;
}

- (UITableViewCell *)_configureCell:(USRetailer *)retailer indexPath:(
    NSIndexPath *)indexPath
{

  static NSString *cellReuseIdentifier = @"USRetailerCell";

  USRetailerCell *cell =
    (USRetailerCell *)[self.tableView dequeueReusableCellWithIdentifier:
                       cellReuseIdentifier];

  if (cell == nil)
  {
    cell =
      [[USRetailerCell alloc] initWithStyle:UITableViewCellStyleDefault
       reuseIdentifier
                                           :cellReuseIdentifier];
  }


  cell.nameLabel.text = retailer.name;
  cell.addressLabel.text = retailer.address;
  cell.retailerImageView.image = nil;

  cell.btnStarRetailer.selected = retailer.favorited;
  dispatch_async(kBgQueue, ^{
    NSData *imgData =
      [NSData dataWithContentsOfURL:[NSURL URLWithString:retailer.photoUrl]];

    if (imgData)
    {
      UIImage *image = [UIImage imageWithData:imgData];
      if (image)
      {
        dispatch_async(dispatch_get_main_queue(), ^{
            USRetailerCell *updateCell =
              (id)[self.tableView cellForRowAtIndexPath: indexPath];
            if (updateCell)
            {
              updateCell.retailerImageView.image = image;
            }
          });
      }
    }

  });


  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(
    NSIndexPath *)indexPath
{
  return 90;
}

#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)
  scope
{
  [_filteredPlaces removeAllObjects];
  NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
  _filteredPlaces =
    [NSMutableArray arrayWithArray:[_allPlaces filteredArrayUsingPredicate:
                                    predicate]];
}

#pragma mark - Search Delegate Methods

- (BOOL)   searchDisplayController:(UISearchDisplayController *)controller
  shouldReloadTableForSearchString:(NSString *)searchString
{
  [self filterContentForSearchText:searchString scope:[[_placesSearchBar
                                                        scopeButtonTitles]
                                                       objectAtIndex:[
                                                         _placesSearchBar
                                                         selectedScopeButtonIndex
                                                       ]]];

  return YES;
}

- (BOOL)  searchDisplayController:(UISearchDisplayController *)controller
  shouldReloadTableForSearchScope:(NSInteger)searchOption
{
  [self filterContentForSearchText:_placesSearchBar.text scope:
   [[_placesSearchBar scopeButtonTitles] objectAtIndex:searchOption]];

  return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"placesSearchDetail"])
  {
    NSIndexPath *indexPath = [self.placesTableView indexPathForSelectedRow];
    USPlacesTwoTVC *destViewController = segue.destinationViewController;
    USRetailer *retailer = [_filteredPlaces objectAtIndex:indexPath.row];
    destViewController.exchPlaceId = retailer.retailerId;
    destViewController.retailer = _retailer;
    destViewController.userComments = _userComments;
    destViewController.userLikes = _userLikes;
  }
}

@end
