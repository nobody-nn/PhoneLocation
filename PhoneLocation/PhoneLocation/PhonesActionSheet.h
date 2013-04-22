//
//  PhonesActionSheet.h
//  DialTool
//
//  Created by 艾文 李 on 11-12-17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhonesActionSheet : UIActionSheet<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *tableDataArray;
}

-(id) initWithArray:(NSArray *)phonesArray 
              title:(NSString *)title 
           delegate:(id <UIActionSheetDelegate>)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle 
destructiveButtonTitle:(NSString *)destructiveButtonTitle 
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end