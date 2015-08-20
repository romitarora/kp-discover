//
//  USWinePreferenceSelectionTVC.h
//  unscrewed
//
//  Created by Mario Danic on 20/08/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
#import "USWineAttributePickerVC.h"
#import "USWineSearchFilter.h"

@class USWinePreferenceSelectionTVC;

@protocol USWinePreferenceSelectionDelegate <NSObject>

- (void)   winePreferenceSelectionViewController:(USWinePreferenceSelectionTVC *)
  controller didFinishSelectingWineSearchFilters:(NSMutableArray *)
  wineSearchFilters;

@end

@interface USWinePreferenceSelectionTVC : UITableViewController <
    USWineAttributePickerDelegate>

@property (nonatomic) NSMutableArray *wineSearchFilters;

@property (nonatomic, weak) id <USWinePreferenceSelectionDelegate> delegate;

// @property (nonatomic) NSMutableDictionary * wineAttributesDictionary;
@property (nonatomic) NSArray *distanceAttributeCollection;

@property (nonatomic) NSString *initialSearchCategorySelected;
@property (nonatomic) NSString *wineColorSelected;
@property (nonatomic) NSString *retailerTypeSelected;


@property (weak, nonatomic) IBOutlet UILabel *styleSelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRangeSelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceSelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeSelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *pairingSelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *varietalSelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionSelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *vintageSelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertRatingSelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewedBySelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *producerSelectedLabel;



// @property (weak, nonatomic) IBOutlet UIButton* lightAndFruityButton;
// @property (weak, nonatomic) IBOutlet UIButton* smoothAndEasyButton;
// @property (weak, nonatomic) IBOutlet UIButton* bigAndBoldButton;
//
// @property (weak, nonatomic) IBOutlet UIButton* lightAndCrispButton;
// @property (weak, nonatomic) IBOutlet UIButton* fullAndSmoothButton;
//
// @property (weak, nonatomic) IBOutlet UIButton* bottleAnyPriceButton;
// @property (weak, nonatomic) IBOutlet UIButton* bottleUnder50Button;
// @property (weak, nonatomic) IBOutlet UIButton* bottle50To100Button;
// @property (weak, nonatomic) IBOutlet UIButton* bottleOver100Button;
//
// @property (weak, nonatomic) IBOutlet UIButton* glassAnyPriceButton;
// @property (weak, nonatomic) IBOutlet UIButton* glassUnder10Button;
// @property (weak, nonatomic) IBOutlet UIButton* glass10To20Button;
// @property (weak, nonatomic) IBOutlet UIButton* glassOver20Button;

@end
