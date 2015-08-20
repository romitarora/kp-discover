//
//  USWineSearchTVC.h
//  unscrewed
//
//  Created by Mario Danic on 05/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USWineSearchTVC : UITableViewController  <UISearchBarDelegate,
                                                     UISearchDisplayDelegate,
                                                     UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *allWines;
@property (nonatomic, strong) NSMutableArray *filteredWines;

@property (nonatomic) NSString *retailerSelected;

@property (strong, nonatomic) IBOutlet UISearchBar *wineSearchBar;
@property (strong,
           nonatomic) IBOutlet UISearchDisplayController *wineSearchController;
@property (nonatomic, strong) IBOutlet UITableView *wineTableView;

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;

@end
