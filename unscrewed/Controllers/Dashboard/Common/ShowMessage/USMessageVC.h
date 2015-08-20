//
//  USMessageVC.h
//  unscrewed
//
//  Created by Robin Garg on 04/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShowInformation) {
	ShowInformationForAboutUs,
	ShowInformationForTandC
};

@interface USMessageVC : UIViewController

@property (nonatomic, assign) ShowInformation showInfoAbout;

@end
