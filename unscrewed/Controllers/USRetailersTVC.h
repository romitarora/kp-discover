//
//  RetailerTableViewController.h
//  Unscrewed_iOS_MOCKUP
//
//  Created by Gary Earle on 8/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USRetailersTVC: UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray *fixturesStores;
@property (nonatomic, strong) NSMutableArray *fixturesRestaurants;
@property (nonatomic, strong) NSMutableArray *fixturesOnline;
@property (nonatomic, strong) NSMutableArray *filteredPlaces;

@property (weak, nonatomic) IBOutlet UISearchBar *placesSearchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *placesSearchController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentValueChanged:(id)sender;
- (IBAction)searchButtonClick:(id)sender;

@end
