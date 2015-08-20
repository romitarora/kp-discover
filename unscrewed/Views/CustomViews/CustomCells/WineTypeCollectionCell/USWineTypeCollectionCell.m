//
//  WineTypeCollectionCell.m
//  unscrewed
//
//  Created by Robin Garg on 27/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USWineTypeCollectionCell.h"

@interface USWineTypeCollectionCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgViewWineType;
@property (nonatomic, weak) IBOutlet UIView *viewContainer;

@end

@implementation USWineTypeCollectionCell

- (void)awakeFromNib {
    // Initialization code
	[self.viewContainer.layer setCornerRadius:5.f];
	[self.viewContainer.layer setMasksToBounds:YES];
	[self.imgViewWineType setBackgroundColor:[UIColor purpleColor]];
    [self.layer setMasksToBounds:NO];
    
}

- (void)fillWineTypeCellInfo:(NSDictionary *)info {
    
    //For counter
    /*
    if(self.showCounter == YES){
        [[self viewWithTag:88] removeFromSuperview];
        UILabel *counter = [[UILabel alloc] init];
        NSString *counterTxt = @"0";
        [counter setBackgroundColor:[UIColor blackColor]];
        [counter setTextColor:[UIColor whiteColor]];
        [counter setTextAlignment:NSTextAlignmentCenter];
        [counter setFont:[UIFont systemFontOfSize:10]];
        [counter setClipsToBounds:YES];
        [counter.layer setCornerRadius:3];
        counter.tag = 88;
        
        if([[info valueForKey:@"title"] isEqual:@"red"]){
            counterTxt = @"328"; //sample number badge
        }else if([[info valueForKey:@"title"] isEqual:@"white"]){
            counterTxt = @"95"; //sample number badge
        }else if([[info valueForKey:@"title"] isEqual:@"sparkling"]){
            counterTxt = @"2"; //sample number badge
        }else {
            counterTxt = @"0"; //sample number badge
        }
        
        CGSize txtSize = [counterTxt sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
        counter.text = counterTxt;
        float gap = 4; //Padding
        float badgeWidth = MAX(txtSize.width+(gap*2), 25);
        counter.frame = CGRectMake(self.frame.size.width-(badgeWidth)-1+gap, self.frame.size.height-(txtSize.height+(gap))-1,badgeWidth, txtSize.height+(gap*2));
        
        if([counterTxt isEqual:@"0"]){
            counter.hidden = YES;
        }
        [self addSubview:counter];
    }
     */
    
	[self.imgViewWineType setImage:[UIImage imageNamed:[info valueForKey:kImageNameKey]]];
}

@end
