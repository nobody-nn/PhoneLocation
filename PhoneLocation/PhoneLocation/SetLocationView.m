//
//  SetLocationView.m
//  PhoneLocation
//
//  Created by girl on 13-4-22.
//  Copyright (c) 2013年 NanaZhang. All rights reserved.
//

#import "SetLocationView.h"

@implementation SetLocationView

@synthesize originLabel,toChangeLabel;


- (IBAction)okClick:(id)sender
{
    NSString *location = [toChangeLabel text];
    if ([self.delegate respondsToSelector:@selector(choosedLocation:)])
    {
        [self.delegate performSelector:@selector(choosedLocation:) withObject:location];
    }
}

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

@end
