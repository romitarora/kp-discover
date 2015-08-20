//
//  USActivityFeedTVC.m
//  unscrewed
//
//  Created by Rav Chandra on 19/09/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USActivityFeedTVC.h"
#import "USActivityFeedCell.h"

@interface USActivityFeedTVC ()

@end

@implementation USActivityFeedTVC

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self)
  {
  }

  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)
  section
{
  return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(
    NSIndexPath *)indexPath
{
  USActivityFeedCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"reuseActivityFeedCell"
                                    forIndexPath:indexPath];

  // Configure the cell...
  // cell.winePrice
  cell.wineName.text = @"The Wine Name";
  cell.winePrice.text = @"$29.99";
  cell.winePrice.layer.backgroundColor = [UIColor redColor].CGColor;
  [cell.winePrice.layer setCornerRadius:10.0f];
  [cell.winePrice.layer setMasksToBounds:YES];


  return cell;
}



@end
