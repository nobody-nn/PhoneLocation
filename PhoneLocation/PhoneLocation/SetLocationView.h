//
//  SetLocationView.h
//  PhoneLocation
//
//  Created by girl on 13-4-22.
//  Copyright (c) 2013年 NanaZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetLocationViewController.h"

@interface SetLocationView : UIView

@property(nonatomic,retain) IBOutlet UILabel *originLabel,*toChangeLabel;
@property(nonatomic,weak) id<SetLocationDelegate> delegate;

@end
