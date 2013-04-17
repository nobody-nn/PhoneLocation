//
//  ContactClass.m
//  DialTool
//
//  Created by 张 娜娜 on 11-12-7.
//  Copyright (c) 2011年 纵横万维. All rights reserved.
//

#import "ContactClass.h"

@implementation ContactClass

@synthesize friendName,firstLetter,firstPhoneNumber,recordID,headImage,phoneNumbersArray;

-(void) dealloc
{
    NSLog(@"ContactClass dealloc");
}

@end
