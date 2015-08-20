//
//  USWineAttributePickerVC.h
//  unscrewed
//
//  Created by Gary Kipp Earle on 10/1/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USWineSearchFilter.h"

@class USWineAttributePickerVC;

@protocol USWineAttributePickerDelegate <NSObject>

- (void)pickAttributeViewController:(USWineAttributePickerVC *)controller
   didFinishPickingWineSearchFilter:(USWineSearchFilter *)wineSearchFilter;

@end

@interface USWineAttributePickerVC : UIViewController

@property (nonatomic, weak) id <USWineAttributePickerDelegate> delegate;

@property (nonatomic) NSString *pushedFromSegueName;
@property (nonatomic) NSString *wineColorSelected;
@property (nonatomic) NSString *retailerTypeSelected;

@end
