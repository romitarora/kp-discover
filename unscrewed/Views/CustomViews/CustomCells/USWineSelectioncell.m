//
//  USWineSelectioncell.m
//  unscrewed
//
//  Created by Mario Danic on 13/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USWineSelectionCell.h"

@implementation USWineSelectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)
  reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    // Initialization code
  }

  return self;
}

- (void)awakeFromNib
{
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
