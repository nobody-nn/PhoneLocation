//
//  FriendTableCell.m
//  AvatarManager
//
//  Created by Nana Zhang on 12-1-13.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import "FriendTableCell.h"

@implementation FriendTableCell
@synthesize nameLabel,phoneNumberLabel,headImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"friend table cell dealloc");
}

@end
