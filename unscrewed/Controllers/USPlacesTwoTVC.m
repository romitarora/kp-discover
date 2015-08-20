//
//  USPlacesTwoTVC.m
//  unscrewed
//
//  Created by Rav Chandra on 30/09/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USPlacesTwoTVC.h"
#import "UIImage+ImageEffects.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "USUser.h"
#import "USUserComment.h"
#import "USPlaceCommentCell.h"
#import "USWineSelectionCell.h"
#import "USWineSearchResultsTVC.h"
#import "USUserCommentActionCell.h"
#import "USPlacesAddWineCell.h"
#import "USFourBottomCell.h"
#import "USWineSearchFirstFilterTVC.h"
#import "USFriendsFollowersCell.h"
#import <QuartzCore/QuartzCore.h>
#import "USWineTabBarRootVC.h"
#import "USWineSearchTVC.h"
#import "USPublicProfileTVC.h"


@interface USPlacesTwoTVC ()

@end

@implementation USPlacesTwoTVC {
  NSString *_wineColorSelectedImplementation;
  NSString *_placesQuickSearch;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  // we only want to go directly to place once on startup/login
  ((USWineTabBarRootVC *)self.tabBarController).goDirectlyToPlaceFromLogin = NO;

  _userPhotos = [[NSMutableArray alloc] init];

  [self.tableView reloadData];
  [self updateView];

  self.friendImage.layer.cornerRadius = self.friendImage.frame.size.width / 2;
  self.friendImage.clipsToBounds = YES;

  UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(
       dismissKeyboard:)];
  tap.cancelsTouchesInView = NO;
  [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)sender
{
  [self.view endEditing:YES];
}

- (void)doNetworkRequest:(NSDictionary *)arguments action:(NSString *)
  placeAction
{


  NSURL *baseURL;
  NSString *xAuthToken;

  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"] != nil)
  {
    xAuthToken =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
  }



  if ([placeAction isEqualToString:@"userPhoto"])
  {
    baseURL =
      [NSURL URLWithString:
       @"https://unscrewed-api-staging-2.herokuapp.com/api/user"
      ];

    AFHTTPSessionManager *manager =
      [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setValue:xAuthToken forHTTPHeaderField:
     @"X-AUTH-TOKEN"];

    [manager GET:[baseURL absoluteString]
      parameters:arguments
         success:^(NSURLSessionDataTask *task, id responseObject) {
      NSDictionary *response = (NSDictionary *)responseObject;
      NSDictionary *user = [response objectForKey:@"user"];
      NSURL *avatarURL = [NSURL URLWithString:[user objectForKey:@"avatar"]];


      USUserCommentActionCell *cell =
        (USUserCommentActionCell *)[self.tableView cellForRowAtIndexPath:[
                                      NSIndexPath indexPathForRow:[_userComments
                                                                   count]
                                                        inSection:3]];
      // thumbnail rounded corner (soft)
      cell.userPhotoImageView.layer.cornerRadius =
        cell.userPhotoImageView.frame.size.width / 4;
      cell.userPhotoImageView.clipsToBounds = YES;

      // async fetch thumbnail
      __weak UIImageView *weakImageView = cell.userPhotoImageView;
      NSURLRequest *request = [NSURLRequest requestWithURL:avatarURL];
      [cell.userPhotoImageView setImageWithURLRequest:request
                                     placeholderImage:cell.userPhotoImageView.
       image
                                              success:^(NSURLRequest *request,
                                                        NSHTTPURLResponse *
                                                        response,
                                                        UIImage *image) {
          weakImageView.image = image;
        } failure:nil];

      // set image


      [cell.userPhotoImageView setImage:weakImageView.image];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
  } else if ([placeAction isEqualToString:@"makeComment"]) {
    baseURL =
      [NSURL URLWithString:[NSString stringWithFormat:
                            @"http://unscrewed-api-staging-2.herokuapp.com/api/places/%@/comments",
                            _exchPlaceId]];

    AFHTTPSessionManager *manager =
      [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setValue:xAuthToken forHTTPHeaderField:
     @"X-AUTH-TOKEN"];
    NSLog(@"dosao sam napraviti komentar");

    [manager POST:[baseURL absoluteString]
       parameters:arguments
          success:^(NSURLSessionDataTask *task, id responseObject){
      // update the table
      NSDictionary *arguments = [[NSDictionary alloc]init];
      [self doNetworkRequest:arguments action:@"updateComments"];
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
      UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:
         @"Error posting comment!"
                                   message:[error
                                            localizedDescription
         ]
                                  delegate:nil
                         cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil];
      [alertView show];

    }];
  } else if ([placeAction isEqualToString:@"updateComments"]) {
    NSString *endpoint =
      [NSString stringWithFormat:
       @"https://unscrewed-api-staging-2.herokuapp.com/api/places/%@/comments",
       _exchPlaceId];
    NSURL *baseURL = [NSURL URLWithString:endpoint];
    NSLog(@"PLACE ID : %@", _exchPlaceId);

    AFHTTPSessionManager *manager =
      [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setValue:xAuthToken forHTTPHeaderField:
     @"X-AUTH-TOKEN"];


    [manager GET:[baseURL absoluteString]
      parameters:arguments
         success:^(NSURLSessionDataTask *task, id responseObject) {
      NSDictionary *response = (NSDictionary *)responseObject;

      /*
       * // deserialize user likes
       * for (NSDictionary *rawUser in [response objectForKey:@"user_likes"]) {
       *  USUser *user = [[USUser alloc] init];
       *  user.avatar = [rawUser objectForKey:@"avatar"];
       *  user.userId  = [rawUser objectForKey:@"id"];
       *  user.name = [rawUser objectForKey:@"name"];
       *  user.email = [rawUser objectForKey:@"email"];
       *  [_userLikes addObject:user];
       * }*/

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
      [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];

  }
}

- (void)updateView
{
  self.placeName.text = _retailer.name;
  self.placeAddress.text = _retailer.address;
  // self.navigationController.navigationBar.topItem.title = _exchName;
  self.navItem.title = _retailer.name;

  // update photo image


  __weak UIImageView *weakImageView = _placeImage;
  NSURL *url = [NSURL URLWithString:_retailer.photoUrl];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [_placeImage setImageWithURLRequest:request
                     placeholderImage:_placeImage.image
                              success:^(NSURLRequest *request,
                                        NSHTTPURLResponse *response,
                                        UIImage *image) {
    weakImageView.image = image;
  } failure:nil];

  // update number of deals

  self.placeDealsCount.textColor =
    [UIColor colorWithRed:234.0 / 255.0 green:102.0 / 255.0 blue:108.0 /
     255.0          alpha:1.0];
  self.placeDealsCount.text =
    [NSString stringWithFormat:@"%@", _retailer.numOfDeals];

  // update likes
  NSUInteger numLikes = [_userLikes count];
  
  NSLog(@"BROJ LJUDI VOLI: %lu", (unsigned long)numLikes);
  USFriendsFollowersCell *cell =
    (USFriendsFollowersCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath
                                                                     indexPathForItem
                                                                     :0
                                                                     inSection:1
                               ]];

  if (numLikes == 0)
  {
    [cell.mainButton setTitle:@"No friends like this place. Be the first!"
                     forState:UIControlStateNormal];
  } else {
    NSString *likedString =
      [NSString stringWithFormat:@"%lu friends like this place",
       (unsigned long)numLikes];
    [cell.mainButton setTitle:likedString forState:UIControlStateNormal];
    [cell.mainButton addTarget:self action:@selector(buttonClick:)
              forControlEvents:UIControlEventTouchUpInside];
  }

  // thumbnails
  for (int i = 0; i < numLikes; i++)
  {
    USUser *user = [_userLikes objectAtIndex:i];
    // add another image
    UIImageView *imageView =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:
                                          @"winebottle_edna.jpg"]];
    imageView.frame = CGRectMake(i * (12 + 54) + 12, 0, 54, 54);
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.clipsToBounds = YES;
    [cell.scrollView addSubview:imageView];

    // fetch image
    __weak UIImageView *weakImageView = imageView;
    NSURL *url = [NSURL URLWithString:user.avatar];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [imageView setImageWithURLRequest:request
                     placeholderImage:imageView.image
                              success:^(NSURLRequest *request,
                                        NSHTTPURLResponse *response,
                                        UIImage *image) {
      weakImageView.image = image;
    } failure:nil];
  }
  // update scrollview width
  [cell.scrollView setContentSize:(CGSizeMake(numLikes * (12 + 54) + 12,
                                              cell.scrollView.frame.size.height))
  ];

}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma actions

- (void)callPhone:(NSString *)phoneNo
{
  NSURL *phoneURL =
    [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", phoneNo]];

  if ([[UIApplication sharedApplication] canOpenURL:phoneURL])
  {
    [[UIApplication sharedApplication] openURL:phoneURL];
  }
}

- (IBAction)buttonClick:(UIButton *)sender
{
  if ([sender.titleLabel.text hasPrefix:@"Call"])
  {
    [self callPhone:@"111"];
  } else if ([sender.titleLabel.text hasSuffix:@"like this place"]) {
    [self performSegueWithIdentifier:@"friendsSegue" sender:self];
  }

}

- (IBAction)commentUserNameClick:(id)sender
{
  [self performSegueWithIdentifier:@"userPublicProfile" sender:sender];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

  // Return the number of sections.
  return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(
    NSInteger)section
{
  if (section == 0)
  {
    return @"Categories";
  } else if (section == 1 || section == 4) {
    return @"";
  } else if (section == 3) {
    return @"Store reviews";
  } else { return @"Quick search"; }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)
  section
{
  // Return the number of rows in the section.
  if (section == 3)
  {
    if (![_retailer.type isEqualToString:@"Online"])
    {
      return [_userComments count] + 6;
    } else {
      return [_userComments count] + 5;
    }
  } else if (section == 0) {
    return 3;
  } else if (section == 2) {
    return 4;
  } else {
    return 1;
  }
}

- (NSInteger)             tableView:(UITableView *)tableView
  indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section != 2)
  {
    return [super tableView:tableView indentationLevelForRowAtIndexPath:
            indexPath];
  } else {
    return 0;
  }
}

- (UITableViewCell *)_configureWineSelectionCell:(NSIndexPath *)indexPath
{
  USWineSelectionCell *wineSelectCell =
    (USWineSelectionCell *)[self.tableView dequeueReusableCellWithIdentifier:
                            @"wineCell"                         forIndexPath:
                            indexPath];

  switch (indexPath.row)
  {
    case 0:
      wineSelectCell.nameLabel.text = @"Red wines";
      wineSelectCell.wineTypeCountLabel.text = _retailer.redWines;
      wineSelectCell.wineTypeImageView.image =
        [UIImage imageNamed:@"Red Wine Glass.svg"];
      break;

    case 1:
      wineSelectCell.nameLabel.text = @"White wines";
      wineSelectCell.wineTypeCountLabel.text = _retailer.whiteWines;
      wineSelectCell.wineTypeImageView.image =
        [UIImage imageNamed:@"White Wine Glass.svg"];
      break;

    case 2:
      wineSelectCell.nameLabel.text = @"Sparkling & others";
      wineSelectCell.wineTypeCountLabel.text = _retailer.sparklingAndOthers;
      wineSelectCell.wineTypeImageView.image =
        [UIImage imageNamed:@"Champagne Glass.svg"];
      break;
  }

  return wineSelectCell;
}

- (UITableViewCell *)_configureUserCommentCell:(NSIndexPath *)indexPath
{

  USPlaceCommentCell *cell =
    [self.tableView dequeueReusableCellWithIdentifier:@"userCommentCell"
                                         forIndexPath:indexPath];
  USUserComment *userComment = [_userComments objectAtIndex:indexPath.row];

  [cell.name setTitle:userComment.user.name forState:UIControlStateNormal];
  [cell.name setTag:(indexPath.row + 1)];
  cell.body.text = userComment.body;
  [cell.body sizeToFit];

  // thumbnail rounded corner (soft)
  cell.thumbnail.layer.cornerRadius = cell.thumbnail.frame.size.width / 4;
  cell.thumbnail.clipsToBounds = YES;

  // async fetch thumbnail
  __weak UIImageView *weakImageView = cell.thumbnail;
  NSURL *url = [NSURL URLWithString:userComment.user.avatar];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [cell.thumbnail setImageWithURLRequest:request
                        placeholderImage:cell.thumbnail.image
                                 success:^(NSURLRequest *request,
                                           NSHTTPURLResponse *response,
                                           UIImage *image) {
    weakImageView.image = image;
  } failure:nil];

  return cell;
}

- (UITableViewCell *)_configureUserCommentActionCell:(NSIndexPath *)indexPath
{
  USUserCommentActionCell *cell =
    [self.tableView dequeueReusableCellWithIdentifier:@"userCommentActionCell"
                                         forIndexPath:indexPath];

  [cell.commentUITextView.layer setBackgroundColor:[[UIColor whiteColor]CGColor]
  ];
  [cell.commentUITextView.layer setBorderColor:[[UIColor grayColor] CGColor]];
  [cell.commentUITextView.layer setBorderWidth:0.6f];
  [cell.commentUITextView.layer setCornerRadius:5.0f];
  [cell.commentUITextView.layer setMasksToBounds:YES];
  cell.commentUITextView.textColor = [UIColor lightGrayColor];

  [cell.commentUITextView setDelegate:self];
  [cell.commentUITextView setReturnKeyType:UIReturnKeySend];

  NSDictionary *arguments = [[NSDictionary alloc]init];
  [self doNetworkRequest:arguments action:@"userPhoto"];

  return cell;
}

- (UITableViewCell *)_configureAddWineCell:(NSIndexPath *)indexPath
{
  USPlacesAddWineCell *cell =
    [self.tableView dequeueReusableCellWithIdentifier:@"USPlacesAddWineCell"
                                         forIndexPath:indexPath];

  cell.nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
  cell.nameLabel.text = _retailer.name;
  cell.address1Label.text = _retailer.address;

  NSString *address2Title =
    [NSString stringWithFormat:@"%@, %@ %@", _retailer.city, _retailer.state,
     _retailer.zipCode];
  cell.address2Label.text = address2Title;

  NSString *buttonTitle =
    [NSString stringWithFormat:@"Add wine to %@", _retailer.name];

  [cell.addWineButton setTitle:buttonTitle forState:UIControlStateNormal];
  [cell.addWineButton.titleLabel setNumberOfLines:0];
  [cell.addWineButton.titleLabel setTextAlignment:NSTextAlignmentCenter];

  return cell;
}

- (UITableViewCell *)_configureFourBottomCells:(NSIndexPath *)indexPath
{
  USFourBottomCell *cell =
    [self.tableView dequeueReusableCellWithIdentifier:@"USFourBottomCell"
                                         forIndexPath:indexPath];
  NSMutableArray *array =
    [NSMutableArray arrayWithObjects:@"Get directions", @"Call",
     @"Visit website",
     @"Hours", nil];

  NSString *assembleCallText =
    [NSString stringWithFormat:@"Call %@", _retailer.type];

  if ([_retailer.type isEqualToString:@"Online"])
  {
    [array removeObjectAtIndex:0];
  } else {
    [array replaceObjectAtIndex:1 withObject:assembleCallText];
  }

  NSInteger userCommentsCount = [_userComments count];

  if (indexPath.row == userCommentsCount + 2)
  {
    [cell.mainButton setTitle:array[0] forState:UIControlStateNormal];
    if ([array[0] isEqualToString:@"Get directions"])
    {

    } else {
      cell.mainLabel.text = @"111-11";
      [cell.mainButton addTarget:self action:@selector(buttonClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
  } else if (indexPath.row == userCommentsCount + 3) {
    [cell.mainButton setTitle:array[1] forState:UIControlStateNormal];
    if ([array[1] hasPrefix:@"Call "])
    {
      cell.mainLabel.text = @"111-11";
      [cell.mainButton addTarget:self action:@selector(buttonClick:)
                forControlEvents:UIControlEventTouchUpInside];
    } else {
      cell.mainLabel.text = @"www.test.com";
    }
  } else if (indexPath.row == userCommentsCount + 4) {
    [cell.mainButton setTitle:array[2] forState:UIControlStateNormal];
    if ([array[2] isEqualToString:@"Visit website"])
    {
      cell.mainLabel.text = @"www.test.com";
    } else {
      [cell.mainButton setEnabled:NO];
      cell.mainLabel.text = @"8am - 10pm";
    }

  } else if (indexPath.row == userCommentsCount + 5) {
    [cell.mainButton setTitle:array[3] forState:UIControlStateNormal];
    cell.mainLabel.text = @"8am - 10pm";
    [cell.mainButton setEnabled:NO];
  }

  [cell.mainButton setTitleColor:[UIColor colorWithRed:153.0 /
                                  255.0          green:204.0 /
                                  255.0           blue:255.0 /
                                  255.0          alpha:1.0] forState:
   UIControlStateNormal];
  [cell.mainButton setTitleColor:[UIColor colorWithRed:153.0 /
                                  255.0          green:204.0 /
                                  255.0           blue:255.0 /
                                  255.0          alpha:1.0] forState:
   UIControlStateDisabled];

  cell.mainButton.contentHorizontalAlignment =
    UIControlContentHorizontalAlignmentLeft;

  return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(
    NSIndexPath *)indexPath
{
  UITableViewCell *cellNormal;

  if (indexPath.section == 0)
  {
    return [self _configureWineSelectionCell:indexPath];
  } else if (indexPath.section == 2) {
    switch ((indexPath.row))
    {
      case 0:
        cellNormal =
          [tableView dequeueReusableCellWithIdentifier:@"under10Cell"
                                          forIndexPath:
           indexPath];
        break;

      case 1:
        cellNormal =
          [tableView dequeueReusableCellWithIdentifier:@"90plusCell"
                                          forIndexPath:
           indexPath];
        break;

      case 2:
        cellNormal =
          [tableView dequeueReusableCellWithIdentifier:@"newCell" forIndexPath:
           indexPath];
        break;

      case 3:
        cellNormal =
          [tableView dequeueReusableCellWithIdentifier:@"pairingsCell"
                                          forIndexPath:
           indexPath];
        break;
    }

    return cellNormal;
  } else if (indexPath.section == 3) {
    if (indexPath.row < [_userComments count])
    {
      return [self _configureUserCommentCell:indexPath];
    } else if (indexPath.row == [_userComments count]) {
      return [self _configureUserCommentActionCell:indexPath];
    } else if (indexPath.row == [_userComments count] + 1) {
      return [self _configureAddWineCell:indexPath];
    } else if (indexPath.row > [_userComments count] + 1) {
      return [self _configureFourBottomCells:indexPath];

    }
  } else if (indexPath.section == 1) {
    cellNormal =
      [tableView dequeueReusableCellWithIdentifier:@"friendsFollowersView"
                                      forIndexPath:indexPath];

    return cellNormal;
  }

  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(
    NSIndexPath *)indexPath
{
  if (indexPath.section == 0)
  {
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
  } else if (indexPath.section == 2 ||
             (indexPath.section == 3 && indexPath.row > [_userComments count] +
              1)) {
    return 48;
  } else if (indexPath.section == 3 && indexPath.row == [_userComments count] +
             1) {
    return 150;
  } else { return 100; }

}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{


  if ([sender isKindOfClass:[USWineSelectionCell class]])
  {

    USWineSelectionCell *cell = sender;
    USWineSearchResultsTVC *usWineSearchResultsTVC =
      [segue destinationViewController];

    if ([cell.nameLabel.text isEqual:@"Red wines"])
    {
      _wineColorSelectedImplementation = @"Red";
      usWineSearchResultsTVC.initialSearchCategorySelected = @"reds";
    } else if ([cell.nameLabel.text isEqual:@"White wines"]) {
      _wineColorSelectedImplementation = @"White";
      usWineSearchResultsTVC.initialSearchCategorySelected = @"whites";
    } else if ([cell.nameLabel.text isEqual:@"Sparkling & others"]) {
      _wineColorSelectedImplementation = @"Sparkling";
      usWineSearchResultsTVC.initialSearchCategorySelected = @"sparkling";
    } else {
      _wineColorSelectedImplementation = @"Any";
    }

    usWineSearchResultsTVC.retailerSelected = _exchPlaceId;
    usWineSearchResultsTVC.wineColorSelected = _wineColorSelectedImplementation;

  } else if ([segue.identifier isEqualToString:@"userPublicProfile"]) {
    UIButton *button = (UIButton *)sender;
    USUserComment *userComment = [_userComments objectAtIndex:(button.tag - 1)];
    USPublicProfileTVC *destController = [segue destinationViewController];
    destController.exchUserObj = userComment.user;
  } else if ([segue.identifier isEqualToString:@"wineSearchSegue"]) {
    USWineSearchTVC *usWineSearchTVC = [segue destinationViewController];
    usWineSearchTVC.retailerSelected = _exchPlaceId;
  } else if ([segue.identifier isEqualToString:@"friendsSegue"]) {
    USWineSearchResultsTVC *destController = [segue destinationViewController];
    destController.friends = YES;
  }  /* else if ([sender isKindOfClass:[UITableViewCell class]]){
      *
      * UITableViewCell *cell = sender;
      * USWineSearchFirstFilterTVC *usWineSearchFirstFilterTVC = [segue destinationViewController];
      *
      * if (cell.tag == 10) {
      *     _placesQuickSearch = @"Under $10";
      * } else if (cell.tag == 11) {
      *     _placesQuickSearch = @"90+ Rated under $20";
      * } else if (cell.tag == 12) {
      *     _placesQuickSearch = @"New";
      * } else {
      *     _placesQuickSearch = nil;
      * }
      *
      * usWineSearchFirstFilterTVC.retailerSelected = _exchPlaceId;
      * usWineSearchFirstFilterTVC.placesSearchButtonSelected = _placesQuickSearch;
      * }*/

}

- (IBAction)unwindFromSearchPlaces:(UIStoryboardSegue *)segue
{
}


#pragma mark - Textview
- (void)textViewDidBeginEditing:(UITextView *)textView
{
  [textView becomeFirstResponder];
  [textView setText:@""];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
  replacementText:(NSString *)text
{
  if ([text isEqualToString:@"\n"])
  {
    [textView resignFirstResponder];
    NSMutableDictionary *arguments = [[NSMutableDictionary alloc]init];
    [arguments setObject:textView.text forKey:@"body"];
    [self doNetworkRequest:arguments action:@"makeComment"];
    [textView setText:@""];
  }

  return YES;
}

@end
