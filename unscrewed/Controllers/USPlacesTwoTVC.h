//
//  USPlacesTwoTVC.h
//  unscrewed
//
//  Created by Rav Chandra on 30/09/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USRetailer.h"

@interface USPlacesTwoTVC : UITableViewController <UITextViewDelegate,
                                                   UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *placeImage;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *placeAddress;
@property (weak, nonatomic) IBOutlet UILabel *placeDealsCount;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIImageView *placesImage;
@property (weak, nonatomic) IBOutlet UIImageView *friendImage;

@property (strong, nonatomic) NSString *exchPlaceId;

@property (strong, nonatomic) USRetailer *retailer;
@property (nonatomic, strong) NSMutableArray *userComments;
@property (nonatomic, strong) NSMutableArray *userLikes;
@property (nonatomic, strong) NSMutableArray *userPhotos;

- (IBAction)buttonClick:(id)sender;
- (IBAction)commentUserNameClick:(id)sender;
- (IBAction)unwindFromSearchPlaces:(UIStoryboardSegue *)segue;

@end
