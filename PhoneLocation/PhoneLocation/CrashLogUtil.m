//
//  CrashLogUtil.m
//  Anjuke
//
//  Created by xu chao on 12-1-13.
//  Copyright (c) 2012年 anjuke. All rights reserved.
//

#import "CrashLogUtil.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#import "UIDevice+PL.h"

@implementation CrashLogUtil

+ (NSString *)pathStartEnd{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
            stringByAppendingPathComponent:@"appStartEnd.plist"];
}

+ (NSString *)pathCrashReport {
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
            stringByAppendingPathComponent:@"crash.plist"];
}

+ (void)logAppStart{
    //应用启动记录
    NSData *now = [NSDate date];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:now,@"startTime", now,@"endTime",nil];
    [dic writeToFile:[CrashLogUtil pathStartEnd] atomically:YES];
}

+ (void)logAppEnd{
    //应用结束记录
    if ([[NSFileManager defaultManager] fileExistsAtPath:[CrashLogUtil pathStartEnd]]) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithContentsOfFile:[CrashLogUtil pathStartEnd]];
        [mutDic setValue:[NSDate date] forKey:@"endTime"];
        [mutDic writeToFile:[CrashLogUtil pathStartEnd] atomically:YES];
    }
}

+ (void) handleCrashReport:(NSMutableDictionary *)dicLog {
    NSArray *crashReports = [self getCrashLog];
    [dicLog setValue:crashReports forKey:@"Crash"];
}

+ (NSArray *)getCrashLog {
    if ([self hasCrashHappen]) {
        return [NSArray arrayWithContentsOfFile:[self pathCrashReport]];
    }
    return nil;
}

+ (void)delCrashLog {
    [[NSFileManager defaultManager] removeItemAtPath:[self pathCrashReport] error:nil];
}

+ (BOOL)hasCrashHappen{
    //是否有崩溃日志
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathCrashReport]])
        return YES;
    
    return NO;
}

+ (NSString *)getUseTime{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[CrashLogUtil pathStartEnd]]) {
        NSDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:[CrashLogUtil pathStartEnd]];
        NSDate *dateStart = (NSDate *)[dic objectForKey:@"startTime"];
        NSDate *dateEnd = (NSDate *)[dic objectForKey:@"endTime"];
        return [NSString stringWithFormat:@"%d",(int)[dateEnd timeIntervalSinceDate:dateStart]];
    }
    return @"";
}

+ (void)writeCrashLog{

    //判断文件是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:[CrashLogUtil pathStartEnd]]) {
        
        //crash info
        BOOL hasCrash = [CrashLogUtil hasCrashHappen];
        if (hasCrash) {
            NSMutableDictionary *dicLog = [NSMutableDictionary dictionaryWithCapacity:10];
            
            UIDevice* device = [UIDevice currentDevice];

            [dicLog setValue:[device platformString]                    forKey:@"AppPlatform"];
            [dicLog setValue:[device currentVersion]                    forKey:@"AppVersion"];
            [dicLog setValue:[[UIDevice currentDevice] systemVersion]   forKey:@"OSVersion"];
            
            NSDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:[CrashLogUtil pathStartEnd]];
            
            //得到date的三个部分
            [dicLog setValue:[NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]] forKey:@"DateTime"];
            
            NSDate *dateStart = (NSDate *)[dic objectForKey:@"startTime"];
            NSTimeInterval intervalStart = [dateStart timeIntervalSince1970];
            [dicLog setValue:[NSString stringWithFormat:@"%d",(int)intervalStart] forKey:@"start_date"];
            
            NSDate *dateEnd = (NSDate *)[dic objectForKey:@"endTime"];
            NSTimeInterval intervalEnd = [dateEnd timeIntervalSince1970];
            [dicLog setValue:[NSString stringWithFormat:@"%d",(int)intervalEnd] forKey:@"end_date"];
            
            [self handleCrashReport:dicLog];
            
            //write crash log
            NSLog(@"--------------------- crash log --------------------\n%@", dicLog);
            [self delCrashLog];
        }
    }
    
    //log start time
    [CrashLogUtil logAppStart];
}

+ (void)saveCrash:(NSException *)exception {
 
    NSString *detail;
    if (((int)([[[UIDevice currentDevice] systemVersion] floatValue])) <= 4) {
        detail = @"";
    }
    else {
        detail = [[exception callStackSymbols] componentsJoinedByString:@"\n"];
    }
    
    NSString *reason    = [NSString stringWithFormat:@"%@",[exception reason]];
    NSString *name      = [exception name];
    NSString *time      = [NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]];
    
    NSMutableDictionary *crash = [NSMutableDictionary dictionary];
    [crash setValue:reason                  forKey:@"Title"];
    [crash setValue:detail                  forKey:@"Detail"];
    [crash setValue:time                    forKey:@"Time"];
    
    NSMutableArray *crashReport;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathCrashReport]]) {
        crashReport = [NSMutableArray arrayWithContentsOfFile:[self pathCrashReport]];
    }
    else {
        crashReport = [NSMutableArray array];
    }
    
    [crashReport addObject:crash];
    [crashReport writeToFile:[self pathCrashReport] atomically:YES];
    
    NSString *log = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\ntime:\n%@\nreason:\n%@\ncallStackSymbols:\n%@", name, time, reason, detail];
    
    NSLog(@"%@",log);
}

@end
