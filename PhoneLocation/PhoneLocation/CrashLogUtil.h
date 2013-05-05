//
//  CrashLogUtil.h
//  Anjuke
//
//  Created by xu chao on 12-1-13.
//  Copyright (c) 2012年 anjuke. All rights reserved.
//

//#import "HttpClient.h"

@interface CrashLogUtil : NSObject//<PLHttpClientDelegate>

+ (void)writeCrashLog;//写异常日志
+ (void)logAppStart;
+ (void)logAppEnd;

+ (void)saveCrash:(NSException *)exception;
+ (BOOL)hasCrashHappen;
+ (NSArray *)getCrashLog;
+ (void)delCrashLog;

@end
