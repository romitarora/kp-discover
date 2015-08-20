//
//  USInputVC.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 25/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"

typedef NS_ENUM(NSInteger, InputType) {
	InputTypeUsername,
	InputTypeBio,
	InputTypeEmail,
	InputTypePrice
};

@protocol USInputVCDelegate <NSObject>

- (void)inputBoxValueEntered:(NSString*)value;

@end

@interface USInputVC : UIViewController
{
    __weak IBOutlet SZTextView *txtInputView;
    __weak IBOutlet UIView *viewContainer;
}

@property (nonatomic, strong) id <USInputVCDelegate> delegate;

@property (nonatomic, assign) InputType inputType;

@property(nonatomic, strong)NSString *placeHolderText;
@property(nonatomic, strong) NSString *selectedText;
@property(nonatomic, assign)REQUIRED_KEYBOARD_TYPE keyboardType;

@end
