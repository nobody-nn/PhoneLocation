//
//  CustomLocationView.m
//  PhoneLocation
//
//  Created by girl on 13-4-22.
//  Copyright (c) 2013年 NanaZhang. All rights reserved.
//

#import "CustomLocationView.h"

@implementation CustomLocationView

@synthesize originLabel,customInputField,delegate,parent;

#pragma mark - actions

- (IBAction)editBegin:(id)sender
{
    [self.parent editBegin];
}

- (IBAction)editEnd:(id)sender
{
    [self.parent editEnd];
}

- (IBAction)okClick:(id)sender
{
    NSString *locationString = [customInputField text];
    if ([locationString length] != 0)
    {
        if ([self.delegate respondsToSelector:@selector(choosedLocation:)])
        {
            [self.delegate performSelector:@selector(choosedLocation:) withObject:locationString];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"内容不可为空" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - life cycle

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
