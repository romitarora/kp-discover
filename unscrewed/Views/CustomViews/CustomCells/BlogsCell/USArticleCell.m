//
//  USArticleCell.m
//  unscrewed
//
//  Created by Mario Danic on 28/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USArticleCell.h"
#import "UIImageView+AFNetworking.h"
#import "USPost.h"

@interface USArticleCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblPostedBefore;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBlog;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *textViewDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end

@implementation USArticleCell

+ (CGFloat)descriptionHeightForPost:(USPost *)objPost {
	CGRect rect = [objPost.body boundingRectWithSize:CGSizeMake(310, CGFLOAT_MAX)
													options:NSStringDrawingUsesLineFragmentOrigin
												 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
                                                                  //[USFont blogDescriptionFont]} context:nil];
	return ceilf(CGRectGetHeight(rect));
}

+ (CGFloat)titleHeightForPost:(USPost *)objPost {
    CGRect rect = [objPost.title boundingRectWithSize:CGSizeMake(310, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:24]} context:nil];
    return ceilf(CGRectGetHeight(rect));
}

+ (CGFloat)cellHeightForPost:(USPost *)objPost {
    return 285.f + [self titleHeightForPost:objPost] ;//+12+ [self descriptionHeightForPost:objPost]; //0.f + [self descriptionHeightForPost:objPost];
}

- (void)awakeFromNib {
	[self.imageViewUserProfile.layer setCornerRadius:CGRectGetHeight(self.imageViewUserProfile.frame)/2.f];
	[self.imageViewUserProfile setClipsToBounds:YES];
	
	[self.lblUserName setFont:[USFont blogUserNameFont]];
	[self.lblPostedBefore setFont:[USFont blogPostedTimeFont]];
    //[self.lblTitle setFont:[USFont blogTitleFont]];
    [self.lblTitle setFont:[UIFont boldSystemFontOfSize:24]];
	[self.textViewDesc setFont:[USFont blogDescriptionFont]];
    //[self.lblDescription setFont:[USFont blogDescriptionFont]];
    [self.lblDescription setFont:[UIFont systemFontOfSize:15]];
	
	[self.lblPostedBefore setTextColor:[USColor themeTextSubTitleColor]];
	[self.lblTitle setTextColor:[UIColor blackColor]];
	//[self.textViewDesc setTextColor:[USColor themeTextSubTitleColor]];
    [self.lblDescription setTextColor:[USColor themeTextSubTitleColor]];
    [self.textViewDesc setTextColor:[UIColor redColor]];
    
    
    [self.textViewDesc setBackgroundColor:[UIColor clearColor]];
    //[self.lblTitle setBackgroundColor:[UIColor blueColor]];
    //[self.lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
    
    //[self setGradient];
    
    
    //[self setBackgroundColor:[UIColor redColor]];
}

- (void)setGradient {
    //NSArray *colors = [NSArray arrayWithObjects:[UIColor clearColor],[UIColor clearColor], [UIColor clearColor],[UIColor colorWithWhite:0.0/255.0 alpha:.7f], nil];
    //NSArray *colors = [NSArray arrayWithObjects:[UIColor colorWithWhite:0.0/255.0 alpha:.7f], [UIColor colorWithWhite:0.0/255.0 alpha:.3f], [UIColor colorWithWhite:0.0/255.0 alpha:.0f],[UIColor colorWithWhite:0.0/255.0 alpha:.0f],[UIColor colorWithWhite:0.0/255.0 alpha:.3f],[UIColor colorWithWhite:0.0/255.0 alpha:.6f], nil];
    
    NSArray *colors = [NSArray arrayWithObjects:[UIColor colorWithWhite:0.0/255.0 alpha:.0f], [UIColor colorWithWhite:0.0/255.0 alpha:.0f], [UIColor colorWithWhite:0.0/255.0 alpha:.0f],[UIColor colorWithWhite:0.0/255.0 alpha:.0f], [UIColor colorWithWhite:0.0/255.0 alpha:.0f],[UIColor colorWithWhite:0.0/255.0 alpha:.3f],[UIColor colorWithWhite:0.0/255.0 alpha:.7f], nil];
    self.gradientView.colors = colors;
}


- (void)fillPostInfo:(USPost *)objPost {
	[self.imageViewUserProfile setImage:[UIImage imageNamed:@"unBlogIcon-new1"]];
	if (objPost.authorAvtar) {
		[self.imageViewUserProfile setImageWithURL:[NSURL URLWithString:objPost.authorAvtar]];
	}
	[self.lblUserName setText:objPost.authorName];
	[self.lblPostedBefore setText:[HelperFunctions blogFormattedDateString:objPost.updatedAt]];
	
	self.lblTitle.text = objPost.title;
    /**
     *  manage y position of lblTitle based on number of lines text
     */
    CGRect rect = self.lblTitle.frame;
    //CGRect textRect = [objPost.title rectWithSize:CGSizeMake(CGRectGetWidth(self.lblTitle.frame), CGFLOAT_MAX) font:self.lblTitle.font];
    
    
    // use font information from the UILabel to calculate the size
    //CGSize expectedLabelSize = [objPost.title sizeWithFont:self.lblTitle.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    
    CGRect textRect = [objPost.title boundingRectWithSize:CGSizeMake(310, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:24]} context:nil];
    //CGFloat labelHeight = ceilf(CGRectGetHeight(textRect));
    //CGFloat maxLineHeight = ceilf(self.lblTitle.font.lineHeight) * 2;
    rect.size.height = textRect.size.height;//labelHeight; //MIN(labelHeight, maxLineHeight);
    rect.origin.y = CGRectGetMaxY(self.imageViewBlog.frame) + 12; //+ CGRectGetHeight(rect) - 13.f/*Padding*/;
    self.lblTitle.frame = rect;

	CGRect rectDesc = self.textViewDesc.frame;
	rectDesc.size.height = [USArticleCell descriptionHeightForPost:objPost];
    rectDesc.origin.y = rect.origin.y + CGRectGetHeight(rect);
	self.textViewDesc.frame = rectDesc;

	NSString *htmlString = [NSString stringWithFormat:@"<html><head><style>a {color: rgb(253,60,87);}</style></head><body style=\"font-family:HelveticaNeue; font-size:14px\">%@</body></html>",objPost.body];
	NSMutableAttributedString *attributedString =
	[[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
									 options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
						  documentAttributes:nil
									   error:nil];
	
	self.textViewDesc.attributedText = attributedString;
    
    self.textViewDesc.hidden = YES;
    [self.btnReadit setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.btnFindthewine setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.btnFindthewineIcon setTranslatesAutoresizingMaskIntoConstraints:YES];
	
    self.btnReadit.frame = CGRectMake(self.btnReadit.frame.origin.x, self.textViewDesc.frame.origin.y+10, self.btnReadit.frame.size.width, self.btnReadit.frame.size.height);
    self.btnFindthewine.frame = CGRectMake(self.btnFindthewine.frame.origin.x, self.textViewDesc.frame.origin.y+10, self.btnFindthewine.frame.size.width, self.btnFindthewine.frame.size.height);
    self.btnFindthewineIcon.frame = CGRectMake(self.btnFindthewine.frame.origin.x, self.btnFindthewine.frame.origin.y, self.btnFindthewineIcon.frame.size.width, self.btnFindthewineIcon.frame.size.height);
    
	[self.imageViewBlog setImage:nil];
	if (objPost.photoUrl) {
		[self.imageViewBlog setImageWithURL:[NSURL URLWithString:objPost.photoUrl]];
	}
    
    //NSLog(@" TITLE = %@", self.lblTitle.text);
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Text View Delegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
	//DLog(@"url = %@",URL);
	//DLog(@"Range = %@",[NSValue valueWithRange:characterRange]);
	return YES;
}

@end
