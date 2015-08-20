//
//  USPlacesOneSearchTVC.h
//  unscrewed
//
//  Created by Rav Chandra on 30/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "USRetailer.h"

@interface USPlacesOneSearchTVC : UITableViewController <UISearchBarDelegate,
                                                         UISearchDisplayDelegate,
                                                         UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *allPlaces;
@property (nonatomic, strong) NSMutableArray *filteredPlaces;

@property (nonatomic, strong) USRetailer *retailer;
@property (nonatomic, strong) NSMutableArray *userComments;
@property (nonatomic, strong) NSMutableArray *userLikes;

@property (strong, nonatomic) IBOutlet UISearchBar *placesSearchBar;
@property (strong,
           nonatomic) IBOutlet UISearchDisplayController *placesSearchController;
@property (nonatomic, strong) IBOutlet UITableView *placesTableView;

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;

@end
