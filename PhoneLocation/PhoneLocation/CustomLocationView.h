//
//  CustomLocationView.h
//  PhoneLocation
//
//  Created by girl on 13-4-22.
//  Copyright (c) 2013年 NanaZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetLocationViewController.h"

@interface CustomLocationView : UIView

@property (nonatomic,retain) IBOutlet UILabel *originLabel;
@property (nonatomic,retain) IBOutlet UITextField *customInputField;
@property (nonatomic,weak) id<SetLocationDelegate> delegate;
@property (nonatomic,weak) SetLocationViewController *parent;

@end
