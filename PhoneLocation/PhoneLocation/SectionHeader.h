//
//  SectionHeader.h
//  SmsManager
//
//  Created by Nana Zhang on 12-2-21.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeader : UIView
{
    UILabel *titleLabel;
    UIButton *sectionButton;
}
@property(nonatomic,retain) IBOutlet UILabel *titleLabel;
@property(nonatomic,retain) IBOutlet UIButton *sectionButton;

@end
