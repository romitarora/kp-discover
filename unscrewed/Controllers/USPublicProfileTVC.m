//
//  USPublicProfileTVC.m
//  unscrewed
//
//  Created by Rav Chandra on 8/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USPublicProfileTVC.h"

@implementation USPublicProfileTVC


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

  NSLog(@"exch user is: %@ %@ %@", _exchUserObj.name, _exchUserObj.email,
        _exchUserObj.avatar);
  _userName.text = _exchUserObj.name;
}


@end
