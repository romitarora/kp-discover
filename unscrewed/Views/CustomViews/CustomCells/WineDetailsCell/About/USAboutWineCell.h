//
//  USAboutWineCell.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 18/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USWineDetail;

@interface USAboutWineCell : UITableViewCell
{
    __weak IBOutlet UILabel *lblHeader;
    __weak IBOutlet UILabel *lblPronouncedAs;
    __weak IBOutlet UILabel *lblBestWith;
    __weak IBOutlet UILabel *lblLocation;
}

+ (CGFloat)heightWithWineDetail:(USWineDetail *)objWine;

- (void)fillAboutSection:(USWineDetail *)objWine;

@end
