//
//  CommonUse.h
//  SmsManager
//
//  Created by Nana Zhang on 12-2-17.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCommonItem.h"
#import <MessageUI/MessageUI.h>

@class SmsContent,NewCommonItem;
@interface CommonUse : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>
{
    NSDictionary *tableDic;
    NSMutableArray *expandArray;
    UITableView *listTableView;
    NewCommonItem *newCommonItem;
    UIView *SendSmsTip;
}
@property(nonatomic,retain) IBOutlet UITableView *listTableView;
@property(nonatomic,retain) NSMutableArray *expandArray;
@property(nonatomic,retain) NSString *choosePhoneNum;

-(void)initTable;

@end
