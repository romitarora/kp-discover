//
//  USMeSceneCell.h
//  unscrewed
//
//  Created by Mario Danic on 14/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USWineFilter;
@class USFilterValue;

@protocol USMeSceneCellDelegate;

@interface USMeSceneCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *meCellImageView;
@property (nonatomic, strong) IBOutlet UILabel *meCellMainLabel;
@property (nonatomic, strong) IBOutlet UILabel *meCellCountLabel;
@property (nonatomic, strong) IBOutlet UISwitch *switchSetting;

@property (nonatomic, weak) id<USMeSceneCellDelegate> delegate;

- (IBAction)switchValueChanged:(id)sender;

- (void)fillMeSceneCellForIndexPath:(NSIndexPath *)indexPath;

- (void)fillWinesFilterCellForFilter:(USWineFilter *)filter;
- (void)fillWineFilterValue:(USFilterValue *)objValue selected:(BOOL)selected sort:(BOOL)sort;

// My Wines Filter Cell
- (void)fillMyWinesFilterCellForIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Profile Settings Cell
- (void)setupProfileSettingsForIndexPath:(NSIndexPath *)indexPath;

@end

@protocol USMeSceneCellDelegate <NSObject>

@optional
- (void)autoFollowValueChanged;

@end
