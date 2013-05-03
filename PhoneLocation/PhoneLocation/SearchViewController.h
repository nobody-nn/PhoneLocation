//
//  SearchViewController.h
//  PhoneLocation
//
//  Created by girl on 13-4-17.
//  Copyright (c) 2013年 NanaZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

enum SearchType {
    SearchPhone = 1,
    SearchID = 2
    };

@interface SearchViewController : UIViewController<NSXMLParserDelegate>
{
    enum SearchType type;
    BOOL storing;
}
@end
