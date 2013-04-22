//
//  PersonCell.m
//  PhoneLocation
//
//  Created by girl on 13-4-16.
//  Copyright (c) 2013年 NanaZhang. All rights reserved.
//

#import "PersonCell.h"

@implementation PersonCell

@synthesize phoneLabel,locationLabel,setButton;

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

@end
