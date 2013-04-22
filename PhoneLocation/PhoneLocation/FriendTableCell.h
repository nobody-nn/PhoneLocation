//
//  FriendTableCell.h
//  AvatarManager
//
//  Created by Nana Zhang on 12-1-13.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableCell : UITableViewCell
{
    UILabel *nameLabel,*phoneNumberLabel;
    UIImageView *headImageView;
}
@property(nonatomic,retain) IBOutlet UILabel *nameLabel,*phoneNumberLabel;
@property(nonatomic,retain) IBOutlet UIImageView *headImageView;

@end
