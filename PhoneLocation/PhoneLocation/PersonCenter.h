//
//  PersonCenter.h
//  SmsManager
//
//  Created by Nana Zhang on 12-3-20.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

@class ContactClass,CommonUse,SetLocationViewController;
@interface PersonCenter : UIViewController<NSXMLParserDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,SKStoreProductViewControllerDelegate>
{
    int actionsType;
    UIView *SendSmsTip;
    CommonUse *commonUse;
    ContactClass *thisContact;
    SetLocationViewController *setLocation;
    UIView *showTips;
    UIView *netWorkTips;
    BOOL noNetWorkSinceLastCheck;
}
@property(nonatomic,retain) ContactClass *thisContact;

-(void)reloadPhoneTable;

@end
