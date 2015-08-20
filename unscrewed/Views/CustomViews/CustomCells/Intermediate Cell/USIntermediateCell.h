//
//  USIntermediateCell.h
//  unscrewed
//
//  Created by Ray Venenoso on 6/29/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USIntermediateCell : UITableViewCell

@property (strong, nonatomic)IBOutlet UILabel *theLabel;

- (void)fillCell:(NSString *)string;
@end

