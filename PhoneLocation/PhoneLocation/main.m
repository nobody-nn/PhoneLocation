//
//  main.m
//  PhoneLocation
//
//  Created by NanaZhang on 4/15/13.
//  Copyright (c) 2013 NanaZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "CrashLogUtil.h"

int main(int argc, char *argv[])
{
    @try {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }
    @catch (NSException *exception) {
        [CrashLogUtil saveCrash:exception];
    }
}
