//
//  ViewController.h
//  PhoneLocation
//
//  Created by NanaZhang on 4/15/13.
//  Copyright (c) 2013 NanaZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonCenter;
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *keys;
    NSDictionary *contactsDic;
    UIImage *headImage;//默认头像
    PersonCenter *personCenter;
}
@property(nonatomic,strong) IBOutlet UITableView *myTableView;
@end
