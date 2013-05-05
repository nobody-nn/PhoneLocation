//
//  ViewController.h
//  PhoneLocation
//
//  Created by NanaZhang on 4/15/13.
//  Copyright (c) 2013 NanaZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonCenter,SearchViewController,MoreViewController;
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *keys;
    NSDictionary *contactsDic;
    PersonCenter *personCenter;
    SearchViewController *searchViewController;
    MoreViewController *moreViewController;
}
@property(nonatomic,strong) IBOutlet UITableView *myTableView;
@end
