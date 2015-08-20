//
//  RetailerCell.m
//  Unscrewed_iOS_MOCKUP
//
//  Created by Gary Earle on 8/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USRetailerCell.h"
#import "UIImageView+AFNetworking.h"
#import "USRetailer.h"

@interface USRetailerCell ()

@property (nonatomic, strong) USRetailer *objRetailer;

@end

@implementation USRetailerCell

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
    [self.retailerImageView.layer setCornerRadius:5.f];
    [self.retailerImageView.layer setMasksToBounds:YES];
	
    [self.nameLabel setFont:[USFont placeNameFont]];
    [self.nameLabel setTextColor:[USColor colorFromHexString:@"#1F1F1F"] /*#292929*/];
    
    [self.addressLabel setFont:[USFont placeAddressFont]];
	
    //[self.addressLabel setTextColor:[USColor themeTextSubTitleColor]];
    [self.addressLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[USFont placeAddressFont].pointSize-1]];
    [self.addressLabel setTextColor:[USColor colorFromHexString:@"#7F7F7F"] /*#a8a8a8*/];
	
	[self.btnStarRetailer setImage:[UIImage imageNamed:@"stroked_star"] forState:UIControlStateNormal];
	[self.btnStarRetailer setImage:[UIImage imageNamed:@"filled_star"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)updateStarPlaceStatus:(BOOL)favourite {
	[self.btnStarRetailer setSelected:favourite];
}

- (void)fillRetailerInfo:(USRetailer *)retailer isForPlaces:(BOOL)isPlaces {
    if (isPlaces) {
        self.btnStarRetailer.hidden = YES;
    } else {
        self.btnStarRetailer.hidden = NO;
        [self.btnStarRetailer setSelected:retailer.favorited];
    }
    
    self.objRetailer = retailer;
    
    [self.nameLabel setText:retailer.name];
	
	NSMutableString *strAddress = [[NSMutableString alloc] init];
	if (retailer.address) {
		[strAddress appendString:retailer.address];
	}
	if (retailer.distance) {
		[strAddress appendFormat:@"; %@",retailer.distance];
	}
	if (strAddress.length) {
		[self.addressLabel setText:strAddress];
	}
	[self.retailerImageView setImage:nil];
    if (retailer.photoUrl) {
        NSURL *url = [NSURL URLWithString:retailer.photoUrl];
		[self.retailerImageView getImageFromURL:url placeholderImage:nil scaling:3];
    }
}

- (IBAction)btnStarRetailerEventHandler:(UIButton *)sender {
        if (self.delegate && [self.delegate respondsToSelector:@selector(retailer:stared:)]) {
        [self.delegate retailer:self.objRetailer stared:!sender.isSelected];
    }
}

@end
