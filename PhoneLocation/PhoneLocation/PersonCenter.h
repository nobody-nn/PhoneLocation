//
//  PersonCenter.h
//  SmsManager
//
//  Created by Nana Zhang on 12-3-20.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class ContactClass,CommonUse,SetLocationViewController;
@interface PersonCenter : UIViewController<NSXMLParserDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>
{
    int actionsType;
    UIView *SendSmsTip;
    CommonUse *commonUse;
    ContactClass *thisContact;
    SetLocationViewController *setLocation;
}
@property(nonatomic,retain) ContactClass *thisContact;
@property(nonatomic,retain) NSMutableDictionary *parserDic;

@end
