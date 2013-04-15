//
//  CommonUse.h
//  SmsManager
//
//  Created by Nana Zhang on 12-2-17.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmsContent.h"
#import "NewCommonItem.h"

@class SmsContent,NewCommonItem;
@interface CommonUse : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *tableDic;
    SmsContent *superViewController;
    NSMutableArray *expandArray;
    UITableView *listTableView;
    NewCommonItem *newCommonItem;
}
@property(nonatomic,assign) SmsContent *superViewController;
@property(nonatomic,retain) IBOutlet UITableView *listTableView;
@property(nonatomic,retain) NSMutableArray *expandArray;

-(void)initTable;

@end
