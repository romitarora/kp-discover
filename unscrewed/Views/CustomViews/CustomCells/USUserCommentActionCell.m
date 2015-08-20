//
//  USUserCommentActionCell
//  unscrewed
//
//  Created by Mario Danic on 13/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USUserCommentActionCell.h"

@implementation USUserCommentActionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)
  reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    // Initialization code
    self.commentUITextView = [[UITextView alloc]init];
    self.userPhotoImageView = [[UIImageView alloc]init];
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
