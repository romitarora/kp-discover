//
//  WineTypeCollectionCell.h
//  unscrewed
//
//  Created by Robin Garg on 27/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USWineTypeCollectionCell : UICollectionViewCell

@property BOOL showCounter;

- (void)fillWineTypeCellInfo:(NSDictionary *)info;

@end

