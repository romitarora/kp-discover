//
//  USWineDetailTVC.h
//  unscrewed
//
//  Created by Rav Chandra on 21/08/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USWineDetailTVC : UITableViewController <UITextViewDelegate>

@property (strong, nonatomic) NSString *wineId;
@property (strong, nonatomic) NSString *wineName;
@property (strong, nonatomic) UIImage *wineImage;

@end
