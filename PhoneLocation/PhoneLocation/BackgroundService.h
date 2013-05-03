//
//  BackgroundService.h
//  DialTool
//
//  Created by 张 娜娜 on 11-12-7.
//  Copyright (c) 2011年 纵横万维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface BackgroundService : NSObject
{
    NSDictionary *words;
}
-(void)readLocalAddress;
+(NSString *)getNumeralWith:(NSString *)originString;
+(NSString *)getCorrectIDWith:(NSString *)originString;

@end
