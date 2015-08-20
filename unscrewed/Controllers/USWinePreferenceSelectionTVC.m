//
//  USWinePreferenceSelectionTVC.m
//  unscrewed
//
//  Created by Mario Danic on 20/08/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USWinePreferenceSelectionTVC.h"
#import "USWineAttributePickerVC.h"

@interface USWinePreferenceSelectionTVC ()

@end

@implementation USWinePreferenceSelectionTVC

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

  if (self.wineSearchFilters == nil)
  {
    self.wineSearchFilters = [[NSMutableArray alloc] init];
  } else {
    for (USWineSearchFilter *wineSearchFilter in self.wineSearchFilters)
    {
      [self updateFilterValueSelectedLabelForWineSearchFilter:wineSearchFilter];
    }
  }
}

- (void)viewWillDisappear:(BOOL)animated
{

  [self.delegate winePreferenceSelectionViewController:self
                   didFinishSelectingWineSearchFilters:self.wineSearchFilters];

  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate methods

- (void)pickAttributeViewController:(USWineAttributePickerVC *)controller
   didFinishPickingWineSearchFilter:(USWineSearchFilter *)wineSearchFilter
{
  if ([wineSearchFilter.apiFilterName isEqualToString:@"radius"])
  {
    if ([wineSearchFilter.filterAttributeValue isEqualToString:@"< 1 mile"])
    {
      [self.wineSearchFilters addObject:[[USWineSearchFilter alloc]
                                         initWithApiFilterName:@"radius"
                                       andFilterAttributeValue:@"1.6"]];
    } else if ([wineSearchFilter.filterAttributeValue isEqualToString:
                @"< 3 miles"]) {
      [self.wineSearchFilters addObject:[[USWineSearchFilter alloc]
                                         initWithApiFilterName:@"radius"
                                       andFilterAttributeValue:@"4.8"]];
    } else if ([wineSearchFilter.filterAttributeValue isEqualToString:
                @"< 10 miles"]) {
      [self.wineSearchFilters addObject:[[USWineSearchFilter alloc]
                                         initWithApiFilterName:@"radius"
                                       andFilterAttributeValue:@"16"]];
    }
  } else {
    [self.wineSearchFilters addObject:wineSearchFilter];
  }

  [self updateFilterValueSelectedLabelForWineSearchFilter:wineSearchFilter];
}

#pragma mark - Table view data source



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.

  USWineAttributePickerVC *usWineAttributePickerVC =
    [segue destinationViewController];

  usWineAttributePickerVC.pushedFromSegueName = [segue identifier];
  usWineAttributePickerVC.wineColorSelected = self.wineColorSelected;
  usWineAttributePickerVC.retailerTypeSelected = self.retailerTypeSelected;
  usWineAttributePickerVC.delegate = self;
}

#pragma mark - private methods

- (void)updateFilterValueSelectedLabelForWineSearchFilter:(USWineSearchFilter *)
  wineSearchFilter
{
  if ([wineSearchFilter.apiFilterName isEqualToString:@"filter_styles"])
  {
    self.styleSelectedLabel.text = wineSearchFilter.filterAttributeValue;
  } else if ([wineSearchFilter.apiFilterName isEqualToString:
              @"filter_price_ranges"]) {
    self.priceRangeSelectedLabel.text = wineSearchFilter.filterAttributeValue;
  } else if ([wineSearchFilter.apiFilterName isEqualToString:@"radius"]) {
    self.distanceSelectedLabel.text = wineSearchFilter.filterAttributeValue;
  } else if ([wineSearchFilter.apiFilterName isEqualToString:@"size"]) {
    self.sizeSelectedLabel.text = wineSearchFilter.filterAttributeValue;
  } else if ([wineSearchFilter.apiFilterName isEqualToString:@"filter_pairings"])
  {
    self.pairingSelectedLabel.text = wineSearchFilter.filterAttributeValue;
  } else if ([wineSearchFilter.apiFilterName isEqualToString:@"filter_subtypes"])
  {
    self.varietalSelectedLabel.text = wineSearchFilter.filterAttributeValue;
  } else if ([wineSearchFilter.apiFilterName isEqualToString:@"filter_regions"])
  {
    self.regionSelectedLabel.text = wineSearchFilter.filterAttributeValue;
  } else if ([wineSearchFilter.apiFilterName isEqualToString:@"year"]) {
    self.vintageSelectedLabel.text = wineSearchFilter.filterAttributeValue;
  } else if ([wineSearchFilter.apiFilterName isEqualToString:
              @"filter_expert_sources"]) {
    self.expertRatingSelectedLabel.text = wineSearchFilter.filterAttributeValue;
  } else if ([wineSearchFilter.apiFilterName isEqualToString:
              @"filter_reviewed_by"]) {
    self.reviewedBySelectedLabel.text = wineSearchFilter.filterAttributeValue;
  } else if ([wineSearchFilter.apiFilterName isEqualToString:@"filter_producers"
             ]) {
    self.producerSelectedLabel.text = wineSearchFilter.filterAttributeValue;
  }
}

@end
