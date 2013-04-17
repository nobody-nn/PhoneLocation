//
//  PersonCenter.h
//  SmsManager
//
//  Created by Nana Zhang on 12-3-20.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactClass;
@interface PersonCenter : UIViewController<NSXMLParserDelegate>

@property(nonatomic,retain) ContactClass *thisContact;
@property(nonatomic,retain) NSMutableDictionary *parserDic;

@end
