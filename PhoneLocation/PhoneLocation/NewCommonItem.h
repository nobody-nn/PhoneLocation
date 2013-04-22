//
//  NewCommonItem.h
//  SmsManager
//
//  Created by Nana Zhang on 12-2-21.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUse.h"

@class CommonUse;
@interface NewCommonItem : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate>
{
    NSArray *classifyArray;
    UIPickerView *classifyPicker;
    UITextView *contentTextView;
    UIScrollView *scrollView;
}
@property(nonatomic,assign) CommonUse *parent;
@property(nonatomic,retain) IBOutlet UIPickerView *classifyPicker;
@property(nonatomic,retain) IBOutlet UITextView *contentTextView;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@end
