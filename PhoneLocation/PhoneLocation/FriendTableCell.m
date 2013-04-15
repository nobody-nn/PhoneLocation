//
//  FriendTableCell.m
//  AvatarManager
//
//  Created by Nana Zhang on 12-1-13.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import "FriendTableCell.h"

@implementation FriendTableCell
@synthesize nameLabel,phoneNumberLabel,headImageView,contactSelected,m_checkImageView;


- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
	if (animated)
	{		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
		
		[UIView commitAnimations];
	}
	else
	{
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
	}
}

- (void) setChecked:(BOOL)checked
{
	if (checked)
	{
		m_checkImageView.image = [UIImage imageNamed:@"Selected.png"];
	}
	else
	{
		m_checkImageView.image = [UIImage imageNamed:@"Unselected.png"];
	}
	contactSelected = checked;
}

- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
	if (self.editing == editting)
	{
		return;
	}
	
	[super setEditing:editting animated:animated];
	
    if (m_checkImageView == nil)
    {
        m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unselected.png"]];
        [self addSubview:m_checkImageView];
    }
    
    [self setChecked:contactSelected];
    m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5, 
                                          CGRectGetHeight(self.bounds) * 0.5);
    m_checkImageView.alpha = 0.0;
    [self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5)
                            alpha:1.0 animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [nameLabel release];
    [phoneNumberLabel release];
    [headImageView release];
    [m_checkImageView release];
    [super dealloc];
}

@end
