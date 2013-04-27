//
//  ContactClass.h
//  DialTool
//
//  Created by 张 娜娜 on 11-12-7.
//  Copyright (c) 2011年 纵横万维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactClass : NSObject
{
    NSString *friendName;
    
    NSString *firstLetter;
    NSArray *phoneNumbersArray;
    NSString *firstPhoneNumber;

    int recordID;
    UIImage *headImage;
    NSMutableDictionary *locationDic;
}

@property (nonatomic,retain) NSString *friendName,*firstLetter,*firstPhoneNumber;
@property (nonatomic,assign) int recordID;
@property (nonatomic,retain) UIImage *headImage;
@property (nonatomic,retain) NSArray *phoneNumbersArray;
@property (nonatomic,retain) NSMutableDictionary *locationDic;

@end
