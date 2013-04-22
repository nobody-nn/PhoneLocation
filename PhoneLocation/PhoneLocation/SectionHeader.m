//
//  SectionHeader.m
//  SmsManager
//
//  Created by Nana Zhang on 12-2-21.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import "SectionHeader.h"

@implementation SectionHeader
@synthesize sectionButton,titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    NSLog(@"SectionHeader dealloc");
}

@end
