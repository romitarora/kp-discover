//
//  USPlaceCommentCell.m
//  unscrewed
//
//  Created by Rav Chandra on 13/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USPlaceCommentCell.h"

@implementation USPlaceCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)
  reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    self.name = [[UIButton alloc]init];
    self.body = [[UILabel alloc]init];
    self.thumbnail = [[UIImageView alloc]init];
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
