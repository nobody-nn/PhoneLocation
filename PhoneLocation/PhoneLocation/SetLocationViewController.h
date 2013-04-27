//
//  SetLocationViewController.h
//  PhoneLocation
//
//  Created by girl on 13-4-22.
//  Copyright (c) 2013年 NanaZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetLocationDelegate <NSObject>

@required
- (void)choosedLocation:(NSString *)location;

@end

@class SetLocationView,CustomLocationView,ContactClass,PersonCenter;
@interface SetLocationViewController : UIViewController<SetLocationDelegate>
{
    NSArray *selectedImageName;
    UIButton *preButton;
    UIView *preView;
    SetLocationView *setLocationView,*resetLocationView;
    CustomLocationView *customLocationView;
    ContactClass *thisContact;
}

@property (nonatomic,retain) ContactClass *thisContact;
//@property (nonatomic,retain) NSString *selectedPhone;
@property (nonatomic,assign) int phoneIndex;
@property(nonatomic,assign) PersonCenter *parent;

- (void)editBegin;
- (void)editEnd;

@end

